function Invoke-AsBuiltReport.DellEMC.VxRail {
    <#
    .SYNOPSIS  
        PowerShell script to document the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats
    .DESCRIPTION
        Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.1.0
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
    $RequiredVersion = '12.1'
    $RequiredModule = Get-Module -ListAvailable -Name 'VMware.PowerCLI' | Sort-Object -Property Version -Descending | Select-Object -First 1
    $ModuleVersion = "$($RequiredModule.Version.Major)" + "." + "$($RequiredModule.Version.Minor)"
    if ($null -eq $ModuleVersion) {
        Write-Warning -Message "VMware PowerCLI $RequiredVersion or higher is required to run the Dell EMC VxRail As Built Report. Run 'Install-Module -Name VMware.PowerCLI -MinimumVersion $RequiredVersion' to install the required modules."
        break
    } elseif ($ModuleVersion -lt $RequiredVersion) {
        Write-Warning -Message "VMware PowerCLI $RequiredVersion or higher is required to run the Dell EMC VxRail As Built Report. Run 'Update-Module -Name VMware.PowerCLI -MinimumVersion $RequiredVersion' to update PowerCLI."
        break
    }

    # Import Report Configuration
    $Report = $ReportConfig.Report
    $InfoLevel = $ReportConfig.InfoLevel
    $Options = $ReportConfig.Options

    # General information
    $TextInfo = (Get-Culture).TextInfo

    #region foreach loop
    foreach ($VIServer in $Target) {

        try {
            Write-PScriboMessage "Connecting to vCenter Server '$VIServer'."
            $vCenter = Connect-VIServer $VIServer -Credential $Credential -ErrorAction Stop
        } catch {
            Write-Error $_
        }

        if ($vCenter) {
            $vCenterServer = (Get-AdvancedSetting -Entity $vCenter | Where-Object { $_.name -eq 'VirtualCenter.FQDN' }).Value

            #region VxRail Manager Server Name
            Write-PScriboMessage "Collecting VxRail Manager Information"
            $si = Get-View ServiceInstance -Server $vCenter
            $extMgr = Get-View -Id $si.Content.ExtensionManager -Server $vCenter
            $VxRailMgr = $extMgr.ExtensionList | Where-Object { $_.Key -eq 'com.vmware.vxrail' } | 
            Select-Object @{
                N = 'Name';
                E = { ($_.Server | Where-Object { $_.Type -eq 'HTTPS' } | Select-Object -ExpandProperty Url).Split('/')[2].Split(':')[0] }
            }
            $VxRailMgrHostName = (Resolve-DnsName -Name $VxRailMgr.Name).NameHost
            if (!$VxRailMgrHostName) {
                $VxRailMgrHostName = $VxRailMgr.Name
            }
            #endregion VxRail Manager Server Name

            #region System Connection & API Calls
            Write-PScriboMessage "Performing API reference calls"
            $VxmSystem = Get-VxRailApi -Version 1 -Uri '/system'
            $VxmProxy = Get-VxRailApi -Version 1 -Uri  '/system/proxy'
            $VxmCallHomeMode = Get-VxRailApi -Version 1 -Uri  '/callhome/mode'
            $VxmCallHomeInfo = Get-VxRailApi -Version 1 -Uri '/callhome/info'
            $VxmInternetMode = Get-VxRailApi -Version 1 -Uri '/system/internet-mode'
            $VxmSupportAccount = Get-VxRailApi -Version 1 -Uri '/support/account'
            $VxmAvailableHosts = Get-VxRailApi -Version 1 -Uri '/system/available-hosts'
            $VxmClusterHosts = Get-VxRailApi -Version 1 -Uri '/system/cluster-hosts'
            $VxmClusterNetPools = (Get-VxRailApi -Version 2 -Uri '/cluster/network/pools').data
            $VxmClusterVMs = Get-VxRailApi -Version 1 -Uri '/cluster/system-virtual-machines'
            $VxmHosts = Get-VxRailApi -Version 1 -Uri '/hosts'
            $VxmChassis = Get-VxRailApi -Version 1 -Uri '/chassis'
            $VxmVcMode = Get-VxRailApi -Version 1 -Uri '/vc/mode'
            #endregion System Connection & API Calls

            #region VxRail Section
            Section -Style Heading1 $($VxRailMgrHostName) {
                #region Cluster Section
                Write-PScriboMessage "Cluster InfoLevel set at $($InfoLevel.Cluster)."
                if (($VxmSystem) -and ($InfoLevel.Cluster -gt 0)) {
                    Section -Style Heading2 'VxRail Cluster' {
                        $VxmCluster = [PSCustomObject]@{
                            'VxRail Manager' = $VxRailMgrHostName
                            'VxRail Version' = $VxmSystem.Version
                            'Cluster Type' = $TextInfo.ToTitleCase(($VxmSystem.cluster_type).ToLower()).replace('_', ' ')
                            'Number of Hosts' = $VxmSystem.number_of_host
                            'Health State' = $VxmSystem.health
                            'vCenter Server' = $vCenterServer
                            'vCenter Server Mode' = $TextInfo.ToTitleCase($VxmVcMode.vc_mode.ToLower())
                            'PSC Mode' = $TextInfo.ToTitleCase($VxmVcMode.psc_mode.ToLower())
                            'vCenter Server Connected' = Switch ($VxmSystem.vc_connected) {
                                $true { 'Yes' }
                                $false { 'No' }
                            }
                            'External vCenter Server' = Switch ($VxmSystem.is_external_vc) {
                                $true { 'Yes' }
                                $false { 'No' }
                            }
                            'Installation Date' = (ConvertFrom-epoch $VxmSystem.installed_time).ToLocalTime()
                        }
                        if ($Healthcheck.Cluster.Health) {
                            $VxmCluster | Where-Object { $_.'Health State' -eq 'Warning' } | Set-Style -Style Warning -Property 'Health State'
                            $VxmCluster | Where-Object { $_.'Health State' -eq 'Error' } | Set-Style -Style Critical -Property 'Health State'
                        }
                        $TableParams = @{
                            Name = "VxRail Cluster Specifications - $($VxRailMgrHostName)"
                            List = $true
                            ColumnWidths = 50, 50
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $VxmCluster | Table @TableParams

                        #region ESXi Hosts
                        if ($VxmClusterHosts) {
                            Section -Style Heading3 'ESXi Hosts' {
                                $VxmClusterHostInfo = foreach ($VxmClusterHost in ($VxmClusterHosts | Sort-Object host_name)) {
                                    [PSCustomObject]@{
                                        'Service Tag' = $VxmClusterHost.serial_number
                                        'Appliance ID' = $VxmClusterHost.psnt
                                        'Model' = $VxmClusterHost.Model
                                        'ESXi Host Management IP' = ($VxmClusterHost.ip_set).management_ip
                                        'Hostname' = $VxmClusterHost.host_name                            
                                    }
                                }
                                $TableParams = @{
                                    Name = "ESXi Host Specifications - $($VxRailMgrHostName)"
                                    ColumnWidths = 15, 20, 20, 20, 25
                                }
                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }
                                $VxmClusterHostInfo | Table @TableParams
                            }
                        }
                        #endregion ESXi Hosts

                        #region Available ESXi Hosts
                        if ($VxmAvailableHosts) {
                            Section -Style Heading3 'Available ESXi Hosts' {
                                $VxmAvailableHostInfo = foreach ($VxmAvailableHost in ($VxmAvailableHosts | Sort-Object serial_number)) {
                                    [PSCustomObject]@{
                                        'Service Tag' = $VxmAvailableHost.serial_number
                                        'Appliance ID' = $VxmAvailableHost.appliance_id
                                        'Model' = $VxmAvailableHost.model
                                        'Discovered Date' = (ConvertFrom-epoch $VxmAvailableHost.discovered_date).ToLocalTime()                            
                                    }
                                }
                                $TableParams = @{
                                    Name = "Available ESXi Host Specifications - $($VxRailMgrHostName)"
                                    ColumnWidths = 25, 25, 25, 25
                                }
                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }
                                $VxmAvailableHostInfo | Table @TableParams
                            }
                        }
                        #endregion Available ESXi Hosts

                        if ($InfoLevel.Cluster -ge 2) {
                            #region VxRail VMs
                            Section -Style Heading3 'Virtual Machines' {
                                $VxmClusterVMInfo = foreach ($VxmClusterVM in $VxmClusterVMs) {
                                    [PSCustomObject]@{
                                        'Virtual Machine' = $VxmClusterVM.Name
                                        'ESXi Host' = $VxmClusterVM.host
                                        'Status' = $TextInfo.ToTitleCase(($VxmClusterVM.status).ToLower()).replace('_', ' ')
                                    }
                                }
                                if ($Healthcheck.Cluster.VMPowerState) {
                                    $VxmClusterVMInfo | Where-Object { $_.'Status' -ne 'Powered On' } | Set-Style -Style Warning -Property 'Status'
                                }
                                $TableParams = @{
                                    Name = "Virtual Machines - $($VxRailMgrHostName)"
                                    ColumnWidths = 33, 34, 33
                                }
                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }
                                $VxmClusterVMInfo | Table @TableParams
                            }
                            #endregion VxRail VMs

                            #region Installed Components Section
                            Section -Style Heading3 'Installed Components' {
                                $VxmComponents = $VxmSystem.installed_components | Sort-Object Name
                                $VxmInstalledComponents = foreach ($VxmComponent in $VxmComponents) {
                                    [PSCustomObject]@{
                                        'Name' = $VxmComponent.Name
                                        'Description' = $VxmComponent.description
                                        'Version' = $VxmComponent.current_version
                                        'Upgrade Status' = Switch ($VxmComponent.upgrade_status) {
                                            'Has_Newer' { 'Upgrade Available' }
                                            default { $TextInfo.ToTitleCase($VxmComponent.upgrade_status.ToLower()) }
                                        }
                                    }
                                }
                                $TableParams = @{
                                    Name = "Installed Components - $($VxRailMgrHostName)"
                                    ColumnWidths = 25, 25, 25, 25
                                }
                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }
                                $VxmInstalledComponents | Table @TableParams
                            }
                            #endregion Installed Components Section
                        }
                    }
                }
                #endregion Cluster Section

                #region Appliance Section
                Write-PScriboMessage "Appliance InfoLevel set at $($InfoLevel.Appliance)."
                if (($VxmHosts) -and ($InfoLevel.Appliance -gt 0)) {
                    Section -Style Heading2 'VxRail Appliances' {
                        foreach ($VxmHost in ($VxmHosts | Sort-Object hostname)) {
                            $VxmClusterHost = $VxmClusterHosts | Where-Object { $_.host_name -eq $VxmHost.hostname }
                            $VxmHostChassis = $VxmChassis | Where-Object { $_.sn -eq $VxmHost.sn }
                            Section -Style Heading3 "$($VxmHost.hostname)" {
                                #region Hardware Section
                                Section -Style Heading4 "Hardware" {
                                    $VxmHostHW = [PSCustomObject]@{
                                        'Hostname' = $VxmHost.hostname
                                        'Manufacturer' = $VxmHost.Manufacturer
                                        'Model' = $VxmClusterHost.Model
                                        'Serial Number' = $VxmHost.sn
                                        'Appliance ID' = $VxmHost.psnt
                                        'Slot' = $VxmHost.slot
                                        'Power State' = $TextInfo.ToTitleCase($VxmHost.power_status)              
                                        'Connected' = Switch ($VxmHost.missing) {
                                            $true { 'No' }
                                            $false { 'Yes' }
                                        }
                                        'Health State' = $VxmHost.health
                                        'Operation Status' = Switch ($VxmHost.operational_status) {
                                            'normal' { 'Available' }
                                            'powering_off' { 'Powering Off' }
                                            default { $TextInfo.ToTitleCase($VxmHost.operational_status) }
                                        }
                                    }
                                    if ($Healthcheck.Appliance.PowerState) {
                                        $VxmHostHW | Where-Object { $_.'Power State' -ne 'On' } | Set-Style -Style Critical -Property 'Power State'
                                    }
                                    if ($Healthcheck.Appliance.Health) {
                                        $VxmHostHW | Where-Object { $_.'Health State' -eq 'Warning' } | Set-Style -Style Warning -Property 'Health State'
                                        $VxmHostHW | Where-Object { $_.'Health State' -eq 'Error' } | Set-Style -Style Critical -Property 'Health State'

                                    }
                                    $TableParams = @{
                                        Name = "Hardware Specifications - $($VxmHost.hostname)"
                                        List = $true
                                        ColumnWidths = 50, 50
                                    }
                                    if ($Report.ShowTableCaptions) {
                                        $TableParams['Caption'] = "- $($TableParams.Name)"
                                    }
                                    $VxmHostHW | Table @TableParams
                                }
                                #endregion Hardware Section

                                #region Firmware Section
                                Section -Style Heading4 "Firmware" {
                                    $VxmHostFwInfo = $VxmHost.FirmwareInfo
                                    $VxmHostFW = [PSCustomObject]@{
                                        'BIOS Revision' = $VxmHostFwInfo.bios_revision
                                        'BMC Revision' = $VxmHostFwInfo.bmc_revision
                                        'HBA Version' = $VxmHostFwInfo.hba_version
                                        'Expander BPF Version' = $VxmHostFwInfo.expander_bpf_version
                                        'BOSS Version' = $VxmHostFwInfo.boss_version
                                        'CPLD Version' = $VxmHostFwInfo.cpld_version
                                        'IDSDM Version' = $VxmHostFwInfo.idsdm_version
                                    }
                                    $TableParams = @{
                                        Name = "Firmware Specifications - $($VxmHost.hostname)"
                                        List = $true
                                        ColumnWidths = 50, 50
                                    }
                                    if ($Report.ShowTableCaptions) {
                                        $TableParams['Caption'] = "- $($TableParams.Name)"
                                    }
                                    $VxmHostFW | Table @TableParams
                                }
                                #endregion Firmware Section

                                #region Boot Devices
                                $VxmHostBootDevices = $VxmHost.boot_devices | Sort-Object slot
                                if ($VxmHostBootDevices) {
                                    Section -Style Heading4 "Boot Devices" {
                                        $VxmHostBootDeviceInfo = foreach ($VxmHostBootDevice in $VxmHostBootDevices) {
                                            [PSCustomObject]@{
                                                'Boot Device' = $VxmHostBootDevice.slot
                                                'Device Type' = $VxmHostBootDevice.bootdevice_type
                                                'Serial Number' = $VxmHostBootDevice.sn
                                                'Model' = $VxmHostBootDevice.device_model
                                                'SATA Type' = $VxmHostBootDevice.sata_type
                                                'Capacity' = $VxmHostBootDevice.capacity
                                                'Health' = $VxmHostBootDevice.health
                                                'Firmware' = $VxmHostBootDevice.firmware_version
                                            }
                                        }
                                        if ($Healthcheck.Appliance.BootDevice) {
                                            $VxmHostBootDeviceInfo | Where-Object { $_.'Health' -ne '100%' } | Set-Style -Style Warning -Property 'Health'
                                        }
                                        if ($InfoLevel.Appliance -ge 2) {
                                            foreach ($VxmHostBootDevice in $VxmHostBootDeviceInfo) {
                                                Section -Style Heading5 "Boot Device $($VxmHostBootDevice.'Boot Device')" {
                                                    $TableParams = @{
                                                        Name = "Boot Device $($VxmHostBootDevice.'Boot Device') Specifications - $($VxmHost.hostname)"
                                                        List = $true
                                                        ColumnWidths = 50, 50
                                                    }
                                                    if ($Report.ShowTableCaptions) {
                                                        $TableParams['Caption'] = "- $($TableParams.Name)"
                                                    }
                                                    $VxmHostBootDevice | Table @TableParams
                                                }
                                            }
                                        } else {
                                            $TableParams = @{
                                                Name = "Boot Device Specifications - $($VxmHost.hostname)"
                                                Columns = 'Boot Device', 'Device Type', 'SATA Type', 'Capacity', 'Health', 'Firmware'
                                                ColumnWidths = 16, 17, 16, 17, 17, 17
                                            }
                                            if ($Report.ShowTableCaptions) {
                                                $TableParams['Caption'] = "- $($TableParams.Name)"
                                            }
                                            $VxmHostBootDeviceInfo | Table @TableParams
                                        }
                                    }
                                }
                                #endregion Boot Devices

                                #region Disks
                                $VxmHostDisks = $VxmHost.disks | Sort-Object enclosure, bay, slot
                                if ($VxmHostDisks) {
                                    Section -Style Heading4 "Disks" {
                                        $VxmHostDiskInfo = foreach ($VxmHostDisk in $VxmHostDisks) {
                                            [PSCustomObject]@{
                                                'Enclosure' = $VxmHostDisk.Enclosure
                                                'Bay' = $VxmHostDisk.Bay
                                                'Slot' = $VxmHostDisk.Slot
                                                'Serial Number' = $VxmHostDisk.sn
                                                'Manufacturer' = $VxmHostDisk.manufacturer
                                                'Model' = $VxmHostDisk.model
                                                'Firmware' = $VxmHostDisk.firmware_revision
                                                'Disk Type' = $VxmHostDisk.disk_type
                                                'Capacity' = $VxmHostDisk.capacity
                                                'Speed' = $VxmHostDisk.max_capable_speed
                                                'Status' = $VxmHostDisk.disk_state
                                            }
                                        }
                                        if ($Healthcheck.Appliance.Disk) {
                                            $VxmHostDiskInfo | Where-Object { $_.'Status' -ne 'OK' } | Set-Style -Style Critical -Property 'Status'
                                        }
                                        if ($InfoLevel.Appliance -ge 2) {
                                            foreach ($VxmHostDisk in $VxmHostDiskInfo) {
                                                Section -Style Heading5 "Enclosure $($VxmHostDisk.Enclosure) Bay $($VxmHostDisk.Bay) Disk $($VxmHostDisk.Slot)" {
                                                    $TableParams = @{
                                                        Name = "Enclosure $($VxmHostDisk.Enclosure) Bay $($VxmHostDisk.Bay) Disk $($VxmHostDisk.Slot) Specifications - $($VxmHost.hostname)"
                                                        List = $true
                                                        ColumnWidths = 50, 50
                                                    }
                                                    if ($Report.ShowTableCaptions) {
                                                        $TableParams['Caption'] = "- $($TableParams.Name)"
                                                    }
                                                    $VxmHostDisk | Table @TableParams
                                                }
                                            }
                                        } else {
                                            $TableParams = @{
                                                Name = "Disk Specifications - $($VxmHost.hostname)"
                                                Headers = 'Encl', 'Bay', 'Slot', 'Serial Number', 'Type', 'Capacity', 'Speed', 'Status', 'Firmware'
                                                Columns = 'Enclosure', 'Bay', 'Slot', 'Serial Number', 'Disk Type', 'Capacity', 'Speed', 'Status', 'Firmware'
                                                ColumnWidths = 8, 8, 8, 20, 10, 13, 11, 11, 11
                                            }
                                            if ($Report.ShowTableCaptions) {
                                                $TableParams['Caption'] = "- $($TableParams.Name)"
                                            }
                                            $VxmHostDiskInfo | Table @TableParams
                                        }
                                    }
                                }
                                #endregion Disks

                                #region NICs
                                $VxmHostNics = $VxmHost.nics | Sort-Object slot
                                if ($VxmHostNics) {
                                    Section -Style Heading4 "NICs" {
                                        $VxmHostNicInfo = foreach ($VxmHostNic in $VxmHostNics) {
                                            [PSCustomObject]@{
                                                'NIC' = $VxmHostNic.slot
                                                'MAC Address' = $VxmHostNic.mac
                                                'Link Speed' = $VxmHostNic.link_speed
                                                'Link Status' = $VxmHostNic.link_status
                                                'Firmware' = $VxmHostNic.firmware_family_version
                                            }
                                        }
                                        if ($Healthcheck.Appliance.NetworkLinkStatus) {
                                            $VxmHostNicInfo | Where-Object { $_.'Link Status' -ne 'Up' } | Set-Style -Style Critical -Property 'Link Status'
                                        }
                                        $TableParams = @{
                                            Name = "NIC Specifications - $($VxmHost.hostname)"
                                            ColumnWidths = 20, 20, 20, 20, 20
                                        }
                                        if ($Report.ShowTableCaptions) {
                                            $TableParams['Caption'] = "- $($TableParams.Name)"
                                        }
                                        $VxmHostNicInfo | Table @TableParams
                                    }
                                }
                                #endregion NICs

                                #region iDRAC Section
                                $VxmHostiDRACNetwork = Get-VxRailApi -Version 1 -Uri ('/hosts/' + $VxmHost.sn + '/idrac/network')
                                Section -Style Heading4 'iDRAC' {
                                    $VxmHostiDRAC = [PSCustomObject]@{
                                        'DHCP' = Switch ($VxmHostiDRACNetwork.dhcp_enabled) {
                                            $true { 'Enabled' }
                                            $False { 'Disabled' }
                                        }
                                        'IP Address' = $VxmHostiDRACNetwork.ip.ip_address
                                        'Subnet Mask' = $VxmHostiDRACNetwork.ip.netmask
                                        'Default Gateway' = $VxmHostiDRACNetwork.ip.Gateway
                                        'VLAN ID' = $VxmHostiDRACNetwork.vlan.vlan_id
                                    }
                                    $TableParams = @{
                                        Name = "iDRAC Specifications - $($VxmHost.hostname)"
                                        List = $true
                                        ColumnWidths = 50, 50
                                    }
                                    if ($Report.ShowTableCaptions) {
                                        $TableParams['Caption'] = "- $($TableParams.Name)"
                                    }
                                    $VxmHostiDRAC | Table @TableParams
                                }
                                #endregion iDRAC Section

                                #region Power Supplies
                                $VxmHostPSUs = $VxmHostChassis.power_supplies | Sort-Object slot
                                if ($VxmHostPSUs) {
                                    Section -Style Heading4 "PSUs" {
                                        $VxmHostPsuInfo = foreach ($VxmHostPSU in $VxmHostPSUs) {
                                            [PSCustomObject]@{
                                                'PSU' = $VxmHostPSU.slot
                                                'Manufacturer' = $VxmHostPSU.manufacturer
                                                'Serial Number' = $VxmHostPSU.sn
                                                'Part Number' = $VxmHostPSU.part_number
                                                'Health' = $VxmHostPSU.health
                                                'Revision' = $VxmHostPSU.revision_number
                                            }
                                        }
                                        if ($Healthcheck.Appliance.PowerSupply) {
                                            $VxmHostPsuInfo | Where-Object { $_.'Health' -ne 'Healthy' } | Set-Style -Style Critical -Property 'Health'
                                        }
                                        $TableParams = @{
                                            Name = "PSU Specifications - $($VxmHost.hostname)"
                                            ColumnWidths = 13, 17, 21, 21, 14, 14
                                        }
                                        if ($Report.ShowTableCaptions) {
                                            $TableParams['Caption'] = "- $($TableParams.Name)"
                                        }
                                        $VxmHostPsuInfo | Table @TableParams
                                    }
                                }
                                #endregion Power Supplies

                                #region ESXi Section
                                if ($VxmClusterHost) {
                                    Section -Style Heading4 'ESXi' {
                                        $ESXiHost = [PSCustomObject]@{
                                            'Management IP Address' = ($VxmClusterHost.ip_set).management_ip
                                            'vMotion IP Address' = ($VxmClusterHost.ip_set).vmotion_ip
                                            'vSAN IP Address' = ($VxmClusterHost.ip_set).vsan_ip
                                        }
                                        $TableParams = @{
                                            Name = "ESXi Specifications - $($VxmClusterHost.host_name)"
                                            List = $true
                                            ColumnWidths = 50, 50
                                        }
                                        if ($Report.ShowTableCaptions) {
                                            $TableParams['Caption'] = "- $($TableParams.Name)"
                                        }
                                        $ESXiHost | Table @TableParams
                                    }
                                }
                                #endregion ESXi Section
                            }
                        }
                    }
                }
                #endregion Appliance Section

                #region Support Section
                if ($VxmCallHome -and $VxmCallHomeInfo) {
                    Section -Style Heading2 'Support' {
                        Section -Style Heading3 'Dell EMC Secure Remote Service (ESRS)' {
                            $CallHome = [PSCustomObject]@{
                                'ESRS Status' = $VxmCallHomeInfo.status
                                'ESRS Type' = Switch ($VxmCallHome.integrated) {
                                    $true { 'Internal ESRS' }
                                    $false { 'External ESRS' }
                                }
                                'ESRS Connection' = Switch ($VxmCallHomeMode.is_muted) {
                                    $true { 'Enabled' }
                                    $false { 'Disabled' }
                                }
                                'ESRS VM IP Address' = $VxmCallHome.ip_list.ip -join ', '
                                'Site ID' = $VxmCallHome.site_id
                            }
                            $TableParams = @{
                                Name = "Dell EMC Secure Remote Service - $($VxRailMgrHostName)"
                                List = $true
                                ColumnWidths = 50, 50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $CallHome | Table @TableParams
                        }
                    }
                }
                #endregion Support Section

                #region Networking Section
                Write-PScriboMessage "Network InfoLevel set at $($InfoLevel.Network)."
                if ($InfoLevel.Network -gt 0) {
                    Section -Style Heading2 'VxRail Network' {
                        #region Genera;l Network Section
                        Section -Style Heading3 'General' {
                            $Networking = [PSCustomObject]@{
                                'Internet Connection Status' = Switch ($VxmInternetMode.is_dark_site) {
                                    $true { 'Disabled' }
                                    $false { 'Enabled' }
                                }
                                'Proxy Status' = & {
                                    if ($VxmProxy) {
                                        "Enabled"
                                    } else {
                                        "Disabled"
                                    }
                                }
                            }
                            $TableParams = @{
                                Name = "General Network Specifications - $($VxRailMgrHostName)"
                                List = $true
                                ColumnWidths = 50, 50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $Networking | Table @TableParams

                            #region Proxy Server Section
                            if ($VxmProxy) {
                                Section -Style Heading3 'Proxy Server' {
                                    $ProxyServer = [PSCustomObject]@{
                                        'Protocol' = $VxmProxy.Type
                                        'IP Address' = $VxmProxy.Server
                                        'Port' = $VxmProxy.Port
                                    }
                                    $TableParams = @{
                                        Name = "Proxy Server Specifications - $($VxRailMgrHostName)"
                                        List = $true
                                        ColumnWidths = 50, 50
                                    }
                                    if ($Report.ShowTableCaptions) {
                                        $TableParams['Caption'] = "- $($TableParams.Name)"
                                    }
                                    $ProxyServer | Table @TableParams
                                }
                            }
                            #endregion Proxy Server Section
                        }
                        #endregion Genera;l Network Section

                        #region Network Pools
                        if ($VxmClusterNetPools) {
                            Section -Style Heading3 'Network Pools' {
                                #region Management Network Pool
                                Section -Style Heading4 'Management' {
                                    $VxmMgmtNetPool = [PSCustomObject]@{
                                        'Network Pool' = "$($VxmClusterNetPools.management.pools.minIp) - $($VxmClusterNetPools.management.pools.maxIp)"
                                        'Subnet Mask' = $VxmClusterNetPools.management.subnetmask
                                        'Gateway' = $VxmClusterNetPools.gateway
                                        'Total' = $VxmClusterNetPools.management.total
                                        'Used' = $VxmClusterNetPools.management.used
                                        'VLAN ID' = $VxmClusterNetPools.management.vlan_id
                                    }
                                    $TableParams = @{
                                        Name = "Management Network Pool Specifications - $($VxRailMgrHostName)"
                                        List = $true
                                        ColumnWidths = 50, 50
                                    }
                                    if ($Report.ShowTableCaptions) {
                                        $TableParams['Caption'] = "- $($TableParams.Name)"
                                    }
                                    $VxmMgmtNetPool | Table @TableParams
                                }
                                #endregion Management Network Pool

                                #region vMotion Network Pool
                                Section -Style Heading4 'vMotion' {
                                    $VxmVmotionNetPool = [PSCustomObject]@{
                                        'Network Pool' = "$($VxmClusterNetPools.vmotion.pools.minIp) - $($VxmClusterNetPools.vmotion.pools.maxIp)"
                                        'Subnet Mask' = $VxmClusterNetPools.vmotion.subnetmask
                                        'Gateway' = $VxmClusterNetPools.gateway
                                        'Total' = $VxmClusterNetPools.vmotion.total
                                        'Used' = $VxmClusterNetPools.vmotion.used
                                        'VLAN ID' = $VxmClusterNetPools.vmotion.vlan_id
                                    }
                                    $TableParams = @{
                                        Name = "vMotion Network Pool Specifications - $($VxRailMgrHostName)"
                                        List = $true
                                        ColumnWidths = 50, 50
                                    }
                                    if ($Report.ShowTableCaptions) {
                                        $TableParams['Caption'] = "- $($TableParams.Name)"
                                    }
                                    $VxmVmotionNetPool | Table @TableParams
                                }
                                #endregion vMotion Network Pool

                                #region vSAN Network Pool
                                Section -Style Heading4 'vSAN' {
                                    $VxmVsanNetPool = [PSCustomObject]@{
                                        'Network Pool' = "$($VxmClusterNetPools.vsan.pools.minIp) - $($VxmClusterNetPools.vsan.pools.maxIp)"
                                        'Subnet Mask' = $VxmClusterNetPools.vsan.subnetmask
                                        'Gateway' = $VxmClusterNetPools.gateway
                                        'Total' = $VxmClusterNetPools.vsan.total
                                        'Used' = $VxmClusterNetPools.vsan.used
                                        'VLAN ID' = $VxmClusterNetPools.vsan.vlan_id
                                    }
                                    $TableParams = @{
                                        Name = "vSAN Network Pool Specifications - $($VxRailMgrHostName)"
                                        List = $true
                                        ColumnWidths = 50, 50
                                    }
                                    if ($Report.ShowTableCaptions) {
                                        $TableParams['Caption'] = "- $($TableParams.Name)"
                                    }
                                    $VxmVsanNetPool | Table @TableParams
                                }
                                #endregion vSAN Network Pool
                            }
                        }
                        #endregion Network Pools
                    }
                }
                #endregion Networking Section
            }
            #endregion VxRail Section
        }
        $Null = Disconnect-VIServer -Server $VIServer -Confirm:$false -ErrorAction SilentlyContinue
    }
    #endregion foreach loop
}