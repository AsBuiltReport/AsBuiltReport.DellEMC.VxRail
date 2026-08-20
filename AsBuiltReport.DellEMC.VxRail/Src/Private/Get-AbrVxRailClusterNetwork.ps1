function Get-AbrVxRailClusterNetwork {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster network information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailClusterNetwork
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailClusterNetwork
        Write-PScriboMessage $LocalizedData.Collecting
    }

    process {
        Try {
            Write-PScriboMessage $LocalizedData.ApiCallProxy
            $VxrProxy = Get-VxRailApi -Version 1 -Uri  '/system/proxy'
            Write-PScriboMessage $LocalizedData.ApiCallInternetMode
            $VxrInternetMode = Get-VxRailApi -Version 1 -Uri '/system/internet-mode'
            Write-PScriboMessage $LocalizedData.ApiCallNetworkPools
            $VxrClusterNetPools = (Get-VxRailApi -Version 2 -Uri '/cluster/network/pools').data

            if ($VxrInternetMode) {
                Section -Style Heading2 $LocalizedData.Heading {
                    Paragraph ($LocalizedData.Paragraph -f $VxRailMgrHostName)
                    BlankLine
                    #region General Network Section
                    Section -Style Heading3 $LocalizedData.GeneralHeading {
                        $Networking = [PSCustomObject]@{
                            $LocalizedData.InternetConnectionStatus = Switch ($VxrInternetMode.is_dark_site) {
                                $true { $LocalizedData.Disabled }
                                $false { $LocalizedData.Enabled }
                            }
                            $LocalizedData.ProxyStatus = & {
                                if ($VxrProxy) {
                                    $LocalizedData.Enabled
                                } else {
                                    $LocalizedData.Disabled
                                }
                            }
                        }
                        $TableParams = @{
                            Name = ($LocalizedData.GeneralTableName -f $VxRailMgrHostName)
                            List = $true
                            ColumnWidths = 40, 60
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $Networking | Table @TableParams

                        #region Proxy Server Section
                        if ($VxrProxy) {
                            Section -Style Heading3 $LocalizedData.ProxyServerHeading {
                                $ProxyServer = [PSCustomObject]@{
                                    $LocalizedData.Protocol = $VxrProxy.Type
                                    $LocalizedData.IPAddress = $VxrProxy.Server
                                    $LocalizedData.Port = $VxrProxy.Port
                                }
                                $TableParams = @{
                                    Name = ($LocalizedData.ProxyServerTableName -f $VxRailMgrHostName)
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
                        Section -Style Heading3 $LocalizedData.NetworkPoolsHeading {
                            #region Management Network Pool
                            Section -Style Heading4 $LocalizedData.ManagementHeading {
                                $VxrMgmtNetPool = [PSCustomObject]@{
                                    $LocalizedData.NetworkPool = & {
                                        $VxrMgmtNetPoolObj = foreach ($VxrMgmtNetPool in $VxrClusterNetPools.management.pools) {
                                            "$($VxrMgmtNetPool.minIp) - $($VxrMgmtNetPool.maxIp)"
                                        }
                                        $VxrMgmtNetPoolObj -join ', '
                                    }
                                    $LocalizedData.SubnetMask = $VxrClusterNetPools.management.subnetmask
                                    $LocalizedData.Gateway = $VxrClusterNetPools.gateway
                                    $LocalizedData.Total = $VxrClusterNetPools.management.total
                                    $LocalizedData.Used = $VxrClusterNetPools.management.used
                                    $LocalizedData.Available = ($VxrClusterNetPools.management.total) - ($VxrClusterNetPools.management.used)
                                    $LocalizedData.VlanId = $VxrClusterNetPools.management.vlan_id
                                }
                                $TableParams = @{
                                    Name = ($LocalizedData.ManagementTableName -f $VxRailMgrHostName)
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
                            Section -Style NOTOCHeading4 -ExcludeFromToC $LocalizedData.VmotionHeading {
                                $VxrVmotionNetPool = [PSCustomObject]@{
                                    $LocalizedData.NetworkPool = & {
                                        $VxrVmotionNetPoolObj = foreach ($VxrVmotionNetPool in $VxrClusterNetPools.vmotion.pools) {
                                            "$($VxrVmotionNetPool.minIp) - $($VxrVmotionNetPool.maxIp)"
                                        }
                                        $VxrVmotionNetPoolObj -join ', '
                                    }
                                    $LocalizedData.SubnetMask = $VxrClusterNetPools.vmotion.subnetmask
                                    $LocalizedData.Gateway = $VxrClusterNetPools.gateway
                                    $LocalizedData.Total = $VxrClusterNetPools.vmotion.total
                                    $LocalizedData.Used = $VxrClusterNetPools.vmotion.used
                                    $LocalizedData.Available = ($VxrClusterNetPools.vmotion.total) - ($VxrClusterNetPools.vmotion.used)
                                    $LocalizedData.VlanId = $VxrClusterNetPools.vmotion.vlan_id
                                }
                                $TableParams = @{
                                    Name = ($LocalizedData.VmotionTableName -f $VxRailMgrHostName)
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
                            Section -Style NOTOCHeading4 -ExcludeFromToC $LocalizedData.VsanHeading {
                                $VxrVsanNetPool = [PSCustomObject]@{
                                    $LocalizedData.NetworkPool = & {
                                        $VxrVsanNetPoolObj = foreach ($VxrVsanNetPool in $VxrClusterNetPools.vsan.pools) {
                                            "$($VxrVsanNetPool.minIp) - $($VxrVsanNetPool.maxIp)"
                                        }
                                        $VxrVsanNetPoolObj -join ', '
                                    }
                                    $LocalizedData.SubnetMask = $VxrClusterNetPools.vsan.subnetmask
                                    $LocalizedData.Gateway = $VxrClusterNetPools.gateway
                                    $LocalizedData.Total = $VxrClusterNetPools.vsan.total
                                    $LocalizedData.Used = $VxrClusterNetPools.vsan.used
                                    $LocalizedData.Available = ($VxrClusterNetPools.vsan.total) - ($VxrClusterNetPools.vsan.used)
                                    $LocalizedData.VlanId = $VxrClusterNetPools.vsan.vlan_id
                                }
                                $TableParams = @{
                                    Name = ($LocalizedData.VsanTableName -f $VxRailMgrHostName)
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
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
