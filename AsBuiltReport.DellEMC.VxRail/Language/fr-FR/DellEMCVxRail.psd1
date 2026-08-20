# culture = 'fr-FR'
@{
    InvokeAsBuiltReportDellEMCVxRail = ConvertFrom-StringData @'
        Connecting              = Connexion au serveur vCenter '{0}'.
        CollectingVxRailInfo    = Collecte des informations de VxRail Manager.
        ClusterNotFound         = Impossible de trouver le cluster VxRail '{0}'.
        ConnectingVxRailMgr     = Connexion à VxRail Manager {0}.
        ApiCallHosts            = Exécution de l'appel de référence API vers le chemin /hosts.
        ApiCallChassis          = Exécution de l'appel de référence API vers le chemin /chassis.
        ApiCallClusterHosts     = Exécution de l'appel de référence API vers le chemin /system/cluster-hosts.
        SectionParagraph        = Les sections suivantes détaillent la configuration du cluster VxRail géré par VxRail Manager {0}.
        ClusterInfoLevel        = InfoLevel du cluster défini sur {0}.
        ClusterHeading          = Cluster VxRail
        ClusterParagraph        = La section suivante fournit un résumé de la configuration du cluster VxRail, des hôtes ESXi et des machines virtuelles.
        ApplianceInfoLevel      = InfoLevel des appliances défini sur {0}.
        ApplianceHeading        = Appliances VxRail
        ApplianceParagraph      = Les sections suivantes détaillent la configuration des appliances VxRail gérées par VxRail Manager {0}.
        ApplianceHostParagraph  = La section suivante détaille la configuration matérielle de l'appliance VxRail {0}.
        IdracHeading            = iDRAC
        SupportInfoLevel        = InfoLevel du support défini sur {0}.
        CertificateInfoLevel    = InfoLevel des certificats défini sur {0}.
        PrecheckInfoLevel       = InfoLevel des prévérifications défini sur {0}.
        NetworkInfoLevel        = InfoLevel du réseau défini sur {0}.
        ConnectionError         = Impossible de se connecter au serveur vCenter '{0}'.
'@

    GetAbrVxRailCluster = ConvertFrom-StringData @'
        Collecting               = Collecte des informations du cluster VxRail.
        ApiCallSystem             = Exécution de l'appel de référence API vers le chemin /system.
        ApiCallVcMode             = Exécution de l'appel de référence API vers le chemin /vc/mode.
        ApiCallTelemetryTier      = Exécution de l'appel de référence API vers le chemin /telemetry/tier.
        TableName                 = Spécifications du cluster VxRail - {0}
        VxRailManager             = VxRail Manager
        VxRailManagerIP           = IP de VxRail Manager
        VxRailVersion             = Version de VxRail
        VxRailClusterName         = Nom du cluster VxRail
        VxRailClusterType         = Type de cluster VxRail
        NumberOfHosts             = Nombre d'hôtes
        HealthStatus              = État de santé
        VCenterServer             = Serveur vCenter
        VCenterVersion            = Version de vCenter
        VCenterServerMode         = Mode du serveur vCenter
        PscMode                   = Mode PSC
        VCenterServerConnected    = Serveur vCenter connecté
        ExternalVCenterServer     = Serveur vCenter externe
        TelemetryTier             = Niveau de télémétrie
        InstallationDate          = Date d'installation
        Yes                       = Oui
        No                        = Non
        NotAvailable              = --
        ErrorMessage              = Section Cluster VxRail : {0}
'@

    GetAbrVxRailAvailableHost = ConvertFrom-StringData @'
        Collecting      = Collecte des informations sur les hôtes ESXi disponibles VxRail.
        ApiCall         = Exécution de l'appel de référence API vers le chemin /system/available-hosts.
        Heading         = Hôtes ESXi disponibles
        TableName       = Spécifications des hôtes ESXi disponibles - {0}
        ServiceTag      = Numéro de service
        ApplianceID     = ID de l'appliance
        Model           = Modèle
        DiscoveredDate  = Date de découverte
        ErrorMessage    = Section Hôtes ESXi disponibles : {0}
'@

    GetAbrVxRailClusterHost = ConvertFrom-StringData @'
        Collecting     = Collecte des informations sur les hôtes du cluster VxRail.
        ApiCall        = Exécution de l'appel de référence API vers le chemin /system/cluster-hosts.
        Heading        = Hôtes ESXi
        TableName      = Spécifications des hôtes ESXi - {0}
        Hostname       = Nom d'hôte
        ManagementIP   = IP de gestion de l'hôte ESXi
        ServiceTag     = Numéro de service
        ApplianceID    = ID de l'appliance
        Model          = Modèle
        ErrorMessage   = Section Hôtes du cluster VxRail : {0}
'@

    GetAbrVxRailClusterVMs = ConvertFrom-StringData @'
        Collecting    = Collecte des informations sur les machines virtuelles du cluster VxRail.
        ApiCall       = Exécution de l'appel de référence API vers le chemin /cluster/system-virtual-machines.
        Heading       = Machines Virtuelles
        TableName     = Machines Virtuelles - {0}
        VirtualMachine = Machine Virtuelle
        EsxiHost      = Hôte ESXi
        Status        = État
        ErrorMessage  = Section Machines Virtuelles du cluster VxRail : {0}
'@

    GetAbrVxRailClusterComponents = ConvertFrom-StringData @'
        Collecting          = Collecte des informations sur les composants du cluster VxRail.
        ApiCall             = Exécution de l'appel de référence API vers le chemin /system.
        Heading             = Composants Installés
        TableName           = Composants Installés - {0}
        Name                = Nom
        Description         = Description
        Version             = Version
        AvailableUpdates    = Mises à Jour Disponibles
        NoUpdateAvailable   = Aucune Mise à Jour Disponible
        DownloadError       = Erreur de Téléchargement
        UpdateAvailable     = Mise à Jour Disponible
        ErrorMessage        = Section Composants du cluster VxRail : {0}
'@

    GetAbrVxRailClusterNetwork = ConvertFrom-StringData @'
        Collecting              = Collecte des informations réseau du cluster VxRail.
        ApiCallProxy            = Exécution de l'appel de référence API vers le chemin /system/proxy.
        ApiCallInternetMode     = Exécution de l'appel de référence API vers le chemin /system/internet-mode.
        ApiCallNetworkPools     = Exécution de l'appel de référence API vers le chemin /cluster/network/pools.
        Heading                 = Réseau VxRail
        Paragraph               = La section suivante détaille les paramètres réseau généraux de VxRail Manager pour {0}.
        GeneralHeading          = Général
        InternetConnectionStatus = État de la Connexion Internet
        ProxyStatus             = État du Proxy
        Enabled                 = Activé
        Disabled                = Désactivé
        GeneralTableName        = Spécifications Réseau Générales - {0}
        ProxyServerHeading      = Serveur Proxy
        Protocol                = Protocole
        IPAddress               = Adresse IP
        Port                    = Port
        ProxyServerTableName    = Spécifications du Serveur Proxy - {0}
        NetworkPoolsHeading     = Pools Réseau
        NetworkPool             = Pool Réseau
        SubnetMask              = Masque de Sous-Réseau
        Gateway                 = Passerelle
        Total                   = Total
        Used                    = Utilisé
        Available               = Disponible
        VlanId                  = ID VLAN
        ManagementHeading       = Gestion
        ManagementTableName     = Spécifications du Pool Réseau de Gestion - {0}
        VmotionHeading          = vMotion
        VmotionTableName        = Spécifications du Pool Réseau vMotion - {0}
        VsanHeading             = vSAN
        VsanTableName           = Spécifications du Pool Réseau vSAN - {0}
        ErrorMessage            = Section Réseau du cluster VxRail : {0}
'@

    GetAbrVxRailClusterSupport = ConvertFrom-StringData @'
        Collecting             = Collecte des informations de support du cluster VxRail.
        ApiCallCallHomeMode    = Exécution de l'appel de référence API vers le chemin /callhome/mode.
        ApiCallCallHomeInfo    = Exécution de l'appel de référence API vers le chemin /callhome/info.
        ApiCallSupportAccount  = Exécution de l'appel de référence API vers le chemin /support/account.
        ApiCallSupportContact  = Exécution de l'appel de référence API vers le chemin /support/contact.
        Heading                = Support
        Paragraph              = La section suivante détaille les paramètres de support de VxRail Manager pour {0}.
        SupportAccountHeading  = Compte de Support Dell EMC
        SupportAccount         = Compte de Support
        SupportAccountTableName = Compte de Support Dell EMC - {0}
        SrsHeading             = Dell EMC Secure Remote Service (SRS)
        SrsStatus              = État SRS
        NotConfigured          = Non Configuré
        SrsType                = Type de SRS
        InternalEsrs           = ESRS Interne
        ExternalEsrs           = ESRS Externe
        SrsConnection          = Connexion SRS
        Enabled                = Activé
        Disabled               = Désactivé
        SrsVmIPAddress         = Adresse IP de la VM SRS
        SiteID                 = ID du Site
        SrsTableName           = Dell EMC Secure Remote Service - {0}
        SupportContactHeading  = Contact de Support
        Company                = Société
        Email                  = E-mail
        FirstName              = Prénom
        LastName               = Nom
        PhoneNumber            = Numéro de Téléphone
        NotAvailable           = --
        SupportContactTableName = Informations de Contact du Support - {0}
        ErrorMessage           = Section Support du cluster VxRail : {0}
'@

    GetAbrVxRailClusterCertificate = ConvertFrom-StringData @'
        Collecting          = Collecte des informations sur les certificats VxRail.
        ApiCall             = Exécution de l'appel de référence API vers le chemin /trust-store/certificates.
        Heading             = Certificats
        Paragraph           = La section suivante détaille les certificats du magasin de confiance configurés sur VxRail Manager {0}.
        Name                = Nom
        Status              = État
        IssuedBy            = Émis Par
        ExpirationDate      = Date d'Expiration
        SignatureAlgorithm  = Algorithme de Signature
        Fingerprint         = Empreinte
        TableName           = Certificats - {0}
        ErrorMessage        = Section Certificats du cluster VxRail : {0}
'@

    GetAbrVxRailClusterPrecheck = ConvertFrom-StringData @'
        Collecting            = Collecte des informations de prévérification VxRail.
        ApiCall               = Exécution de l'appel de référence API vers le chemin /system/prechecks/results.
        Heading               = Résultats des Prévérifications
        Paragraph             = La section suivante détaille les résultats des prévérifications système (health check) enregistrés sur VxRail Manager {0}.
        Profile               = Profil
        Status                = État
        TotalSeverity         = Gravité Totale
        ChecksPassed          = Vérifications Réussies
        ChecksWarning         = Vérifications avec Avertissement
        ChecksError           = Vérifications en Erreur
        TotalChecks           = Total des Vérifications
        TableName             = Résultats des Prévérifications - {0}
        OutstandingHeading    = Vérifications en Attente
        OutstandingTableName  = Vérifications de Prévérification en Attente - {0}
        Source                = Source
        Check                 = Vérification
        MessageSeverity       = Gravité
        Symptom               = Symptôme
        Action                = Action
        GeneralCheckSource    = Cluster
        ErrorMessage          = Section Prévérification du cluster VxRail : {0}
'@

    GetAbrVxRailHostHardware = ConvertFrom-StringData @'
        Collecting       = Collecte des informations matérielles de {0}.
        Heading          = Matériel
        TableName        = Spécifications Matérielles - {0}
        Hostname         = Nom d'Hôte
        Manufacturer     = Fabricant
        Model            = Modèle
        SerialNumber     = Numéro de Série
        ApplianceID      = ID de l'Appliance
        Slot             = Emplacement
        PowerStatus      = État d'Alimentation
        Connected        = Connecté
        Yes              = Oui
        No               = Non
        TpmPresent       = TPM Présent
        HealthStatus     = État de Santé
        OperationStatus  = État de Fonctionnement
        Available        = Disponible
        PoweringOff      = Mise Hors Tension en Cours
        ErrorMessage     = Section Matériel de l'Hôte VxRail : {0}
'@

    GetAbrVxRailHostEsxi = ConvertFrom-StringData @'
        Collecting        = Collecte des informations ESXi de {0}.
        Heading           = ESXi
        TableName         = Spécifications ESXi - {0}
        ManagementIP      = Adresse IP de Gestion
        VmotionIP         = Adresse IP vMotion
        VsanIP            = Adresse IP vSAN
        ErrorMessage      = Section ESXi de l'Hôte VxRail : {0}
'@

    GetAbrVxRailHostFirmware = ConvertFrom-StringData @'
        Collecting              = Collecte des informations de firmware de {0}.
        Heading                 = Firmware
        TableName               = Versions de Firmware - {0}
        Bios                    = BIOS
        Bmc                     = BMC
        CpldFirmware            = Firmware CPLD
        Hba                     = HBA
        ExpanderBackPlane       = Backplane avec Expandeur
        NonExpanderBackPlane    = Backplane sans Expandeur
        Boss                    = BOSS
        IdsdmFirmware           = Firmware IDSDM
        DcpmFirmware            = Firmware DCPM
        PercFirmware            = Firmware PERC
        ErrorMessage            = Section Firmware de l'Hôte VxRail : {0}
'@

    GetAbrVxRailHostComponent = ConvertFrom-StringData @'
        Collecting     = Collecte des informations sur les composants de {0}.
        Heading        = Composants
        TableName      = Versions des Composants - {0}
        VMwareEsxi     = VMware ESXi
        VxRailVib      = VIB VxRail
        DellPtAgent    = Dell PtAgent
        HbaDriver      = Pilote HBA
        ErrorMessage   = Section Composants de l'Hôte VxRail : {0}
'@

    GetAbrVxRailHostBootDevice = ConvertFrom-StringData @'
        Collecting     = Collecte des informations sur les périphériques de démarrage de {0}.
        Heading        = Périphériques de Démarrage
        DeviceHeading  = Périphérique de Démarrage {0}
        BootDevice     = Périphérique de Démarrage
        DeviceType     = Type de Périphérique
        SerialNumber   = Numéro de Série
        Model          = Modèle
        SataType       = Type SATA
        Capacity       = Capacité
        Health         = État de Santé
        Firmware       = Firmware
        DeviceTableName = Spécifications du Périphérique de Démarrage {0} - {1}
        TableName      = Spécifications des Périphériques de Démarrage - {0}
        ErrorMessage   = Section Périphérique de Démarrage de l'Hôte VxRail : {0}
'@

    GetAbrVxRailHostDisk = ConvertFrom-StringData @'
        Collecting      = Collecte des informations sur les disques de {0}.
        Heading         = Disques
        DeviceHeading   = Enceinte {0} Disque {1}
        Enclosure       = Enceinte
        Slot            = Emplacement
        SerialNumber    = Numéro de Série
        Manufacturer    = Fabricant
        Model           = Modèle
        Firmware        = Firmware
        DiskType        = Type de Disque
        Capacity        = Capacité
        Speed           = Vitesse
        Status          = État
        DeviceTableName = Spécifications de l'Enceinte {0} Disque {1} - {2}
        TableName       = Spécifications des Disques - {0}
        HeaderEncl      = Enc.
        HeaderType      = Type
        ErrorMessage    = Section Disques de l'Hôte VxRail : {0}
'@

    GetAbrVxRailHostNic = ConvertFrom-StringData @'
        Collecting    = Collecte des informations NIC de {0}.
        Heading       = Cartes Réseau
        TableName     = Spécifications des Cartes Réseau - {0}
        Nic           = Carte Réseau
        MacAddress    = Adresse MAC
        LinkSpeed     = Vitesse de Liaison
        LinkStatus    = État de la Liaison
        Firmware      = Firmware
        ErrorMessage  = Section Cartes Réseau de l'Hôte VxRail : {0}
'@

    GetAbrVxRailHostPsu = ConvertFrom-StringData @'
        Collecting    = Collecte des informations d'alimentation de {0}.
        Heading       = Blocs d'Alimentation
        TableName     = Spécifications des Blocs d'Alimentation - {0}
        Psu           = Bloc d'Alimentation
        Manufacturer  = Fabricant
        SerialNumber  = Numéro de Série
        PartNumber    = Référence
        Health        = État de Santé
        Revision      = Révision
        ErrorMessage  = Section Bloc d'Alimentation de l'Hôte VxRail : {0}
'@

    GetAbrVxRailHostIdracIPv4 = ConvertFrom-StringData @'
        Collecting    = Collecte des informations iDRAC de {0}.
        Heading       = Paramètres IPv4
        TableName     = Spécifications IPv4 iDRAC - {0}
        Dhcp          = DHCP
        Enabled       = Activé
        Disabled      = Désactivé
        IPv4Address   = Adresse IPv4
        SubnetMask    = Masque de Sous-Réseau
        Gateway       = Passerelle
        ErrorMessage  = Section IPv4 iDRAC de l'Hôte VxRail : {0}
'@

    GetAbrVxRailHostIdracVlan = ConvertFrom-StringData @'
        Collecting     = Collecte des informations VLAN iDRAC de {0}.
        Heading        = Paramètres VLAN
        TableName      = Spécifications VLAN iDRAC - {0}
        Vlan           = VLAN
        Enabled        = Activé
        Disabled       = Désactivé
        VlanId         = ID VLAN
        VlanPriority   = Priorité VLAN
        ErrorMessage   = Section VLAN iDRAC de l'Hôte VxRail : {0}
'@

    GetAbrVxRailHostIdracUser = ConvertFrom-StringData @'
        Collecting      = Collecte des informations utilisateurs iDRAC de {0}.
        Heading         = Utilisateurs
        TableName       = Spécifications des Utilisateurs iDRAC - {0}
        ID              = ID
        UserName        = Nom d'Utilisateur
        Privilege       = Privilège
        Administrator   = Administrateur
        ErrorMessage    = Section Utilisateurs iDRAC de l'Hôte VxRail : {0}
'@
}
