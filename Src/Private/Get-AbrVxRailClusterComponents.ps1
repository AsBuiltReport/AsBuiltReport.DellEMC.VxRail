function Get-AbrVxRailClusterComponents {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster component information from the VxRail Manager API
    .DESCRIPTION

    .NOTES
        Version:        0.1.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE

    .LINK

    #>
    [CmdletBinding()]
    param (
    )

    begin {
        Write-PscriboMessage "Collecting VxRail cluster component information."
    }

    process {
        Write-PScriboMessage "Performing API reference call to path /system"
        $VxrSystem = Get-VxRailApi -Version 1 -Uri '/system'
        $VxrComponents = $VxrSystem.installed_components | Sort-Object Name
        if ($VxrComponents) {
            Section -Style Heading3 'Installed Components' {
                $VxrInstalledComponents = foreach ($VxrComponent in $VxrComponents) {
                    [PSCustomObject]@{
                        'Name' = $VxrComponent.Name
                        'Description' = $VxrComponent.description
                        'Version' = $VxrComponent.current_version
                        'Available Updates' = Switch ($VxrComponent.upgrade_status) {
                            $null { 'No Update Available' }
                            'Err_Download' { 'Download Error' }
                            'Has_Newer' { 'Update Available' }
                            default { $TextInfo.ToTitleCase($VxrComponent.upgrade_status.ToLower()) }
                        }
                    }
                }
                $TableParams = @{
                    Name = "Installed Components - $($VxRailMgrHostName)"
                    ColumnWidths = 25, 25, 25, 25
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VxrInstalledComponents | Table @TableParams
            }
        }
    }

    end {
    }

}