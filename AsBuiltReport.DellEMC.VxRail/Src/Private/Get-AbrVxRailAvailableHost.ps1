function Get-AbrVxRailAvailableHost {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail available host information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailAvailableHost
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>
    [CmdletBinding()]
    param (
    )

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailAvailableHost
        Write-PScriboMessage $LocalizedData.Collecting
    }

    process {
        Write-PScriboMessage $LocalizedData.ApiCall
        Try {
            $VxrAvailableHosts = Get-VxRailApi -Version 1 -Uri '/system/available-hosts'
            if ($VxrAvailableHosts) {
                Section -Style Heading3 $LocalizedData.Heading {
                    $VxrAvailableHostInfo = foreach ($VxrAvailableHost in ($VxrAvailableHosts | Sort-Object serial_number)) {
                        [PSCustomObject]@{
                            $LocalizedData.ServiceTag = $VxrAvailableHost.serial_number
                            $LocalizedData.ApplianceID = $VxrAvailableHost.appliance_id
                            $LocalizedData.Model = $VxrAvailableHost.model
                            $LocalizedData.DiscoveredDate = (ConvertFrom-Epoch $VxrAvailableHost.discovered_date).ToLocalTime()
                        }
                    }
                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxRailMgrHostName)
                        ColumnWidths = 25, 25, 25, 25
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrAvailableHostInfo | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
