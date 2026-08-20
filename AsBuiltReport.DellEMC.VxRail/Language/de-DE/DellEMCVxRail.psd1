# culture = 'de-DE'
@{
    InvokeAsBuiltReportDellEMCVxRail = ConvertFrom-StringData @'
        Connecting              = Verbindung zu vCenter Server '{0}' wird hergestellt.
        CollectingVxRailInfo    = VxRail Manager-Informationen werden erfasst.
        ClusterNotFound         = VxRail-Cluster '{0}' wurde nicht gefunden.
        ConnectingVxRailMgr     = Verbindung zu VxRail Manager {0} wird hergestellt.
        ApiCallHosts            = API-Referenzaufruf an den Pfad /hosts wird ausgeführt.
        ApiCallChassis          = API-Referenzaufruf an den Pfad /chassis wird ausgeführt.
        ApiCallClusterHosts     = API-Referenzaufruf an den Pfad /system/cluster-hosts wird ausgeführt.
        SectionParagraph        = Die folgenden Abschnitte beschreiben die Konfiguration des von VxRail Manager {0} verwalteten VxRail-Clusters.
        ClusterInfoLevel        = Cluster-InfoLevel auf {0} festgelegt.
        ClusterHeading          = VxRail-Cluster
        ClusterParagraph        = Der folgende Abschnitt bietet eine Zusammenfassung der Konfiguration des VxRail-Clusters, der ESXi-Hosts und der virtuellen Maschinen.
        ApplianceInfoLevel      = Appliance-InfoLevel auf {0} festgelegt.
        ApplianceHeading        = VxRail-Appliances
        ApplianceParagraph      = Die folgenden Abschnitte beschreiben die Konfiguration der von VxRail Manager {0} verwalteten VxRail-Appliances.
        ApplianceHostParagraph  = Der folgende Abschnitt beschreibt die Hardwarekonfiguration der VxRail-Appliance {0}.
        IdracHeading            = iDRAC
        SupportInfoLevel        = Support-InfoLevel auf {0} festgelegt.
        CertificateInfoLevel    = Certificate-InfoLevel auf {0} festgelegt.
        PrecheckInfoLevel       = Precheck-InfoLevel auf {0} festgelegt.
        NetworkInfoLevel        = Network-InfoLevel auf {0} festgelegt.
        ConnectionError         = Verbindung zu vCenter Server '{0}' konnte nicht hergestellt werden.
'@

    GetAbrVxRailCluster = ConvertFrom-StringData @'
        Collecting               = VxRail-Clusterinformationen werden erfasst.
        ApiCallSystem             = API-Referenzaufruf an den Pfad /system wird ausgeführt.
        ApiCallVcMode             = API-Referenzaufruf an den Pfad /vc/mode wird ausgeführt.
        ApiCallTelemetryTier      = API-Referenzaufruf an den Pfad /telemetry/tier wird ausgeführt.
        TableName                 = VxRail-Cluster-Spezifikationen - {0}
        VxRailManager             = VxRail Manager
        VxRailManagerIP           = VxRail Manager-IP
        VxRailVersion             = VxRail-Version
        VxRailClusterName         = VxRail-Clustername
        VxRailClusterType         = VxRail-Clustertyp
        NumberOfHosts             = Anzahl der Hosts
        HealthStatus              = Systemzustand
        VCenterServer             = vCenter Server
        VCenterVersion            = vCenter-Version
        VCenterServerMode         = vCenter Server-Modus
        PscMode                   = PSC-Modus
        VCenterServerConnected    = vCenter Server verbunden
        ExternalVCenterServer     = Externer vCenter Server
        TelemetryTier             = Telemetriestufe
        InstallationDate          = Installationsdatum
        Yes                       = Ja
        No                        = Nein
        NotAvailable              = --
        ErrorMessage              = Abschnitt VxRail-Cluster: {0}
'@

    GetAbrVxRailAvailableHost = ConvertFrom-StringData @'
        Collecting      = Informationen zu verfügbaren VxRail ESXi-Hosts werden erfasst.
        ApiCall         = API-Referenzaufruf an den Pfad /system/available-hosts wird ausgeführt.
        Heading         = Verfügbare ESXi-Hosts
        TableName       = Spezifikationen verfügbarer ESXi-Hosts - {0}
        ServiceTag      = Service-Tag
        ApplianceID     = Appliance-ID
        Model           = Modell
        DiscoveredDate  = Erkennungsdatum
        ErrorMessage    = Abschnitt Verfügbare ESXi-Hosts: {0}
'@

    GetAbrVxRailClusterHost = ConvertFrom-StringData @'
        Collecting     = Informationen zu VxRail-Clusterhosts werden erfasst.
        ApiCall        = API-Referenzaufruf an den Pfad /system/cluster-hosts wird ausgeführt.
        Heading        = ESXi-Hosts
        TableName      = ESXi-Host-Spezifikationen - {0}
        Hostname       = Hostname
        ManagementIP   = ESXi Host-Management-IP
        ServiceTag     = Service-Tag
        ApplianceID    = Appliance-ID
        Model          = Modell
        ErrorMessage   = Abschnitt VxRail-Clusterhosts: {0}
'@

    GetAbrVxRailClusterVMs = ConvertFrom-StringData @'
        Collecting    = Informationen zu VxRail-Cluster-VMs werden erfasst.
        ApiCall       = API-Referenzaufruf an den Pfad /cluster/system-virtual-machines wird ausgeführt.
        Heading       = Virtuelle Maschinen
        TableName     = Virtuelle Maschinen - {0}
        VirtualMachine = Virtuelle Maschine
        EsxiHost      = ESXi-Host
        Status        = Status
        ErrorMessage  = Abschnitt VxRail-Cluster-VMs: {0}
'@

    GetAbrVxRailClusterComponents = ConvertFrom-StringData @'
        Collecting          = Informationen zu VxRail-Clusterkomponenten werden erfasst.
        ApiCall             = API-Referenzaufruf an den Pfad /system wird ausgeführt.
        Heading             = Installierte Komponenten
        TableName           = Installierte Komponenten - {0}
        Name                = Name
        Description         = Beschreibung
        Version             = Version
        AvailableUpdates    = Verfügbare Updates
        NoUpdateAvailable   = Kein Update verfügbar
        DownloadError       = Downloadfehler
        UpdateAvailable     = Update verfügbar
        ErrorMessage        = Abschnitt VxRail-Clusterkomponenten: {0}
'@

    GetAbrVxRailClusterNetwork = ConvertFrom-StringData @'
        Collecting              = Informationen zum VxRail-Clusternetzwerk werden erfasst.
        ApiCallProxy            = API-Referenzaufruf an den Pfad /system/proxy wird ausgeführt.
        ApiCallInternetMode     = API-Referenzaufruf an den Pfad /system/internet-mode wird ausgeführt.
        ApiCallNetworkPools     = API-Referenzaufruf an den Pfad /cluster/network/pools wird ausgeführt.
        Heading                 = VxRail-Netzwerk
        Paragraph               = Der folgende Abschnitt beschreibt die allgemeinen Netzwerkeinstellungen von VxRail Manager für {0}.
        GeneralHeading          = Allgemein
        InternetConnectionStatus = Internetverbindungsstatus
        ProxyStatus             = Proxystatus
        Enabled                 = Aktiviert
        Disabled                = Deaktiviert
        GeneralTableName        = Allgemeine Netzwerkspezifikationen - {0}
        ProxyServerHeading      = Proxyserver
        Protocol                = Protokoll
        IPAddress               = IP-Adresse
        Port                    = Port
        ProxyServerTableName    = Proxyserver-Spezifikationen - {0}
        NetworkPoolsHeading     = Netzwerkpools
        NetworkPool             = Netzwerkpool
        SubnetMask              = Subnetzmaske
        Gateway                 = Gateway
        Total                   = Gesamt
        Used                    = Verwendet
        Available               = Verfügbar
        VlanId                  = VLAN-ID
        ManagementHeading       = Verwaltung
        ManagementTableName     = Verwaltungsnetzwerkpool-Spezifikationen - {0}
        VmotionHeading          = vMotion
        VmotionTableName        = vMotion-Netzwerkpool-Spezifikationen - {0}
        VsanHeading             = vSAN
        VsanTableName           = vSAN-Netzwerkpool-Spezifikationen - {0}
        ErrorMessage            = Abschnitt VxRail-Clusternetzwerk: {0}
'@

    GetAbrVxRailClusterSupport = ConvertFrom-StringData @'
        Collecting             = Supportinformationen des VxRail-Clusters werden erfasst.
        ApiCallCallHomeMode    = API-Referenzaufruf an den Pfad /callhome/mode wird ausgeführt.
        ApiCallCallHomeInfo    = API-Referenzaufruf an den Pfad /callhome/info wird ausgeführt.
        ApiCallSupportAccount  = API-Referenzaufruf an den Pfad /support/account wird ausgeführt.
        ApiCallSupportContact  = API-Referenzaufruf an den Pfad /support/contact wird ausgeführt.
        Heading                = Support
        Paragraph              = Der folgende Abschnitt beschreibt die Supporteinstellungen von VxRail Manager für {0}.
        SupportAccountHeading  = Dell EMC Support-Konto
        SupportAccount         = Support-Konto
        SupportAccountTableName = Dell EMC Support-Konto - {0}
        SrsHeading             = Dell EMC Secure Remote Service (SRS)
        SrsStatus              = SRS-Status
        NotConfigured          = Nicht konfiguriert
        SrsType                = SRS-Typ
        InternalEsrs           = Internes ESRS
        ExternalEsrs           = Externes ESRS
        SrsConnection          = SRS-Verbindung
        Enabled                = Aktiviert
        Disabled               = Deaktiviert
        SrsVmIPAddress         = IP-Adresse der SRS-VM
        SiteID                 = Standort-ID
        SrsTableName           = Dell EMC Secure Remote Service - {0}
        SupportContactHeading  = Support-Kontakt
        Company                = Unternehmen
        Email                  = E-Mail
        FirstName              = Vorname
        LastName               = Nachname
        PhoneNumber            = Telefonnummer
        NotAvailable           = --
        SupportContactTableName = Support-Kontaktinformationen - {0}
        ErrorMessage           = Abschnitt VxRail-Cluster-Support: {0}
'@

    GetAbrVxRailClusterCertificate = ConvertFrom-StringData @'
        Collecting          = VxRail-Zertifikatinformationen werden erfasst.
        ApiCall             = API-Referenzaufruf an den Pfad /trust-store/certificates wird ausgeführt.
        Heading             = Zertifikate
        Paragraph           = Der folgende Abschnitt beschreibt die im Trust Store von VxRail Manager {0} konfigurierten Zertifikate.
        Name                = Name
        Status              = Status
        IssuedBy            = Ausgestellt von
        ExpirationDate      = Ablaufdatum
        SignatureAlgorithm  = Signaturalgorithmus
        Fingerprint         = Fingerabdruck
        TableName           = Zertifikate - {0}
        ErrorMessage        = Abschnitt VxRail-Clusterzertifikate: {0}
'@

    GetAbrVxRailClusterPrecheck = ConvertFrom-StringData @'
        Collecting            = VxRail-Precheck-Informationen werden erfasst.
        ApiCall               = API-Referenzaufruf an den Pfad /system/prechecks/results wird ausgeführt.
        Heading               = Precheck-Ergebnisse
        Paragraph             = Der folgende Abschnitt beschreibt die auf VxRail Manager {0} erfassten Ergebnisse der Systemvorprüfung (Health Check).
        Profile               = Profil
        Status                = Status
        TotalSeverity         = Gesamtschweregrad
        ChecksPassed          = Bestandene Prüfungen
        ChecksWarning         = Prüfungen mit Warnung
        ChecksError           = Prüfungen mit Fehler
        TotalChecks           = Prüfungen gesamt
        TableName             = Precheck-Ergebnisse - {0}
        OutstandingHeading    = Ausstehende Prüfungen
        OutstandingTableName  = Ausstehende Precheck-Prüfungen - {0}
        Source                = Quelle
        Check                 = Prüfung
        MessageSeverity       = Schweregrad
        Symptom               = Symptom
        Action                = Maßnahme
        GeneralCheckSource    = Cluster
        ErrorMessage          = Abschnitt VxRail-Cluster-Precheck: {0}
'@

    GetAbrVxRailHostHardware = ConvertFrom-StringData @'
        Collecting       = Hardwareinformationen für {0} werden erfasst.
        Heading          = Hardware
        TableName        = Hardwarespezifikationen - {0}
        Hostname         = Hostname
        Manufacturer     = Hersteller
        Model            = Modell
        SerialNumber     = Seriennummer
        ApplianceID      = Appliance-ID
        Slot             = Steckplatz
        PowerStatus      = Energiestatus
        Connected        = Verbunden
        Yes              = Ja
        No               = Nein
        TpmPresent       = TPM vorhanden
        HealthStatus     = Systemzustand
        OperationStatus  = Betriebsstatus
        Available        = Verfügbar
        PoweringOff      = Wird ausgeschaltet
        ErrorMessage     = Abschnitt VxRail-Host-Hardware: {0}
'@

    GetAbrVxRailHostEsxi = ConvertFrom-StringData @'
        Collecting        = ESXi-Informationen für {0} werden erfasst.
        Heading           = ESXi
        TableName         = ESXi-Spezifikationen - {0}
        ManagementIP      = Management-IP-Adresse
        VmotionIP         = vMotion-IP-Adresse
        VsanIP            = vSAN-IP-Adresse
        ErrorMessage      = Abschnitt VxRail-Host-ESXi: {0}
'@

    GetAbrVxRailHostFirmware = ConvertFrom-StringData @'
        Collecting              = Firmwareinformationen für {0} werden erfasst.
        Heading                 = Firmware
        TableName               = Firmwareversionen - {0}
        Bios                    = BIOS
        Bmc                     = BMC
        CpldFirmware            = CPLD-Firmware
        Hba                     = HBA
        ExpanderBackPlane       = Backplane mit Expander
        NonExpanderBackPlane    = Backplane ohne Expander
        Boss                    = BOSS
        IdsdmFirmware           = IDSDM-Firmware
        DcpmFirmware            = DCPM-Firmware
        PercFirmware            = PERC-Firmware
        ErrorMessage            = Abschnitt VxRail-Host-Firmware: {0}
'@

    GetAbrVxRailHostComponent = ConvertFrom-StringData @'
        Collecting     = Komponenteninformationen für {0} werden erfasst.
        Heading        = Komponenten
        TableName      = Komponentenversionen - {0}
        VMwareEsxi     = VMware ESXi
        VxRailVib      = VxRail-VIB
        DellPtAgent    = Dell PtAgent
        HbaDriver      = HBA-Treiber
        ErrorMessage   = Abschnitt VxRail-Host-Komponenten: {0}
'@

    GetAbrVxRailHostBootDevice = ConvertFrom-StringData @'
        Collecting     = Bootgeräteinformationen für {0} werden erfasst.
        Heading        = Bootgeräte
        DeviceHeading  = Bootgerät {0}
        BootDevice     = Bootgerät
        DeviceType     = Gerätetyp
        SerialNumber   = Seriennummer
        Model          = Modell
        SataType       = SATA-Typ
        Capacity       = Kapazität
        Health         = Zustand
        Firmware       = Firmware
        DeviceTableName = Spezifikationen Bootgerät {0} - {1}
        TableName      = Bootgerätespezifikationen - {0}
        ErrorMessage   = Abschnitt VxRail-Host-Bootgerät: {0}
'@

    GetAbrVxRailHostDisk = ConvertFrom-StringData @'
        Collecting      = Festplatteninformationen für {0} werden erfasst.
        Heading         = Festplatten
        DeviceHeading   = Gehäuse {0} Festplatte {1}
        Enclosure       = Gehäuse
        Slot            = Steckplatz
        SerialNumber    = Seriennummer
        Manufacturer    = Hersteller
        Model           = Modell
        Firmware        = Firmware
        DiskType        = Festplattentyp
        Capacity        = Kapazität
        Speed           = Geschwindigkeit
        Status          = Status
        DeviceTableName = Spezifikationen Gehäuse {0} Festplatte {1} - {2}
        TableName       = Festplattenspezifikationen - {0}
        HeaderEncl      = Geh.
        HeaderType      = Typ
        ErrorMessage    = Abschnitt VxRail-Host-Festplatten: {0}
'@

    GetAbrVxRailHostNic = ConvertFrom-StringData @'
        Collecting    = NIC-Informationen für {0} werden erfasst.
        Heading       = NICs
        TableName     = NIC-Spezifikationen - {0}
        Nic           = NIC
        MacAddress    = MAC-Adresse
        LinkSpeed     = Verbindungsgeschwindigkeit
        LinkStatus    = Verbindungsstatus
        Firmware      = Firmware
        ErrorMessage  = Abschnitt VxRail-Host-NIC: {0}
'@

    GetAbrVxRailHostPsu = ConvertFrom-StringData @'
        Collecting    = Netzteilinformationen für {0} werden erfasst.
        Heading       = Netzteile
        TableName     = Netzteilspezifikationen - {0}
        Psu           = Netzteil
        Manufacturer  = Hersteller
        SerialNumber  = Seriennummer
        PartNumber    = Teilenummer
        Health        = Zustand
        Revision      = Revision
        ErrorMessage  = Abschnitt VxRail-Host-Netzteil: {0}
'@

    GetAbrVxRailHostIdracIPv4 = ConvertFrom-StringData @'
        Collecting    = iDRAC-Informationen für {0} werden erfasst.
        Heading       = IPv4-Einstellungen
        TableName     = iDRAC IPv4-Spezifikationen - {0}
        Dhcp          = DHCP
        Enabled       = Aktiviert
        Disabled      = Deaktiviert
        IPv4Address   = IPv4-Adresse
        SubnetMask    = Subnetzmaske
        Gateway       = Gateway
        ErrorMessage  = Abschnitt VxRail-Host-iDRAC-IPv4: {0}
'@

    GetAbrVxRailHostIdracVlan = ConvertFrom-StringData @'
        Collecting     = iDRAC-VLAN-Informationen für {0} werden erfasst.
        Heading        = VLAN-Einstellungen
        TableName      = iDRAC VLAN-Spezifikationen - {0}
        Vlan           = VLAN
        Enabled        = Aktiviert
        Disabled       = Deaktiviert
        VlanId         = VLAN-ID
        VlanPriority   = VLAN-Priorität
        ErrorMessage   = Abschnitt VxRail-Host-iDRAC-VLAN: {0}
'@

    GetAbrVxRailHostIdracUser = ConvertFrom-StringData @'
        Collecting      = iDRAC-Benutzerinformationen für {0} werden erfasst.
        Heading         = Benutzer
        TableName       = iDRAC-Benutzerspezifikationen - {0}
        ID              = ID
        UserName        = Benutzername
        Privilege       = Berechtigung
        Administrator   = Administrator
        ErrorMessage    = Abschnitt VxRail-Host-iDRAC-Benutzer: {0}
'@
}
