function Get-AbrVxRailClusterHost {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster host information from the VxRail Manager API
    .DESCRIPTION
    .EXAMPLE

    .NOTES
        Version:        0.1.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .LINK

    #>

    $VxrClusterHosts = Get-VxRailApi -Version 1 -Uri '/system/cluster-hosts'
    if ($VxrClusterHosts) {
        Section -Style Heading4 "ESXi Hosts" {
            $VxrClusterHostInfo = foreach ($VxrClusterHost in ($VxrClusterHosts | Sort-Object host_name)) {
                [PSCustomObject]@{
                    'Service Tag' = $VxrClusterHost.serial_number
                    'Appliance ID' = $VxrClusterHost.psnt
                    'Model' = $VxrClusterHost.Model
                    'ESXi Host Management IP' = ($VxrClusterHost.ip_set).management_ip
                    'Hostname' = $VxrClusterHost.host_name
                }
            }
            $TableParams = @{
                Name = "ESXi Host Specifications - $($VxRailMgrHostName)"
                ColumnWidths = 15, 20, 20, 20, 25
            }
            if ($Report.ShowTableCaptions) {
                $TableParams['Caption'] = "- $($TableParams.Name)"
            }
            $VxrClusterHostInfo | Table @TableParams
        }
    }

}