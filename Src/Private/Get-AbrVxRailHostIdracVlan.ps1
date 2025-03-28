function Get-AbrVxRailHostIdracVlan {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail iDRAC VLAN information from the VxRail Manager API
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
        Write-PscriboMessage "Collecting $($VxrHost.hostname) iDRAC VLAN information."
    }

    process {
        Try {
            $VxrHostiDRACNetwork = Get-VxRailApi -Version 1 -Uri ('/hosts/' + $VxrHost.sn + '/idrac/network')
            if ($VxrHostiDRACNetwork) {
                Section -Style NOTOCHeading5 -ExcludeFromTOC 'VLAN Settings' {
                    $VxrHostiDRACVlan = [PSCustomObject]@{
                        'VLAN' = Switch ($VxrHostiDRACNetwork.vlan.vlan_id -eq '0') {
                            $true { 'Disabled' }
                            $false { 'Enabled' }
                        }
                        'VLAN ID' = $VxrHostiDRACNetwork.vlan.vlan_id
                        'VLAN Priority' = $VxrHostiDRACNetwork.vlan.vlan_priority
                    }
                    $TableParams = @{
                        Name = "iDRAC VLAN Specifications - $($VxrHost.hostname)"
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
            Write-PScriboMessage -IsWarning "VxRail Host iDRAC VLAN Section: $($_.Exception.Message)"
        }
    }

    end {
    }

}