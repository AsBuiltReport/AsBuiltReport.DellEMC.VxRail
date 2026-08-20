# culture = 'en-GB'
@{
    InvokeAsBuiltReportDellEMCVxRail = ConvertFrom-StringData @'
        ProjectInfo             = Please refer to https://www.asbuiltreport.com for more detailed information about this project.
        ConfigReminder          = Do not forget to update your report configuration file after each new version release.
        DocumentationLink       = Documentation: {0}
        IssuesLink              = Issues or bug reporting: {0}
        InstalledVersion        = AsBuiltReport.DellEMC.VxRail {0} is currently installed.
        LatestVersionAvailable  = AsBuiltReport.DellEMC.VxRail {0} is available.
        UpdateModule            = Run 'Update-Module -Name AsBuiltReport.DellEMC.VxRail -Force' to install the latest version.
        Connecting              = Connecting to vCenter Server '{0}'.
        CollectingVxRailInfo    = Collecting VxRail Manager Information.
        ClusterNotFound         = Unable to find VxRail Cluster '{0}'.
        ConnectingVxRailMgr     = Connecting to VxRail Manager {0}.
        ApiCallHosts            = Performing API reference call to path /hosts.
        ApiCallChassis          = Performing API reference call to path /chassis.
        ApiCallClusterHosts     = Performing API reference call to path /system/cluster-hosts.
        SectionParagraph        = The following sections detail the VxRail cluster configuration managed by VxRail Manager {0}.
        ClusterInfoLevel        = Cluster InfoLevel set at {0}.
        ClusterHeading          = VxRail Cluster
        ClusterParagraph        = The following section provides a configuration summary of the VxRail cluster, ESXi hosts and virtual machines.
        ApplianceInfoLevel      = Appliance InfoLevel set at {0}.
        ApplianceHeading        = VxRail Appliances
        ApplianceParagraph      = The following sections detail the configuration of VxRail Appliances managed by VxRail Manager {0}.
        ApplianceHostParagraph  = The following section details the hardware configuration for VxRail Appliance {0}.
        IdracHeading            = iDRAC
        SupportInfoLevel        = Support InfoLevel set at {0}.
        NetworkInfoLevel        = Network InfoLevel set at {0}.
        ConnectionError         = Unable to connect to vCenter Server '{0}'.
'@

    GetAbrVxRailCluster = ConvertFrom-StringData @'
        Collecting               = Collecting VxRail cluster information.
        ApiCallSystem             = Performing API reference call to path /system.
        ApiCallVcMode             = Performing API reference call to path /vc/mode.
        TableName                 = VxRail Cluster Specifications - {0}
        VxRailManager             = VxRail Manager
        VxRailManagerIP           = VxRail Manager IP
        VxRailVersion             = VxRail Version
        VxRailClusterName         = VxRail Cluster Name
        VxRailClusterType         = VxRail Cluster Type
        NumberOfHosts             = Number of Hosts
        HealthStatus              = Health Status
        VCenterServer             = vCenter Server
        VCenterVersion            = vCenter Version
        VCenterServerMode         = vCenter Server Mode
        PscMode                   = PSC Mode
        VCenterServerConnected    = vCenter Server Connected
        ExternalVCenterServer     = External vCenter Server
        InstallationDate          = Installation Date
        Yes                       = Yes
        No                        = No
        NotAvailable              = --
        ErrorMessage              = VxRail Cluster Section: {0}
'@

    GetAbrVxRailAvailableHost = ConvertFrom-StringData @'
        Collecting      = Collecting VxRail available host information.
        ApiCall         = Performing API reference call to path /system/available-hosts.
        Heading         = Available ESXi Hosts
        TableName       = Available ESXi Host Specifications - {0}
        ServiceTag      = Service Tag
        ApplianceID     = Appliance ID
        Model           = Model
        DiscoveredDate  = Discovered Date
        ErrorMessage    = Available ESXi Hosts Section: {0}
'@

    GetAbrVxRailClusterHost = ConvertFrom-StringData @'
        Collecting     = Collecting VxRail cluster host information.
        ApiCall        = Performing API reference call to path /system/cluster-hosts.
        Heading        = ESXi Hosts
        TableName      = ESXi Host Specifications - {0}
        Hostname       = Hostname
        ManagementIP   = ESXi Host Management IP
        ServiceTag     = Service Tag
        ApplianceID    = Appliance ID
        Model          = Model
        ErrorMessage   = VxRail Cluster Host Section: {0}
'@

    GetAbrVxRailClusterVMs = ConvertFrom-StringData @'
        Collecting    = Collecting VxRail cluster VM information.
        ApiCall       = Performing API reference call to path /cluster/system-virtual-machines.
        Heading       = Virtual Machines
        TableName     = Virtual Machines - {0}
        VirtualMachine = Virtual Machine
        EsxiHost      = ESXi Host
        Status        = Status
        ErrorMessage  = VxRail Cluster VM Section: {0}
'@

    GetAbrVxRailClusterComponents = ConvertFrom-StringData @'
        Collecting          = Collecting VxRail cluster component information.
        ApiCall             = Performing API reference call to path /system.
        Heading             = Installed Components
        TableName           = Installed Components - {0}
        Name                = Name
        Description         = Description
        Version             = Version
        AvailableUpdates    = Available Updates
        NoUpdateAvailable   = No Update Available
        DownloadError       = Download Error
        UpdateAvailable     = Update Available
        ErrorMessage        = VxRail Cluster Components Section: {0}
'@

    GetAbrVxRailClusterNetwork = ConvertFrom-StringData @'
        Collecting              = Collecting VxRail cluster network information.
        ApiCallProxy            = Performing API reference call to path /system/proxy.
        ApiCallInternetMode     = Performing API reference call to path /system/internet-mode.
        ApiCallNetworkPools     = Performing API reference call to path /cluster/network/pools.
        Heading                 = VxRail Network
        Paragraph               = The following section details the VxRail Manager general network settings for {0}.
        GeneralHeading          = General
        InternetConnectionStatus = Internet Connection Status
        ProxyStatus             = Proxy Status
        Enabled                 = Enabled
        Disabled                = Disabled
        GeneralTableName        = General Network Specifications - {0}
        ProxyServerHeading      = Proxy Server
        Protocol                = Protocol
        IPAddress               = IP Address
        Port                    = Port
        ProxyServerTableName    = Proxy Server Specifications - {0}
        NetworkPoolsHeading     = Network Pools
        NetworkPool             = Network Pool
        SubnetMask              = Subnet Mask
        Gateway                 = Gateway
        Total                   = Total
        Used                    = Used
        Available               = Available
        VlanId                  = VLAN ID
        ManagementHeading       = Management
        ManagementTableName     = Management Network Pool Specifications - {0}
        VmotionHeading          = vMotion
        VmotionTableName        = vMotion Network Pool Specifications - {0}
        VsanHeading             = vSAN
        VsanTableName           = vSAN Network Pool Specifications - {0}
        ErrorMessage            = VxRail Cluster Network Section: {0}
'@

    GetAbrVxRailClusterSupport = ConvertFrom-StringData @'
        Collecting             = Collecting VxRail cluster support information.
        ApiCallCallHomeMode    = Performing API reference call to path /callhome/mode.
        ApiCallCallHomeInfo    = Performing API reference call to path /callhome/info.
        ApiCallSupportAccount  = Performing API reference call to path /support/account.
        ApiCallSupportContact  = Performing API reference call to path /support/contact.
        Heading                = Support
        Paragraph              = The following section details the VxRail Manager support settings for {0}.
        SupportAccountHeading  = Dell EMC Support Account
        SupportAccount         = Support Account
        SupportAccountTableName = Dell EMC Support Account - {0}
        SrsHeading             = Dell EMC Secure Remote Service (SRS)
        SrsStatus              = SRS Status
        NotConfigured          = Not Configured
        SrsType                = SRS Type
        InternalEsrs           = Internal ESRS
        ExternalEsrs           = External ESRS
        SrsConnection          = SRS Connection
        Enabled                = Enabled
        Disabled               = Disabled
        SrsVmIPAddress         = SRS VM IP Address
        SiteID                 = Site ID
        SrsTableName           = Dell EMC Secure Remote Service - {0}
        SupportContactHeading  = Support Contact
        Company                = Company
        Email                  = Email
        FirstName              = First Name
        LastName               = Last Name
        PhoneNumber            = Phone Number
        NotAvailable           = --
        SupportContactTableName = Support Contact Information - {0}
        ErrorMessage           = VxRail Cluster Support Section: {0}
'@

    GetAbrVxRailHostHardware = ConvertFrom-StringData @'
        Collecting       = Collecting {0} hardware information.
        Heading          = Hardware
        TableName        = Hardware Specifications - {0}
        Hostname         = Hostname
        Manufacturer     = Manufacturer
        Model            = Model
        SerialNumber     = Serial Number
        ApplianceID      = Appliance ID
        Slot             = Slot
        PowerStatus      = Power Status
        Connected        = Connected
        Yes              = Yes
        No               = No
        TpmPresent       = TPM Present
        HealthStatus     = Health Status
        OperationStatus  = Operation Status
        Available        = Available
        PoweringOff      = Powering Off
        ErrorMessage     = VxRail Host Hardware Section: {0}
'@

    GetAbrVxRailHostEsxi = ConvertFrom-StringData @'
        Collecting        = Collecting {0} ESXi information.
        Heading           = ESXi
        TableName         = ESXi Specifications - {0}
        ManagementIP      = Management IP Address
        VmotionIP         = vMotion IP Address
        VsanIP            = vSAN IP Address
        ErrorMessage      = VxRail Host ESXi Section: {0}
'@

    GetAbrVxRailHostFirmware = ConvertFrom-StringData @'
        Collecting              = Collecting {0} firmware information.
        Heading                 = Firmware
        TableName               = Firmware Versions - {0}
        Bios                    = BIOS
        Bmc                     = BMC
        CpldFirmware            = CPLD Firmware
        Hba                     = HBA
        ExpanderBackPlane       = Expander Back Plane
        NonExpanderBackPlane    = Non-Expander Back Plane
        Boss                    = BOSS
        IdsdmFirmware           = IDSDM Firmware
        DcpmFirmware            = DCPM Firmware
        PercFirmware            = PERC Firmware
        ErrorMessage            = VxRail Host Firmware Section: {0}
'@

    GetAbrVxRailHostComponent = ConvertFrom-StringData @'
        Collecting     = Collecting {0} component information.
        Heading        = Components
        TableName      = Component Versions - {0}
        VMwareEsxi     = VMware ESXi
        VxRailVib      = VxRail VIB
        DellPtAgent    = Dell PtAgent
        HbaDriver      = HBA Driver
        ErrorMessage   = VxRail Host Component Section: {0}
'@

    GetAbrVxRailHostBootDevice = ConvertFrom-StringData @'
        Collecting     = Collecting {0} boot device information.
        Heading        = Boot Devices
        DeviceHeading  = Boot Device {0}
        BootDevice     = Boot Device
        DeviceType     = Device Type
        SerialNumber   = Serial Number
        Model          = Model
        SataType       = SATA Type
        Capacity       = Capacity
        Health         = Health
        Firmware       = Firmware
        DeviceTableName = Boot Device {0} Specifications - {1}
        TableName      = Boot Device Specifications - {0}
        ErrorMessage   = VxRail Host Boot Device Section: {0}
'@

    GetAbrVxRailHostDisk = ConvertFrom-StringData @'
        Collecting      = Collecting {0} disk information.
        Heading         = Disks
        DeviceHeading   = Enclosure {0} Disk {1}
        Enclosure       = Enclosure
        Slot            = Slot
        SerialNumber    = Serial Number
        Manufacturer    = Manufacturer
        Model           = Model
        Firmware        = Firmware
        DiskType        = Disk Type
        Capacity        = Capacity
        Speed           = Speed
        Status          = Status
        DeviceTableName = Enclosure {0} Disk {1} Specifications - {2}
        TableName       = Disk Specifications - {0}
        HeaderEncl      = Encl
        HeaderType      = Type
        ErrorMessage    = VxRail Host Disk Section: {0}
'@

    GetAbrVxRailHostNic = ConvertFrom-StringData @'
        Collecting    = Collecting {0} NIC information.
        Heading       = NICs
        TableName     = NIC Specifications - {0}
        Nic           = NIC
        MacAddress    = MAC Address
        LinkSpeed     = Link Speed
        LinkStatus    = Link Status
        Firmware      = Firmware
        ErrorMessage  = VxRail Host NIC Section: {0}
'@

    GetAbrVxRailHostPsu = ConvertFrom-StringData @'
        Collecting    = Collecting {0} PSU information.
        Heading       = PSUs
        TableName     = PSU Specifications - {0}
        Psu           = PSU
        Manufacturer  = Manufacturer
        SerialNumber  = Serial Number
        PartNumber    = Part Number
        Health        = Health
        Revision      = Revision
        ErrorMessage  = VxRail Host PSU Section: {0}
'@

    GetAbrVxRailHostIdracIPv4 = ConvertFrom-StringData @'
        Collecting    = Collecting {0} iDRAC information.
        Heading       = IPv4 Settings
        TableName     = iDRAC IPv4 Specifications - {0}
        Dhcp          = DHCP
        Enabled       = Enabled
        Disabled      = Disabled
        IPv4Address   = IPv4 Address
        SubnetMask    = Subnet Mask
        Gateway       = Gateway
        ErrorMessage  = VxRail Host iDRAC IPv4 Section: {0}
'@

    GetAbrVxRailHostIdracVlan = ConvertFrom-StringData @'
        Collecting     = Collecting {0} iDRAC VLAN information.
        Heading        = VLAN Settings
        TableName      = iDRAC VLAN Specifications - {0}
        Vlan           = VLAN
        Enabled        = Enabled
        Disabled       = Disabled
        VlanId         = VLAN ID
        VlanPriority   = VLAN Priority
        ErrorMessage   = VxRail Host iDRAC VLAN Section: {0}
'@

    GetAbrVxRailHostIdracUser = ConvertFrom-StringData @'
        Collecting      = Collecting {0} iDRAC user information.
        Heading         = Users
        TableName       = iDRAC User Specifications - {0}
        ID              = ID
        UserName        = User Name
        Privilege       = Privilege
        Administrator   = Administrator
        ErrorMessage    = VxRail Host iDRAC User Section: {0}
'@
}
