function Get-AbrVxRailAvailableHost {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail available host information from the VxRail Manager API
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
        Write-PscriboMessage "Collecting VxRail available host information."
    }

    process {
        Write-PScriboMessage "Performing API reference call to path /system/available-hosts."
        $VxrAvailableHosts = Get-VxRailApi -Version 1 -Uri '/system/available-hosts'
        if ($VxrAvailableHosts) {
            Section -Style Heading3 'Available ESXi Hosts' {
                $VxrAvailableHostInfo = foreach ($VxrAvailableHost in ($VxrAvailableHosts | Sort-Object serial_number)) {
                    [PSCustomObject]@{
                        'Service Tag' = $VxrAvailableHost.serial_number
                        'Appliance ID' = $VxrAvailableHost.appliance_id
                        'Model' = $VxrAvailableHost.model
                        'Discovered Date' = (ConvertFrom-epoch $VxrAvailableHost.discovered_date).ToLocalTime()
                    }
                }
                $TableParams = @{
                    Name = "Available ESXi Host Specifications - $($VxRailMgrHostName)"
                    ColumnWidths = 25, 25, 25, 25
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VxrAvailableHostInfo | Table @TableParams
            }
        }
    }

    end {
    }

}