function Get-AbrVxRailClusterHost {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster host information from the VxRail Manager API
    .DESCRIPTION
    .EXAMPLE

    .NOTES
        Version:        0.2.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .LINK

    #>

    begin {
        Write-PscriboMessage "Collecting VxRail cluster host information."
    }

    process {
        Try {
            Write-PScriboMessage "Performing API reference call to path /system/cluster-hosts."
            $VxrClusterHosts = Get-VxRailApi -Version 1 -Uri '/system/cluster-hosts'
            if ($VxrClusterHosts) {
                Section -Style NOTOCHeading4 -ExcludeFromToC "ESXi Hosts" {
                    $VxrClusterHostInfo = foreach ($VxrClusterHost in ($VxrClusterHosts | Sort-Object host_name)) {
                        [PSCustomObject]@{
                            'Hostname' = $VxrClusterHost.host_name
                            'ESXi Host Management IP' = ($VxrClusterHost.ip_set).management_ip
                            'Service Tag' = $VxrClusterHost.serial_number
                            'Appliance ID' = $VxrClusterHost.psnt
                            'Model' = $VxrClusterHost.Model
                        }
                    }
                    $TableParams = @{
                        Name = "ESXi Host Specifications - $($VxRailMgrHostName)"
                        ColumnWidths = 25, 20, 15, 20, 20
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrClusterHostInfo | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning "VxRail Cluster Host Section: $($_.Exception.Message)"
        }
    }

    end {
    }

}