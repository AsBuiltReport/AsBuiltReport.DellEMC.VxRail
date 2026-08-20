function Get-AbrVxRailCluster {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailCluster
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>
    [CmdletBinding()]
    param (
    )

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailCluster
        Write-PScriboMessage $LocalizedData.Collecting
    }

    process {
        Try {
            Write-PScriboMessage $LocalizedData.ApiCallSystem
            $VxrSystem = Get-VxRailApi -Version 1 -Uri '/system'
            Write-PScriboMessage $LocalizedData.ApiCallVcMode
            $VxrVcMode = Get-VxRailApi -Version 1 -Uri '/vc/mode'
            if ($VxrSystem) {
                $VxrCluster = [PSCustomObject]@{
                    $LocalizedData.VxRailManager = $VxRailMgrHostName
                    $LocalizedData.VxRailManagerIP = $VxRailIP
                    $LocalizedData.VxRailVersion = $VxrSystem.Version
                    $LocalizedData.VxRailClusterName = $VxRailCluster.Name
                    $LocalizedData.VxRailClusterType = $TextInfo.ToTitleCase(($VxrSystem.cluster_type).ToLower()).replace('_', ' ')
                    $LocalizedData.NumberOfHosts = $VxrSystem.number_of_host
                    $LocalizedData.HealthStatus = $VxrSystem.health
                    $LocalizedData.VCenterServer = $vCenterServer
                    $LocalizedData.VCenterVersion = "$($vCenter.version)-$($vCenter.build)"
                    $LocalizedData.VCenterServerMode = $TextInfo.ToTitleCase($VxrVcMode.vc_mode.ToLower())
                    $LocalizedData.PscMode = $TextInfo.ToTitleCase($VxrVcMode.psc_mode.ToLower())
                    $LocalizedData.VCenterServerConnected = Switch ($VxrSystem.vc_connected) {
                        $true { $LocalizedData.Yes }
                        $false { $LocalizedData.No }
                    }
                    $LocalizedData.ExternalVCenterServer = Switch ($VxrSystem.is_external_vc) {
                        $true { $LocalizedData.Yes }
                        $false { $LocalizedData.No }
                    }
                    $LocalizedData.InstallationDate = (ConvertFrom-Epoch $VxrSystem.installed_time).ToLocalTime().ToString()
                }
                if ($Healthcheck.Cluster.HealthStatus) {
                    $VxrCluster | Where-Object { $_.($LocalizedData.HealthStatus) -eq 'Warning' } | Set-Style -Style Warning -Property $LocalizedData.HealthStatus
                    $VxrCluster | Where-Object { $_.($LocalizedData.HealthStatus) -eq 'Error' } | Set-Style -Style Critical -Property $LocalizedData.HealthStatus
                    $VxrCluster | Where-Object { $_.($LocalizedData.HealthStatus) -eq 'Critical' } | Set-Style -Style Critical -Property $LocalizedData.HealthStatus
                }
                $TableParams = @{
                    Name = ($LocalizedData.TableName -f $VxRailMgrHostName)
                    List = $true
                    ColumnWidths = 40, 60
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VxrCluster | Table @TableParams
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {}

}
