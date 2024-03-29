function Invoke-AsBuiltReport.DellEMC.VxRail {
    <#
    .SYNOPSIS
        PowerShell script to document the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats
    .DESCRIPTION
        Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.4.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
        Credits:        Iain Brighton (@iainbrighton) - PScribo module

    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>

    param (
        [String[]] $Target,
        [PSCredential] $Credential
    )

    # Check if the required version of VMware PowerCLI is installed
    Get-AbrVxRailRequiredModule -Name 'VMware.PowerCLI' -Version '12.3'

    # Import Report Configuration
    $Report = $ReportConfig.Report
    $InfoLevel = $ReportConfig.InfoLevel
    $Options = $ReportConfig.Options

    # General information
    $TextInfo = (Get-Culture).TextInfo

    #region foreach loop
    foreach ($VIServer in $Target) {

        # Get VxRail Manager information
        #Get-AbrVxRailManager
        try {
            Write-PScriboMessage "Connecting to vCenter Server '$($VIServer)'."
            $global:vCenter = Connect-VIServer $VIServer -Credential $Credential -ErrorAction Stop
        } catch {
            throw
        }
        if ($vCenter) {
            Write-PScriboMessage "Collecting VxRail Manager Information."
            $global:vCenterServer = (Get-AdvancedSetting -Entity $vCenter | Where-Object { $_.name -eq 'VirtualCenter.FQDN' }).Value

            $VxRailClusters = Get-Cluster -Server $vCenter | Where-Object {$_.CustomFields['VxRail-IP']}
            foreach ($VxRailCluster in $VxRailClusters) {
                $VxRailIP = $VxRailCluster.CustomFields['VxRail-IP']
                # Resolve DNS name for VxRail Manager
                $global:VxRailMgrHostName = (Resolve-DnsName -Name $VxRailIP -ErrorAction SilentlyContinue).NameHost
                # If DNS name is not resolved, use VxRail Manager IP address
                if (-not $VxRailMgrHostName) {
                    $global:VxRailMgrHostName = $VxRailIP
                }
                Write-PScriboMessage "Connecting to VxRail Manager $($VxRailMgrHostName)."

                # API Calls
                Write-PScriboMessage "Performing API reference call to path /hosts."
                $VxrHosts = Get-VxRailApi -Version 1 -Uri '/hosts'
                Write-PScriboMessage "Performing API reference call to path /chassis."
                $VxrChassis = Get-VxRailApi -Version 1 -Uri '/chassis'
                Write-PScriboMessage "Performing API reference call to path /system/cluster-hosts."
                $VxrClusterHosts = Get-VxRailApi -Version 1 -Uri '/system/cluster-hosts'

                #region VxRail Section
                Section -Style Heading1 "VxRail Manager - $($VxRailMgrHostName)" {
                    Paragraph "The following sections detail the VxRail cluster configuration managed by VxRail Manager $($VxRailMgrHostName)."
                    BlankLine
                    #region Cluster Section
                    Write-PScriboMessage "Cluster InfoLevel set at $($InfoLevel.Cluster)."
                    if ($InfoLevel.Cluster -gt 0) {
                        Section -Style Heading2 'VxRail Cluster' {
                            Paragraph "The following section provides a configuration summary of the VxRail cluster, ESXi hosts and virtual machines."
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
                    Write-PScriboMessage "Appliance InfoLevel set at $($InfoLevel.Appliance)."
                    if ($InfoLevel.Appliance -gt 0) {
                        Section -Style Heading2 'VxRail Appliances' {
                            Paragraph "The following sections detail the configuration of VxRail Appliances managed by VxRail Manager $($VxRailMgrHostName)."
                            foreach ($VxrHost in ($VxrHosts | Sort-Object hostname)) {
                                $VxrClusterHost = $VxrClusterHosts | Where-Object { $_.host_name -eq $VxrHost.hostname }
                                $VxrHostChassis = $VxrChassis | Where-Object { $_.sn -eq $VxrHost.sn }
                                $VMHost = Get-VMHost -Name $VxrHost.hostname -Server $vCenter
                                $esxcli = Get-EsxCLI -VMHost $VMHost -V2 -Server $vCenter
                                Section -Style Heading3 "$($VxrHost.hostname)" {
                                    Paragraph "The following section details the hardware configuration for VxRail Appliance $($VxrHost.hostname)."
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
                                        Section -Style Heading4 'iDRAC' {
                                            # iDRAC Network
                                            Get-AbrVxRailHostIdracIpv4 -VxrHost $VxrHost

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
                    Write-PScriboMessage "Support InfoLevel set at $($InfoLevel.Support)."
                    if ($InfoLevel.Support -gt 0) {
                        Get-AbrVxRailClusterSupport
                    }

                    # Networking Section
                    Write-PScriboMessage "Network InfoLevel set at $($InfoLevel.Network)."
                    if ($InfoLevel.Network -gt 0) {
                        Get-AbrVxRailClusterNetwork
                    }
                }
                #endregion VxRail Section
            }
            $null = Disconnect-VIServer -Server $VIServer -Confirm:$false -ErrorAction SilentlyContinue
        }
    }
    #endregion foreach loop
}