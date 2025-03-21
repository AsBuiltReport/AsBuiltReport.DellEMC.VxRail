function Get-AbrVxRailClusterNetwork {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster network information from the VxRail Manager API
    .DESCRIPTION

    .NOTES
        Version:        0.2.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE

    .LINK

    #>

    begin {
        Write-PScriboMessage "Collecting VxRail cluster network information."
    }

    process {
        Try {
            Write-PScriboMessage "Performing API reference call to path /system/proxy."
            $VxrProxy = Get-VxRailApi -Version 1 -Uri  '/system/proxy'
            Write-PScriboMessage "Performing API reference call to path /system/internet-mode."
            $VxrInternetMode = Get-VxRailApi -Version 1 -Uri '/system/internet-mode'
            Write-PScriboMessage "Performing API reference call to path /cluster/network/pools."
            $VxrClusterNetPools = (Get-VxRailApi -Version 2 -Uri '/cluster/network/pools').data

            if ($VxrInternetMode) {
                Section -Style Heading2 'VxRail Network' {
                    Paragraph "The following section details the VxRail Manager general network settings for $($VxRailMgrHostName)."
                    BlankLine
                    #region General Network Section
                    Section -Style Heading3 'General' {
                        $Networking = [PSCustomObject]@{
                            'Internet Connection Status' = Switch ($VxrInternetMode.is_dark_site) {
                                $true { 'Disabled' }
                                $false { 'Enabled' }
                            }
                            'Proxy Status' = & {
                                if ($VxrProxy) {
                                    "Enabled"
                                } else {
                                    "Disabled"
                                }
                            }
                        }
                        $TableParams = @{
                            Name = "General Network Specifications - $($VxRailMgrHostName)"
                            List = $true
                            ColumnWidths = 40, 60
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $Networking | Table @TableParams

                        #region Proxy Server Section
                        if ($VxrProxy) {
                            Section -Style Heading3 'Proxy Server' {
                                $ProxyServer = [PSCustomObject]@{
                                    'Protocol' = $VxrProxy.Type
                                    'IP Address' = $VxrProxy.Server
                                    'Port' = $VxrProxy.Port
                                }
                                $TableParams = @{
                                    Name = "Proxy Server Specifications - $($VxRailMgrHostName)"
                                    List = $true
                                    ColumnWidths = 40, 60
                                }
                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }
                                $ProxyServer | Table @TableParams
                            }
                        }
                        #endregion Proxy Server Section
                    }
                    #endregion General Network Section

                    #region Network Pools
                    if ($VxrClusterNetPools) {
                        Section -Style Heading3 'Network Pools' {
                            #region Management Network Pool
                            Section -Style Heading4 'Management' {
                                $VxrMgmtNetPool = [PSCustomObject]@{
                                    'Network Pool' = & {
                                        $VxrMgmtNetPoolObj = foreach ($VxrMgmtNetPool in $VxrClusterNetPools.management.pools) {
                                            "$($VxrMgmtNetPool.minIp) - $($VxrMgmtNetPool.maxIp)"
                                        }
                                        $VxrMgmtNetPoolObj -join ', '
                                    }
                                    'Subnet Mask' = $VxrClusterNetPools.management.subnetmask
                                    'Gateway' = $VxrClusterNetPools.gateway
                                    'Total' = $VxrClusterNetPools.management.total
                                    'Used' = $VxrClusterNetPools.management.used
                                    'Available' = ($VxrClusterNetPools.management.total) - ($VxrClusterNetPools.management.used)
                                    'VLAN ID' = $VxrClusterNetPools.management.vlan_id
                                }
                                $TableParams = @{
                                    Name = "Management Network Pool Specifications - $($VxRailMgrHostName)"
                                    List = $true
                                    ColumnWidths = 40, 60
                                }
                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }
                                $VxrMgmtNetPool | Table @TableParams
                            }
                            #endregion Management Network Pool

                            #region vMotion Network Pool
                            Section -Style NOTOCHeading4 -ExcludeFromToC 'vMotion' {
                                $VxrVmotionNetPool = [PSCustomObject]@{
                                    'Network Pool' = & {
                                        $VxrVmotionNetPoolObj = foreach ($VxrVmotionNetPool in $VxrClusterNetPools.vmotion.pools) {
                                            "$($VxrVmotionNetPool.minIp) - $($VxrVmotionNetPool.maxIp)"
                                        }
                                        $VxrVmotionNetPoolObj -join ', '
                                    }
                                    'Subnet Mask' = $VxrClusterNetPools.vmotion.subnetmask
                                    'Gateway' = $VxrClusterNetPools.gateway
                                    'Total' = $VxrClusterNetPools.vmotion.total
                                    'Used' = $VxrClusterNetPools.vmotion.used
                                    'Available' = ($VxrClusterNetPools.vmotion.total) - ($VxrClusterNetPools.vmotion.used)
                                    'VLAN ID' = $VxrClusterNetPools.vmotion.vlan_id
                                }
                                $TableParams = @{
                                    Name = "vMotion Network Pool Specifications - $($VxRailMgrHostName)"
                                    List = $true
                                    ColumnWidths = 40, 60
                                }
                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }
                                $VxrVmotionNetPool | Table @TableParams
                            }
                            #endregion vMotion Network Pool

                            #region vSAN Network Pool
                            Section -Style NOTOCHeading4 -ExcludeFromToC 'vSAN' {
                                $VxrVsanNetPool = [PSCustomObject]@{
                                    'Network Pool' = & {
                                        $VxrVsanNetPoolObj = foreach ($VxrVsanNetPool in $VxrClusterNetPools.vsan.pools) {
                                            "$($VxrVsanNetPool.minIp) - $($VxrVsanNetPool.maxIp)"
                                        }
                                        $VxrVsanNetPoolObj -join ', '
                                    }
                                    'Subnet Mask' = $VxrClusterNetPools.vsan.subnetmask
                                    'Gateway' = $VxrClusterNetPools.gateway
                                    'Total' = $VxrClusterNetPools.vsan.total
                                    'Used' = $VxrClusterNetPools.vsan.used
                                    'Available' = ($VxrClusterNetPools.vsan.total) - ($VxrClusterNetPools.vsan.used)
                                    'VLAN ID' = $VxrClusterNetPools.vsan.vlan_id
                                }
                                $TableParams = @{
                                    Name = "vSAN Network Pool Specifications - $($VxRailMgrHostName)"
                                    List = $true
                                    ColumnWidths = 40, 60
                                }
                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }
                                $VxrVsanNetPool | Table @TableParams
                            }
                            #endregion vSAN Network Pool
                        }
                    }
                    #endregion Network Pools
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning "VxRail Cluster Network Section: $($_.Exception.Message)"
        }
    }

    end {
    }

}