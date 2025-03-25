function Get-AbrVxRailCluster {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster information from the VxRail Manager API
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
    )

    begin {
        Write-PscriboMessage "Collecting VxRail cluster information."
    }

    process {
        Try {
            Write-PScriboMessage "Performing API reference call to path /system."
            $VxrSystem = Get-VxRailApi -Version 1 -Uri '/system'
            Write-PScriboMessage "Performing API reference call to path /vc/mode."
            $VxrVcMode = Get-VxRailApi -Version 1 -Uri '/vc/mode'
            if ($VxrSystem) {
                $VxrCluster = [PSCustomObject]@{
                    'VxRail Manager' = $VxRailMgrHostName
                    'VxRail Manager IP' = $VxRailIP
                    'VxRail Version' = $VxrSystem.Version
                    'VxRail Cluster Name' = $VxRailCluster.Name
                    'VxRail Cluster Type' = $TextInfo.ToTitleCase(($VxrSystem.cluster_type).ToLower()).replace('_', ' ')
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
                    'Installation Date' = (ConvertFrom-epoch $VxrSystem.installed_time).ToLocalTime().ToString()
                }
                if ($Healthcheck.Cluster.HealthStatus) {
                    $VxrCluster | Where-Object { $_.'Health Status' -eq 'Warning' } | Set-Style -Style Warning -Property 'Health Status'
                    $VxrCluster | Where-Object { $_.'Health Status' -eq 'Error' } | Set-Style -Style Critical -Property 'Health Status'
                    $VxrCluster | Where-Object { $_.'Health Status' -eq 'Critical' } | Set-Style -Style Critical -Property 'Health Status'
                }
                $TableParams = @{
                    Name = "VxRail Cluster Specifications - $($VxRailMgrHostName)"
                    List = $true
                    ColumnWidths = 40, 60
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VxrCluster | Table @TableParams
            }
        } Catch {
            Write-PScriboMessage -IsWarning "VxRail Cluster Section: $($_.Exception.Message)"
        }
    }

    end {}

}