function Get-AbrVxRailHostIdracIPv4 {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail iDRAC IPv4 information from the VxRail Manager API
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
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHost
    )

    begin {
        Write-PscriboMessage "Collecting $($VxrHost.hostname) iDRAC information."
    }

    process {
        Try {
            $VxrHostiDRACNetwork = Get-VxRailApi -Version 1 -Uri ('/hosts/' + $VxrHost.sn + '/idrac/network')
            if ($VxrHostiDRACNetwork) {
                Section -Style NOTOCHeading5 -ExcludeFromTOC 'IPv4 Settings' {
                    $VxrHostiDRACIpv4 = [PSCustomObject]@{
                        'DHCP' = Switch ($VxrHostiDRACNetwork.dhcp_enabled) {
                            $true { 'Enabled' }
                            $False { 'Disabled' }
                        }
                        'IPv4 Address' = $VxrHostiDRACNetwork.ip.ip_address
                        'Subnet Mask' = $VxrHostiDRACNetwork.ip.netmask
                        'Gateway' = $VxrHostiDRACNetwork.ip.Gateway
                    }
                    $TableParams = @{
                        Name = "iDRAC IPv4 Specifications - $($VxrHost.hostname)"
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
            Write-PScriboMessage -IsWarning "VxRail Host iDRAC IPv4 Section: $($_.Exception.Message)"
        }
    }

    end {
    }

}