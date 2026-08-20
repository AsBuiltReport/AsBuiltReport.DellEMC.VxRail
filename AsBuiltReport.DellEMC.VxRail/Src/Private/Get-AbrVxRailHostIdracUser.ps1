function Get-AbrVxRailHostIdracUser {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail iDRAC user information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailHostIdracUser -VxrHost $VxrHost
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHost
    )

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailHostIdracUser
        Write-PScriboMessage ($LocalizedData.Collecting -f $VxrHost.hostname)
    }

    process {
        Try {
            $VxrHostiDRACUsers = Get-VxRailApi -Version 1 -Uri ('/hosts/' + $VxrHost.Sn + '/idrac/users')
            if ($VxrHostiDRACUsers) {
                Section -Style NOTOCHeading5 -ExcludeFromTOC $LocalizedData.Heading {
                    $VxrHostiDRACUserInfo = foreach ($VxrHostiDRACUser in $VxrHostiDRACUsers) {
                        [PSCustomObject]@{
                            $LocalizedData.ID = $VxrHostiDRACUser.id
                            $LocalizedData.UserName = $VxrHostiDRACUser.name
                            $LocalizedData.Privilege = Switch ($VxrHostiDRACUser.privilege) {
                                'ADMIN' { $LocalizedData.Administrator }
                                default { $VxrHostiDRACUser.privilege }
                            }
                        }
                    }
                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxrHost.hostname)
                        ColumnWidths = 33, 34, 33
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrHostiDRACUserInfo | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
