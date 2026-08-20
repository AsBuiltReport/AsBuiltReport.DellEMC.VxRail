function Get-AbrVxRailHostHardware {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail hardware information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailHostHardware -VxrHost $VxrHost
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHost
    )

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailHostHardware
        Write-PScriboMessage ($LocalizedData.Collecting -f $VxrHost.hostname)
    }

    process {
        Try {
            if ($VxrHost) {
                Section -Style NOTOCHeading4 -ExcludeFromTOC $LocalizedData.Heading {
                    $VxrHostHW = [PSCustomObject]@{
                        $LocalizedData.Hostname = $VxrHost.hostname
                        $LocalizedData.Manufacturer = $VxrHost.Manufacturer
                        $LocalizedData.Model = $VxrClusterHost.Model
                        $LocalizedData.SerialNumber = $VxrHost.sn
                        $LocalizedData.ApplianceID = $VxrHost.psnt
                        $LocalizedData.Slot = $VxrHost.slot
                        $LocalizedData.PowerStatus = $TextInfo.ToTitleCase($VxrHost.power_status)
                        $LocalizedData.Connected = Switch ($VxrHost.missing) {
                            $true { $LocalizedData.No }
                            $false { $LocalizedData.Yes }
                        }
                        $LocalizedData.TpmPresent = Switch ($VxrHost.tpm_present) {
                            $true { $LocalizedData.No }
                            $false { $LocalizedData.Yes }
                        }
                        $LocalizedData.HealthStatus = $VxrHost.health
                        $LocalizedData.OperationStatus = Switch ($VxrHost.operational_status) {
                            'normal' { $LocalizedData.Available }
                            'powering_off' { $LocalizedData.PoweringOff }
                            default { $TextInfo.ToTitleCase($VxrHost.operational_status) }
                        }
                    }
                    if ($Healthcheck.Appliance.PowerStatus) {
                        $VxrHostHW | Where-Object { $_.($LocalizedData.PowerStatus) -ne 'On' } | Set-Style -Style Critical -Property $LocalizedData.PowerStatus
                    }
                    if ($Healthcheck.Appliance.HealthStatus) {
                        $VxrHostHW | Where-Object { $_.($LocalizedData.HealthStatus) -eq 'Warning' } | Set-Style -Style Warning -Property $LocalizedData.HealthStatus
                        $VxrHostHW | Where-Object { $_.($LocalizedData.HealthStatus) -eq 'Error' } | Set-Style -Style Critical -Property $LocalizedData.HealthStatus

                    }
                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxrHost.hostname)
                        List = $true
                        ColumnWidths = 40, 60
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrHostHW | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
