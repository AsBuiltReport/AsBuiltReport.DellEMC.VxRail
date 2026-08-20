function Invoke-AsBuiltReport.DellEMC.VxRail {
    <#
    .SYNOPSIS
        PowerShell script to document the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats
    .DESCRIPTION
        Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .PARAMETER Target
        The vCenter Server IP/FQDN which manages the VxRail cluster(s) to report on.
    .PARAMETER Credential
        Specifies the credential to connect to the target vCenter Server.
    .NOTES
        Version:        0.5.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
        Credits:        Iain Brighton (@iainbrighton) - PScribo module

    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    .EXAMPLE
        PS C:\> New-AsBuiltReport -Report DellEMC.VxRail -Target 'vcenter-01.corp.local' -Credential (Get-Credential) -Format Html,Word
    #>

    param (
        [String[]] $Target,
        [PSCredential] $Credential
    )

    $LocalizedData = $reportTranslate.InvokeAsBuiltReportDellEMCVxRail

    # Check if the required version of VCF PowerCLI is installed
    Get-RequiredModule -Name 'VCF.PowerCLI' -Version '9.1'

    # Display report module information using Core function
    Write-ReportModuleInfo -ModuleName 'DellEMC.VxRail'

    # Import Report Configuration
    $Report = $ReportConfig.Report
    $Filter = $ReportConfig.Filter
    $InfoLevel = $ReportConfig.InfoLevel
    $Options = $ReportConfig.Options

    # General information
    $TextInfo = (Get-Culture).TextInfo

    #region foreach loop
    foreach ($VIServer in $Target) {
        try {
            Write-PScriboMessage ($LocalizedData.Connecting -f $VIServer)
            $global:vCenter = Connect-VIServer $VIServer -Credential $Credential -ErrorAction Stop
        } catch {
            throw
        }
        if ($vCenter) {
            # Get VxRail Manager information
            Write-PScriboMessage $LocalizedData.CollectingVxRailInfo
            $global:vCenterServer = (Get-AdvancedSetting -Entity $vCenter | Where-Object { $_.name -eq 'VirtualCenter.FQDN' }).Value

            # Get VxRail Clusters
            if ($Filter.VxRailCluster -ne "*") {
                $VxRailClusters = foreach ($VxRailCluster in $Filter.VxRailCluster) {
                    Try {
                        Get-Cluster -Name $VxRailCluster -Server $vCenter | Where-Object {$_.CustomFields['VxRail-IP']}
                    } Catch {
                        Write-PScriboMessage -IsWarning ($LocalizedData.ClusterNotFound -f $VxRailCluster)
                    }
                }
            } else {
                $VxRailClusters = Get-Cluster -Server $vCenter | Where-Object {$_.CustomFields['VxRail-IP']}
            }

            foreach ($VxRailCluster in $VxRailClusters) {
                $VxRailIP = $VxRailCluster.CustomFields['VxRail-IP']
                # Resolve DNS name for VxRail Manager
                $global:VxRailMgrHostName = (Resolve-DnsName -Name $VxRailIP -ErrorAction SilentlyContinue).NameHost
                # If DNS name is not resolved, use VxRail Manager IP address
                if (-not $VxRailMgrHostName) {
                    $global:VxRailMgrHostName = $VxRailIP
                }
                Write-PScriboMessage ($LocalizedData.ConnectingVxRailMgr -f $VxRailMgrHostName)

                # API Calls
                Write-PScriboMessage $LocalizedData.ApiCallHosts
                $VxrHosts = Get-VxRailApi -Version 1 -Uri '/hosts'
                Write-PScriboMessage $LocalizedData.ApiCallChassis
                $VxrChassis = Get-VxRailApi -Version 1 -Uri '/chassis'
                Write-PScriboMessage $LocalizedData.ApiCallClusterHosts
                $VxrClusterHosts = Get-VxRailApi -Version 1 -Uri '/system/cluster-hosts'

                #region VxRail Section
                Section -Style Heading1 $($VxRailMgrHostName) {
                    Paragraph ($LocalizedData.SectionParagraph -f $VxRailMgrHostName)
                    BlankLine
                    #region Cluster Section
                    Write-PScriboMessage ($LocalizedData.ClusterInfoLevel -f $InfoLevel.Cluster)
                    if ($InfoLevel.Cluster -gt 0) {
                        Section -Style Heading2 $LocalizedData.ClusterHeading {
                            Paragraph $LocalizedData.ClusterParagraph
                            BlankLine
                            # VxRail Cluster
                            Get-AbrVxRailCluster

                            # Cluster Hosts
                            Get-AbrVxRailClusterHost

                            # Available ESXi Hosts
                            Get-AbrVxRailAvailableHost

                            if ($InfoLevel.Cluster -ge 2) {
                                # VxRail VMs
                                Get-AbrVxRailClusterVMs

                                # Cluster Components
                                Get-AbrVxRailClusterComponents
                            }
                        }
                    }
                    #endregion Cluster Section

                    #region Appliance Section
                    Write-PScriboMessage ($LocalizedData.ApplianceInfoLevel -f $InfoLevel.Appliance)
                    if ($InfoLevel.Appliance -gt 0) {
                        Section -Style Heading2 $LocalizedData.ApplianceHeading {
                            Paragraph ($LocalizedData.ApplianceParagraph -f $VxRailMgrHostName)
                            foreach ($VxrHost in ($VxrHosts | Sort-Object hostname)) {
                                $VxrClusterHost = $VxrClusterHosts | Where-Object { $_.host_name -eq $VxrHost.hostname }
                                $VxrHostChassis = $VxrChassis | Where-Object { $_.sn -eq $VxrHost.sn }
                                $VMHost = Get-VMHost -Name $VxrHost.hostname -Server $vCenter
                                $esxcli = Get-EsxCLI -VMHost $VMHost -V2 -Server $vCenter
                                Section -Style Heading3 "$($VxrHost.hostname)" {
                                    Paragraph ($LocalizedData.ApplianceHostParagraph -f $VxrHost.hostname)
                                    # Hardware
                                    Get-AbrVxRailHostHardware -VxrHost $VxrHost

                                    # ESXi
                                    Get-AbrVxRailHostEsxi -VxrClusterHost $VxrClusterHost

                                    # Firmware
                                    Get-AbrVxRailHostFirmware -VxrHost $VxrHost

                                    # Components
                                    Get-AbrVxRailHostComponent -VxrHost $VxrHost

                                    # Boot Devices
                                    Get-AbrVxRailHostBootDevice -VxrHost $VxrHost

                                    # Disks
                                    Get-AbrVxRailHostDisk -VxrHost $VxrHost

                                    # NICs
                                    Get-AbrVxRailHostNic -VxrHost $VxrHost

                                    # Power Supplies
                                    Get-AbrVxRailHostPsu -VxrHostChassis $VxrHostChassis

                                    #region iDRAC
                                    if ($VMHost.ConnectionState -eq 'Connected') {
                                        Section -Style NOTOCHeading4 -ExcludeFromTOC $LocalizedData.IdracHeading {
                                            # iDRAC Network
                                            Get-AbrVxRailHostIdracIPv4 -VxrHost $VxrHost

                                            # iDRAC VLAN
                                            Get-AbrVxRailHostIdracVlan -VxrHost $VxrHost

                                            # iDRAC Users
                                            Get-AbrVxRailHostIdracUser -VxrHost $VxrHost
                                        }
                                    }
                                    #endregion iDRAC
                                }
                            }
                        }
                    }
                    #endregion Appliance Section

                    # Cluster Support
                    Write-PScriboMessage ($LocalizedData.SupportInfoLevel -f $InfoLevel.Support)
                    if ($InfoLevel.Support -gt 0) {
                        Get-AbrVxRailClusterSupport
                    }

                    # Trust Store Certificates
                    Write-PScriboMessage ($LocalizedData.CertificateInfoLevel -f $InfoLevel.Certificate)
                    if ($InfoLevel.Certificate -gt 0) {
                        Get-AbrVxRailClusterCertificate
                    }

                    # Precheck Results
                    Write-PScriboMessage ($LocalizedData.PrecheckInfoLevel -f $InfoLevel.Precheck)
                    if ($InfoLevel.Precheck -gt 0) {
                        Get-AbrVxRailClusterPrecheck
                    }

                    # Networking Section
                    Write-PScriboMessage ($LocalizedData.NetworkInfoLevel -f $InfoLevel.Network)
                    if ($InfoLevel.Network -gt 0) {
                        Get-AbrVxRailClusterNetwork
                    }
                }
                #endregion VxRail Section
            }
            $null = Disconnect-VIServer -Server $VIServer -Confirm:$false -ErrorAction SilentlyContinue
        } else {
            Write-PScriboMessage -IsWarning ($LocalizedData.ConnectionError -f $VIServer)
        }
    }
    #endregion foreach loop
}
