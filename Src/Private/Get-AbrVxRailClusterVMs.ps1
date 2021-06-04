function Get-AbrVxRailClusterVMs {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster VM information from the VxRail Manager API
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
        Write-PscriboMessage "Collecting VxRail cluster VM information."
    }

    process {
        Write-PScriboMessage "Performing API reference call to path /cluster/system-virtual-machines"
        $VxrClusterVMs = Get-VxRailApi -Version 1 -Uri '/cluster/system-virtual-machines'
        if ($VxrClusterVMs) {
            Section -Style Heading3 'Virtual Machines' {
                $VxrClusterVMInfo = foreach ($VxrClusterVM in $VxrClusterVMs) {
                    [PSCustomObject]@{
                        'Virtual Machine' = $VxrClusterVM.Name
                        'ESXi Host' = $VxrClusterVM.host
                        'Status' = $TextInfo.ToTitleCase(($VxrClusterVM.status).ToLower()).replace('_', ' ')
                    }
                }
                if ($Healthcheck.Cluster.VMPowerStatus) {
                    $VxrClusterVMInfo | Where-Object { $_.'Status' -ne 'Powered On' } | Set-Style -Style Warning -Property 'Status'
                }
                $TableParams = @{
                    Name = "Virtual Machines - $($VxRailMgrHostName)"
                    ColumnWidths = 33, 34, 33
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VxrClusterVMInfo | Table @TableParams
            }
        }
    }

    end {
    }

}