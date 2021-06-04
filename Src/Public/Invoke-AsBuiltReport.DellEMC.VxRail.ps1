function Invoke-AsBuiltReport.DellEMC.VxRail {
    <#
    .SYNOPSIS
        PowerShell script to document the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats
    .DESCRIPTION
        Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.2.1
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
    Get-AbrVxRailRequiredModule

    # Import Report Configuration
    $Report = $ReportConfig.Report
    $InfoLevel = $ReportConfig.InfoLevel
    $Options = $ReportConfig.Options

    # General information
    $TextInfo = (Get-Culture).TextInfo

    #region foreach loop
    foreach ($VIServer in $Target) {

        # Get VxRail Manager information
        Get-AbrVxRailManager

        # API Calls
        Write-PScriboMessage "Performing API reference call to path /hosts"
        $VxrHosts = Get-VxRailApi -Version 1 -Uri '/hosts'
        Write-PScriboMessage "Performing API reference call to path /chassis"
        $VxrChassis = Get-VxRailApi -Version 1 -Uri '/chassis'
        Write-PScriboMessage "Performing API reference call to path /system/cluster-hosts"
        $VxrClusterHosts = Get-VxRailApi -Version 1 -Uri '/system/cluster-hosts'

        #region VxRail Section
        Section -Style Heading1 $($VxRailMgrHostName) {
            #region Cluster Section
            Write-PScriboMessage "Cluster InfoLevel set at $($InfoLevel.Cluster)."
            if ($InfoLevel.Cluster -gt 0) {
                Section -Style Heading2 'VxRail Cluster' {
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
                    foreach ($VxrHost in ($VxrHosts | Sort-Object hostname)) {
                        $VxrClusterHost = $VxrClusterHosts | Where-Object { $_.host_name -eq $VxrHost.hostname }
                        $VxrHostChassis = $VxrChassis | Where-Object { $_.sn -eq $VxrHost.sn }
                        $VMHost = Get-VMHost -Name $VxrHost.hostname -Server $vCenter
                        $esxcli = Get-EsxCLI -VMHost $VMHost -V2 -Server $vCenter
                        Section -Style Heading3 "$($VxrHost.hostname)" {
                            # Hardware
                            Get-AbrVxRailHostHardware -VxrHost $VxrHost

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

                            # Power Supplies
                            Get-AbrVxRailHostPsu -VxrHostChassis $VxrHostChassis

                            # ESXi
                            Get-AbrVxRailHostEsxi -VxrClusterHost $VxrClusterHost
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

        $null = Disconnect-VIServer -Server $VIServer -Confirm:$false -ErrorAction SilentlyContinue
    }
    #endregion foreach loop
}