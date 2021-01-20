function Get-AbrVxRailCluster {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster information from the VxRail Manager API
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
        Write-PscriboMessage "Collecting VxRail cluster information."     
    }

    process {
        $VxrSystem = Get-VxRailApi -Version 1 -Uri '/system'
        $VxrVcMode = Get-VxRailApi -Version 1 -Uri '/vc/mode'
        if ($VxrSystem) {
            $VxrCluster = [PSCustomObject]@{
                'VxRail Manager' = $VxRailMgrHostName
                'VxRail Version' = $VxrSystem.Version
                'Cluster Type' = $TextInfo.ToTitleCase(($VxrSystem.cluster_type).ToLower()).replace('_', ' ')
                'Number of Hosts' = $VxrSystem.number_of_host
                'Health Status' = $VxrSystem.health
                'vCenter Server' = $vCenterServer
                'vCenter Version' = "$($vCenter.version)-$($vCenter.build)"
                'vCenter Server Mode' = $TextInfo.ToTitleCase($VxrVcMode.vc_mode.ToLower())
                'PSC Mode' = $TextInfo.ToTitleCase($VxrVcMode.psc_mode.ToLower())
                'vCenter Server Connected' = Switch ($VxrSystem.vc_connected) {
                    $true { 'Yes' }
                    $false { 'No' }
                }
                'External vCenter Server' = Switch ($VxrSystem.is_external_vc) {
                    $true { 'Yes' }
                    $false { 'No' }
                }
                'Installation Date' = (ConvertFrom-epoch $VxrSystem.installed_time).ToLocalTime()
            }
            if ($Healthcheck.Cluster.HealthStatus) {
                $VxrCluster | Where-Object { $_.'Health Status' -eq 'Warning' } | Set-Style -Style Warning -Property 'Health Status'
                $VxrCluster | Where-Object { $_.'Health Status' -eq 'Error' } | Set-Style -Style Critical -Property 'Health Status'
            }
            $TableParams = @{
                Name = "VxRail Cluster Specifications - $($VxRailMgrHostName)"
                List = $true
                ColumnWidths = 50, 50
            }
            if ($Report.ShowTableCaptions) {
                $TableParams['Caption'] = "- $($TableParams.Name)"
            }
            $VxrCluster | Table @TableParams
        }
    }

    end {}

}