function Get-AbrVxRailHostIdracIPv4 {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail iDRAC IPv4 information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailHostIdracIPv4 -VxrHost $VxrHost
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
        $LocalizedData = $reportTranslate.GetAbrVxRailHostIdracIPv4
        Write-PScriboMessage ($LocalizedData.Collecting -f $VxrHost.hostname)
    }

    process {
        Try {
            $VxrHostiDRACNetwork = Get-VxRailApi -Version 1 -Uri ('/hosts/' + $VxrHost.sn + '/idrac/network')
            if ($VxrHostiDRACNetwork) {
                Section -Style NOTOCHeading5 -ExcludeFromTOC $LocalizedData.Heading {
                    $VxrHostiDRACIpv4 = [PSCustomObject]@{
                        $LocalizedData.Dhcp = Switch ($VxrHostiDRACNetwork.dhcp_enabled) {
                            $true { $LocalizedData.Enabled }
                            $False { $LocalizedData.Disabled }
                        }
                        $LocalizedData.IPv4Address = $VxrHostiDRACNetwork.ip.ip_address
                        $LocalizedData.SubnetMask = $VxrHostiDRACNetwork.ip.netmask
                        $LocalizedData.Gateway = $VxrHostiDRACNetwork.ip.Gateway
                    }
                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxrHost.hostname)
                        List = $true
                        ColumnWidths = 40, 60
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrHostiDRACIpv4 | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
