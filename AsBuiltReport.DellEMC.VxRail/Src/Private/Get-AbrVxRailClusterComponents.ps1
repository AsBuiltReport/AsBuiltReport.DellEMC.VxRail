function Get-AbrVxRailClusterComponents {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster component information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailClusterComponents
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>
    [CmdletBinding()]
    param (
    )

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailClusterComponents
        Write-PScriboMessage $LocalizedData.Collecting
    }

    process {
        Try {
            Write-PScriboMessage $LocalizedData.ApiCall
            $VxrSystem = Get-VxRailApi -Version 1 -Uri '/system'
            $VxrComponents = $VxrSystem.installed_components | Sort-Object Name
            if ($VxrComponents) {
                Section -Style Heading3 $LocalizedData.Heading {
                    $VxrInstalledComponents = foreach ($VxrComponent in $VxrComponents) {
                        [PSCustomObject]@{
                            $LocalizedData.Name = $VxrComponent.Name
                            $LocalizedData.Description = $VxrComponent.description
                            $LocalizedData.Version = $VxrComponent.current_version
                            $LocalizedData.AvailableUpdates = Switch ($VxrComponent.upgrade_status) {
                                $null { $LocalizedData.NoUpdateAvailable }
                                'Err_Download' { $LocalizedData.DownloadError }
                                'Has_Newer' { $LocalizedData.UpdateAvailable }
                                default { $TextInfo.ToTitleCase($VxrComponent.upgrade_status.ToLower()) }
                            }
                        }
                    }
                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxRailMgrHostName)
                        ColumnWidths = 25, 25, 25, 25
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrInstalledComponents | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
