function Get-AbrVxRailHostIdracVlan {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail iDRAC VLAN information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailHostIdracVlan -VxrHost $VxrHost
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
        $LocalizedData = $reportTranslate.GetAbrVxRailHostIdracVlan
        Write-PScriboMessage ($LocalizedData.Collecting -f $VxrHost.hostname)
    }

    process {
        Try {
            $VxrHostiDRACNetwork = Get-VxRailApi -Version 1 -Uri ('/hosts/' + $VxrHost.sn + '/idrac/network')
            if ($VxrHostiDRACNetwork) {
                Section -Style NOTOCHeading5 -ExcludeFromTOC $LocalizedData.Heading {
                    $VxrHostiDRACVlan = [PSCustomObject]@{
                        $LocalizedData.Vlan = Switch ($VxrHostiDRACNetwork.vlan.vlan_id -eq '0') {
                            $true { $LocalizedData.Disabled }
                            $false { $LocalizedData.Enabled }
                        }
                        $LocalizedData.VlanId = $VxrHostiDRACNetwork.vlan.vlan_id
                        $LocalizedData.VlanPriority = $VxrHostiDRACNetwork.vlan.vlan_priority
                    }
                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxrHost.hostname)
                        List = $true
                        ColumnWidths = 40, 60
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrHostiDRACVlan | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
