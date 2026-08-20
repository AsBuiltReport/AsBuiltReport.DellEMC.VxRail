function Get-AbrVxRailHostPsu {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail PSU information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailHostPsu -VxrHostChassis $VxrHostChassis
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHostChassis
    )

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailHostPsu
        Write-PScriboMessage ($LocalizedData.Collecting -f $VxrHostChassis.sn)
    }

    process {
        Try {
            $VxrHostPSUs = $VxrHostChassis.power_supplies | Sort-Object slot
            if ($VxrHostPSUs) {
                Section -Style NOTOCHeading4 -ExcludeFromTOC $LocalizedData.Heading {
                    $VxrHostPsuInfo = foreach ($VxrHostPSU in $VxrHostPSUs) {
                        [PSCustomObject]@{
                            $LocalizedData.Psu = $VxrHostPSU.slot
                            $LocalizedData.Manufacturer = $VxrHostPSU.manufacturer
                            $LocalizedData.SerialNumber = $VxrHostPSU.sn
                            $LocalizedData.PartNumber = $VxrHostPSU.part_number
                            $LocalizedData.Health = $VxrHostPSU.health
                            $LocalizedData.Revision = $VxrHostPSU.revision_number
                        }
                    }
                    if ($Healthcheck.Appliance.PowerSupply) {
                        $VxrHostPsuInfo | Where-Object { $_.($LocalizedData.Health) -ne 'Healthy' } | Set-Style -Style Critical -Property $LocalizedData.Health
                    }
                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxrHostChassis.sn)
                        ColumnWidths = 8, 18, 24, 22, 14, 14
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrHostPsuInfo | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
