# culture = 'es-ES'
@{
    InvokeAsBuiltReportDellEMCVxRail = ConvertFrom-StringData @'
        Connecting              = Conectando al servidor vCenter '{0}'.
        CollectingVxRailInfo    = Recopilando información de VxRail Manager.
        ClusterNotFound         = No se ha encontrado el clúster VxRail '{0}'.
        ConnectingVxRailMgr     = Conectando a VxRail Manager {0}.
        ApiCallHosts            = Realizando llamada de referencia a la API en la ruta /hosts.
        ApiCallChassis          = Realizando llamada de referencia a la API en la ruta /chassis.
        ApiCallClusterHosts     = Realizando llamada de referencia a la API en la ruta /system/cluster-hosts.
        SectionParagraph        = Las siguientes secciones detallan la configuración del clúster VxRail gestionado por VxRail Manager {0}.
        ClusterInfoLevel        = InfoLevel de clúster establecido en {0}.
        ClusterHeading          = Clúster VxRail
        ClusterParagraph        = La siguiente sección proporciona un resumen de la configuración del clúster VxRail, los hosts ESXi y las máquinas virtuales.
        ApplianceInfoLevel      = InfoLevel de appliance establecido en {0}.
        ApplianceHeading        = Appliances VxRail
        ApplianceParagraph      = Las siguientes secciones detallan la configuración de los appliances VxRail gestionados por VxRail Manager {0}.
        ApplianceHostParagraph  = La siguiente sección detalla la configuración de hardware del appliance VxRail {0}.
        IdracHeading            = iDRAC
        SupportInfoLevel        = InfoLevel de support establecido en {0}.
        CertificateInfoLevel    = InfoLevel de certificate establecido en {0}.
        PrecheckInfoLevel       = InfoLevel de precheck establecido en {0}.
        NetworkInfoLevel        = InfoLevel de network establecido en {0}.
        ConnectionError         = No se ha podido conectar al servidor vCenter '{0}'.
'@

    GetAbrVxRailCluster = ConvertFrom-StringData @'
        Collecting               = Recopilando información del clúster VxRail.
        ApiCallSystem             = Realizando llamada de referencia a la API en la ruta /system.
        ApiCallVcMode             = Realizando llamada de referencia a la API en la ruta /vc/mode.
        ApiCallTelemetryTier      = Realizando llamada de referencia a la API en la ruta /telemetry/tier.
        TableName                 = Especificaciones del clúster VxRail - {0}
        VxRailManager             = VxRail Manager
        VxRailManagerIP           = IP de VxRail Manager
        VxRailVersion             = Versión de VxRail
        VxRailClusterName         = Nombre del clúster VxRail
        VxRailClusterType         = Tipo de clúster VxRail
        NumberOfHosts             = Número de hosts
        HealthStatus              = Estado de salud
        VCenterServer             = Servidor vCenter
        VCenterVersion            = Versión de vCenter
        VCenterServerMode         = Modo del servidor vCenter
        PscMode                   = Modo PSC
        VCenterServerConnected    = Servidor vCenter conectado
        ExternalVCenterServer     = Servidor vCenter externo
        TelemetryTier             = Nivel de telemetría
        InstallationDate          = Fecha de instalación
        Yes                       = Sí
        No                        = No
        NotAvailable              = --
        ErrorMessage              = Sección Clúster VxRail: {0}
'@

    GetAbrVxRailAvailableHost = ConvertFrom-StringData @'
        Collecting      = Recopilando información de hosts ESXi disponibles de VxRail.
        ApiCall         = Realizando llamada de referencia a la API en la ruta /system/available-hosts.
        Heading         = Hosts ESXi disponibles
        TableName       = Especificaciones de hosts ESXi disponibles - {0}
        ServiceTag      = Etiqueta de servicio
        ApplianceID     = ID de appliance
        Model           = Modelo
        DiscoveredDate  = Fecha de descubrimiento
        ErrorMessage    = Sección Hosts ESXi disponibles: {0}
'@

    GetAbrVxRailClusterHost = ConvertFrom-StringData @'
        Collecting     = Recopilando información de hosts del clúster VxRail.
        ApiCall        = Realizando llamada de referencia a la API en la ruta /system/cluster-hosts.
        Heading        = Hosts ESXi
        TableName      = Especificaciones de hosts ESXi - {0}
        Hostname       = Nombre de host
        ManagementIP   = IP de gestión del host ESXi
        ServiceTag     = Etiqueta de servicio
        ApplianceID    = ID de appliance
        Model          = Modelo
        ErrorMessage   = Sección Hosts del clúster VxRail: {0}
'@

    GetAbrVxRailClusterVMs = ConvertFrom-StringData @'
        Collecting    = Recopilando información de máquinas virtuales del clúster VxRail.
        ApiCall       = Realizando llamada de referencia a la API en la ruta /cluster/system-virtual-machines.
        Heading       = Máquinas Virtuales
        TableName     = Máquinas Virtuales - {0}
        VirtualMachine = Máquina Virtual
        EsxiHost      = Host ESXi
        Status        = Estado
        ErrorMessage  = Sección Máquinas Virtuales del clúster VxRail: {0}
'@

    GetAbrVxRailClusterComponents = ConvertFrom-StringData @'
        Collecting          = Recopilando información de componentes del clúster VxRail.
        ApiCall             = Realizando llamada de referencia a la API en la ruta /system.
        Heading             = Componentes Instalados
        TableName           = Componentes Instalados - {0}
        Name                = Nombre
        Description         = Descripción
        Version             = Versión
        AvailableUpdates    = Actualizaciones Disponibles
        NoUpdateAvailable   = Sin Actualizaciones Disponibles
        DownloadError       = Error de Descarga
        UpdateAvailable     = Actualización Disponible
        ErrorMessage        = Sección Componentes del clúster VxRail: {0}
'@

    GetAbrVxRailClusterNetwork = ConvertFrom-StringData @'
        Collecting              = Recopilando información de red del clúster VxRail.
        ApiCallProxy            = Realizando llamada de referencia a la API en la ruta /system/proxy.
        ApiCallInternetMode     = Realizando llamada de referencia a la API en la ruta /system/internet-mode.
        ApiCallNetworkPools     = Realizando llamada de referencia a la API en la ruta /cluster/network/pools.
        Heading                 = Red VxRail
        Paragraph               = La siguiente sección detalla la configuración general de red de VxRail Manager para {0}.
        GeneralHeading          = General
        InternetConnectionStatus = Estado de la Conexión a Internet
        ProxyStatus             = Estado del Proxy
        Enabled                 = Habilitado
        Disabled                = Deshabilitado
        GeneralTableName        = Especificaciones Generales de Red - {0}
        ProxyServerHeading      = Servidor Proxy
        Protocol                = Protocolo
        IPAddress               = Dirección IP
        Port                    = Puerto
        ProxyServerTableName    = Especificaciones del Servidor Proxy - {0}
        NetworkPoolsHeading     = Pools de Red
        NetworkPool             = Pool de Red
        SubnetMask              = Máscara de Subred
        Gateway                 = Puerta de Enlace
        Total                   = Total
        Used                    = Usado
        Available               = Disponible
        VlanId                  = ID de VLAN
        ManagementHeading       = Gestión
        ManagementTableName     = Especificaciones del Pool de Red de Gestión - {0}
        VmotionHeading          = vMotion
        VmotionTableName        = Especificaciones del Pool de Red vMotion - {0}
        VsanHeading             = vSAN
        VsanTableName           = Especificaciones del Pool de Red vSAN - {0}
        ErrorMessage            = Sección Red del clúster VxRail: {0}
'@

    GetAbrVxRailClusterSupport = ConvertFrom-StringData @'
        Collecting             = Recopilando información de soporte del clúster VxRail.
        ApiCallCallHomeMode    = Realizando llamada de referencia a la API en la ruta /callhome/mode.
        ApiCallCallHomeInfo    = Realizando llamada de referencia a la API en la ruta /callhome/info.
        ApiCallSupportAccount  = Realizando llamada de referencia a la API en la ruta /support/account.
        ApiCallSupportContact  = Realizando llamada de referencia a la API en la ruta /support/contact.
        Heading                = Soporte
        Paragraph              = La siguiente sección detalla la configuración de soporte de VxRail Manager para {0}.
        SupportAccountHeading  = Cuenta de Soporte de Dell EMC
        SupportAccount         = Cuenta de Soporte
        SupportAccountTableName = Cuenta de Soporte de Dell EMC - {0}
        SrsHeading             = Dell EMC Secure Remote Service (SRS)
        SrsStatus              = Estado de SRS
        NotConfigured          = No Configurado
        SrsType                = Tipo de SRS
        InternalEsrs           = ESRS Interno
        ExternalEsrs           = ESRS Externo
        SrsConnection          = Conexión SRS
        Enabled                = Habilitado
        Disabled               = Deshabilitado
        SrsVmIPAddress         = Dirección IP de la VM de SRS
        SiteID                 = ID de Sitio
        SrsTableName           = Dell EMC Secure Remote Service - {0}
        SupportContactHeading  = Contacto de Soporte
        Company                = Empresa
        Email                  = Correo Electrónico
        FirstName              = Nombre
        LastName               = Apellido
        PhoneNumber            = Número de Teléfono
        NotAvailable           = --
        SupportContactTableName = Información de Contacto de Soporte - {0}
        ErrorMessage           = Sección Soporte del clúster VxRail: {0}
'@

    GetAbrVxRailClusterCertificate = ConvertFrom-StringData @'
        Collecting          = Recopilando información de certificados de VxRail.
        ApiCall             = Realizando llamada de referencia a la API en la ruta /trust-store/certificates.
        Heading             = Certificados
        Paragraph           = La siguiente sección detalla los certificados del almacén de confianza configurados en VxRail Manager {0}.
        Name                = Nombre
        Status              = Estado
        IssuedBy            = Emitido Por
        ExpirationDate      = Fecha de Expiración
        SignatureAlgorithm  = Algoritmo de Firma
        Fingerprint         = Huella Digital
        TableName           = Certificados - {0}
        ErrorMessage        = Sección Certificados del clúster VxRail: {0}
'@

    GetAbrVxRailClusterPrecheck = ConvertFrom-StringData @'
        Collecting            = Recopilando información de precheck de VxRail.
        ApiCall               = Realizando llamada de referencia a la API en la ruta /system/prechecks/results.
        Heading               = Resultados de Precheck
        Paragraph             = La siguiente sección detalla los resultados de las comprobaciones previas del sistema (health check) registrados en VxRail Manager {0}.
        Profile               = Perfil
        Status                = Estado
        TotalSeverity         = Gravedad Total
        ChecksPassed          = Comprobaciones Superadas
        ChecksWarning         = Comprobaciones con Advertencia
        ChecksError           = Comprobaciones con Error
        TotalChecks           = Total de Comprobaciones
        TableName             = Resultados de Precheck - {0}
        OutstandingHeading    = Comprobaciones Pendientes
        OutstandingTableName  = Comprobaciones de Precheck Pendientes - {0}
        Source                = Origen
        Check                 = Comprobación
        MessageSeverity       = Gravedad
        Symptom               = Síntoma
        Action                = Acción
        GeneralCheckSource    = Clúster
        ErrorMessage          = Sección Precheck del clúster VxRail: {0}
'@

    GetAbrVxRailHostHardware = ConvertFrom-StringData @'
        Collecting       = Recopilando información de hardware de {0}.
        Heading          = Hardware
        TableName        = Especificaciones de Hardware - {0}
        Hostname         = Nombre de Host
        Manufacturer     = Fabricante
        Model            = Modelo
        SerialNumber     = Número de Serie
        ApplianceID      = ID de Appliance
        Slot             = Ranura
        PowerStatus      = Estado de Alimentación
        Connected        = Conectado
        Yes              = Sí
        No               = No
        TpmPresent       = TPM Presente
        HealthStatus     = Estado de Salud
        OperationStatus  = Estado de Operación
        Available        = Disponible
        PoweringOff      = Apagando
        ErrorMessage     = Sección Hardware del Host VxRail: {0}
'@

    GetAbrVxRailHostEsxi = ConvertFrom-StringData @'
        Collecting        = Recopilando información ESXi de {0}.
        Heading           = ESXi
        TableName         = Especificaciones ESXi - {0}
        ManagementIP      = Dirección IP de Gestión
        VmotionIP         = Dirección IP de vMotion
        VsanIP            = Dirección IP de vSAN
        ErrorMessage      = Sección ESXi del Host VxRail: {0}
'@

    GetAbrVxRailHostFirmware = ConvertFrom-StringData @'
        Collecting              = Recopilando información de firmware de {0}.
        Heading                 = Firmware
        TableName               = Versiones de Firmware - {0}
        Bios                    = BIOS
        Bmc                     = BMC
        CpldFirmware            = Firmware CPLD
        Hba                     = HBA
        ExpanderBackPlane       = Backplane con Expansor
        NonExpanderBackPlane    = Backplane sin Expansor
        Boss                    = BOSS
        IdsdmFirmware           = Firmware IDSDM
        DcpmFirmware            = Firmware DCPM
        PercFirmware            = Firmware PERC
        ErrorMessage            = Sección Firmware del Host VxRail: {0}
'@

    GetAbrVxRailHostComponent = ConvertFrom-StringData @'
        Collecting     = Recopilando información de componentes de {0}.
        Heading        = Componentes
        TableName      = Versiones de Componentes - {0}
        VMwareEsxi     = VMware ESXi
        VxRailVib      = VIB de VxRail
        DellPtAgent    = Dell PtAgent
        HbaDriver      = Controlador HBA
        ErrorMessage   = Sección Componentes del Host VxRail: {0}
'@

    GetAbrVxRailHostBootDevice = ConvertFrom-StringData @'
        Collecting     = Recopilando información del dispositivo de arranque de {0}.
        Heading        = Dispositivos de Arranque
        DeviceHeading  = Dispositivo de Arranque {0}
        BootDevice     = Dispositivo de Arranque
        DeviceType     = Tipo de Dispositivo
        SerialNumber   = Número de Serie
        Model          = Modelo
        SataType       = Tipo SATA
        Capacity       = Capacidad
        Health         = Salud
        Firmware       = Firmware
        DeviceTableName = Especificaciones del Dispositivo de Arranque {0} - {1}
        TableName      = Especificaciones del Dispositivo de Arranque - {0}
        ErrorMessage   = Sección Dispositivo de Arranque del Host VxRail: {0}
'@

    GetAbrVxRailHostDisk = ConvertFrom-StringData @'
        Collecting      = Recopilando información de discos de {0}.
        Heading         = Discos
        DeviceHeading   = Recinto {0} Disco {1}
        Enclosure       = Recinto
        Slot            = Ranura
        SerialNumber    = Número de Serie
        Manufacturer    = Fabricante
        Model           = Modelo
        Firmware        = Firmware
        DiskType        = Tipo de Disco
        Capacity        = Capacidad
        Speed           = Velocidad
        Status          = Estado
        DeviceTableName = Especificaciones del Recinto {0} Disco {1} - {2}
        TableName       = Especificaciones de Discos - {0}
        HeaderEncl      = Rec.
        HeaderType      = Tipo
        ErrorMessage    = Sección Discos del Host VxRail: {0}
'@

    GetAbrVxRailHostNic = ConvertFrom-StringData @'
        Collecting    = Recopilando información de NIC de {0}.
        Heading       = NICs
        TableName     = Especificaciones de NIC - {0}
        Nic           = NIC
        MacAddress    = Dirección MAC
        LinkSpeed     = Velocidad de Enlace
        LinkStatus    = Estado del Enlace
        Firmware      = Firmware
        ErrorMessage  = Sección NIC del Host VxRail: {0}
'@

    GetAbrVxRailHostPsu = ConvertFrom-StringData @'
        Collecting    = Recopilando información de PSU de {0}.
        Heading       = PSUs
        TableName     = Especificaciones de PSU - {0}
        Psu           = PSU
        Manufacturer  = Fabricante
        SerialNumber  = Número de Serie
        PartNumber    = Número de Pieza
        Health        = Salud
        Revision      = Revisión
        ErrorMessage  = Sección PSU del Host VxRail: {0}
'@

    GetAbrVxRailHostIdracIPv4 = ConvertFrom-StringData @'
        Collecting    = Recopilando información de iDRAC de {0}.
        Heading       = Configuración IPv4
        TableName     = Especificaciones IPv4 de iDRAC - {0}
        Dhcp          = DHCP
        Enabled       = Habilitado
        Disabled      = Deshabilitado
        IPv4Address   = Dirección IPv4
        SubnetMask    = Máscara de Subred
        Gateway       = Puerta de Enlace
        ErrorMessage  = Sección IPv4 de iDRAC del Host VxRail: {0}
'@

    GetAbrVxRailHostIdracVlan = ConvertFrom-StringData @'
        Collecting     = Recopilando información de VLAN de iDRAC de {0}.
        Heading        = Configuración de VLAN
        TableName      = Especificaciones VLAN de iDRAC - {0}
        Vlan           = VLAN
        Enabled        = Habilitado
        Disabled       = Deshabilitado
        VlanId         = ID de VLAN
        VlanPriority   = Prioridad de VLAN
        ErrorMessage   = Sección VLAN de iDRAC del Host VxRail: {0}
'@

    GetAbrVxRailHostIdracUser = ConvertFrom-StringData @'
        Collecting      = Recopilando información de usuarios de iDRAC de {0}.
        Heading         = Usuarios
        TableName       = Especificaciones de Usuarios de iDRAC - {0}
        ID              = ID
        UserName        = Nombre de Usuario
        Privilege       = Privilegio
        Administrator   = Administrador
        ErrorMessage    = Sección Usuarios de iDRAC del Host VxRail: {0}
'@
}
