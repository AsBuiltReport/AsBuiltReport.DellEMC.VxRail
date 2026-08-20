function Get-AbrVxRailHostNic {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail NIC information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailHostNic -VxrHost $VxrHost
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
        $LocalizedData = $reportTranslate.GetAbrVxRailHostNic
        Write-PScriboMessage ($LocalizedData.Collecting -f $VxrHost.hostname)
    }

    process {
        Try {
            $VxrHostNics = $VxrHost.nics | Sort-Object slot
            if ($VxrHostNics) {
                Section -Style NOTOCHeading4 -ExcludeFromTOC $LocalizedData.Heading {
                    $VxrHostNicInfo = foreach ($VxrHostNic in $VxrHostNics) {
                        [PSCustomObject]@{
                            $LocalizedData.Nic = $VxrHostNic.slot
                            $LocalizedData.MacAddress = $VxrHostNic.mac
                            $LocalizedData.LinkSpeed = $VxrHostNic.link_speed
                            $LocalizedData.LinkStatus = $VxrHostNic.link_status
                            $LocalizedData.Firmware = $VxrHostNic.firmware_family_version
                        }
                    }
                    if ($Healthcheck.Appliance.NetworkLinkStatus) {
                        $VxrHostNicInfo | Where-Object { $_.($LocalizedData.LinkStatus) -ne 'Up' } | Set-Style -Style Critical -Property $LocalizedData.LinkStatus
                    }
                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxrHost.hostname)
                        ColumnWidths = 15, 25, 20, 20, 20
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrHostNicInfo | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
