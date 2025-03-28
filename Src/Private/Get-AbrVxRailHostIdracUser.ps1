function Get-AbrVxRailHostIdracUser {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail iDRAC user information from the VxRail Manager API
    .DESCRIPTION

    .NOTES
        Version:        0.2.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE

    .LINK

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHost
    )

    begin {
        Write-PscriboMessage "Collecting $($VxrHost.hostname) iDRAC user information."
    }

    process {
        Try {
            $VxrHostiDRACUsers = Get-VxRailApi -Version 1 -Uri ('/hosts/' + $VxrHost.Sn + '/idrac/users')
            if ($VxrHostiDRACUsers) {
                Section -Style NOTOCHeading5 -ExcludeFromTOC 'Users' {
                    $VxrHostiDRACUserInfo = foreach ($VxrHostiDRACUser in $VxrHostiDRACUsers) {
                        [PSCustomObject]@{
                            'ID' = $VxrHostiDRACUser.id
                            'User Name' = $VxrHostiDRACUser.name
                            'Privilege' = Switch ($VxrHostiDRACUser.privilege) {
                                'ADMIN' { 'Administrator' }
                                default { $VxrHostiDRACUser.privilege }
                            }
                        }
                    }
                    $TableParams = @{
                        Name = "iDRAC User Specifications - $($VxrHost.hostname)"
                        ColumnWidths = 33, 34, 33
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrHostiDRACUserInfo | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning "VxRail Host iDRAC User Section: $($_.Exception.Message)"
        }
    }

    end {
    }

}