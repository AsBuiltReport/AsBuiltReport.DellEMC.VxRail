function Invoke-AsBuiltReport.DellEMC.VxRail {
    <#
    .SYNOPSIS  
        PowerShell script to document the configuration of Dell EMC VxRail Manager in Word/HTML/XML/Text formats
    .DESCRIPTION
        Documents the configuration of Dell EMC VxRail Manager in Word/HTML/XML/Text formats using PScribo.
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
        [PSCredential] $Credential,
        [String] $StylePath
    )

    # Import JSON Configuration for Options and InfoLevel
    $InfoLevel = $ReportConfig.InfoLevel
    $Options = $ReportConfig.Options

    # General information
    $TextInfo = (Get-Culture).TextInfo
    $username = $Credential.UserName
    $password = $Credential.GetNetworkCredential().Password

    # If custom style not set, use default style
    if (!$StylePath) {
        & "$PSScriptRoot\..\..\AsBuiltReport.DellEMC.VxRail.Style.ps1"
    }


    #region Functions
    Function ConvertFrom-epoch {
        <#
    .Synopsis
    Convert from epoch time to human
    .Description
    Convert from epoch time to human
    .Example
    ConvertFrom-epoch 1295113860
    #>
        [CmdletBinding()]
        param ([Parameter(ValueFromPipeline = $true)]$epochdate)
        
        if (!$psboundparameters.count) { help -ex convertFrom-epoch | Out-String | Remove-EmptyLines; return }
        if (("$epochdate").length -gt 10 ) { (Get-Date -Date "01/01/1970").AddMilliseconds($epochdate) }
        else { (Get-Date -Date "01/01/1970").AddSeconds($epochdate) }
    }
    #endregion Functions

    #region Workaround for SelfSigned Cert an force TLS 1.2
    if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type) {
        $certCallback = @"
        using System;
        using System.Net;
        using System.Net.Security;
        using System.Security.Cryptography.X509Certificates;
        public class ServerCertificateValidationCallback
        {
            public static void Ignore()
            {
                if(ServicePointManager.ServerCertificateValidationCallback ==null)
                {
                    ServicePointManager.ServerCertificateValidationCallback += 
                        delegate
                        (
                            Object obj, 
                            X509Certificate certificate, 
                            X509Chain chain, 
                            SslPolicyErrors errors
                        )
                        {
                            return true;
                        };
                }
            }
        }
"@
        Add-Type $certCallback
    }
    [ServerCertificateValidationCallback]::Ignore()
    [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
    #endregion Workaround for SelfSigned Cert an force TLS 1.2

    #region foreach loop
    foreach ($VIServer in $Target) {

        try {
            $vCenter = Connect-VIServer $VIServer -Credential $Credential -ErrorAction Stop
        } catch {
            Write-Error $_
        }

        $vCenterServer = (Get-AdvancedSetting -Entity $vCenter | Where-Object { $_.name -eq 'VirtualCenter.FQDN' }).Value

        #region VxRail Manager Server Name
        $si = Get-View ServiceInstance -Server $vCenter
        $extMgr = Get-View -Id $si.Content.ExtensionManager -Server $vCenter
        $VxRailMgr = $extMgr.ExtensionList | Where-Object { $_.Key -eq 'com.vmware.vxrail' } | 
        Select-Object @{
            N = 'Name';
            E = { ($_.Server | Where-Object { $_.Type -eq 'HTTPS' } | 
                    Select-Object -ExpandProperty Url).Split('/')[2].Split(':')[0] }
        }
        #endregion VxRail Manager Server Name


        #region System Connection & API Calls
        $api = "https://" + $VxRailMgr.Name + "/rest/vxm/v1"
        $auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($username + ":" + $password ))
        $Header = @{"Authorization" = "Basic $auth" }

        try {
            $VxmSystem = Invoke-RestMethod -Method Get -Uri ($api + '/system/') -Headers $Header
        } catch { }
        try {
            $VxmProxy = Invoke-RestMethod -Method Get -Uri ($api + '/system/proxy/') -Headers $Header
        } catch { }
        try {
            $VxmCallHomeMode = Invoke-RestMethod -Method Get -Uri ($api + '/callhome/mode/') -Headers $Header
        } catch { }
        try {
            $VxmCallHomeInfo = Invoke-RestMethod -Method Get -Uri ($api + '/callhome/info/') -Headers $Header
        } catch { }
        try {
            $VxmInternetMode = Invoke-RestMethod -Method Get -Uri ($api + '/system/internet-mode/') -Headers $Header
        } catch { }
        try {
            $VxmAvailableHosts = Invoke-RestMethod -Method Get -Uri ($api + '/system/available-hosts/') -Headers $Header
        } catch { }
        try {
            $VxmClusterHosts = Invoke-RestMethod -Method Get -Uri ($api + '/system/cluster-hosts/') -Headers $Header
        } catch { }
        #endregion System Connection & API Calls

        #region VxRail Section
        Section -Style Heading1 "$($VxRailMgr.Name)" {
            #region Cluster Section
            Section -Style Heading2 'Cluster' {
                $VxmCluster = [PSCustomObject]@{
                    'Version' = $VxmSystem.Version
                    'Number of Nodes' = $VxmSystem.number_of_host
                    'Connected' = Switch ($VxmSystem.network_connected) {
                        $true { 'Yes' }
                        $false { 'No' }
                    }
                    'Health State' = $VxmSystem.health
                    'vCenter Server' = $vCenterServer
                    'vCenter Server Connected' = Switch ($VxmSystem.vc_connected) {
                        $true { 'Yes' }
                        $false { 'No' }
                    }
                    'External vCenter Server' = Switch ($VxmSystem.is_external_vc) {
                        $true { 'Yes' }
                        $false { 'No' }
                    }
                    'Upgrade Status' = $TextInfo.ToTitleCase($VxmSystem.upgrade_status.ToLower())
                    'Installed On' = (ConvertFrom-epoch $VxmSystem.installed_time).ToLocalTime()
                }
                if ($Healthcheck.Cluster.Health) {
                    $VxmCluster | Where-Object { $_.'Health State' -eq 'Warning' } | Set-Style -Style Warning -Property 'Health State'
                    $VxmCluster | Where-Object { $_.'Health State' -eq 'Error' } | Set-Style -Style Critical -Property 'Health State'
                }
                $VxmCluster | Table -List -Name 'Cluster' -ColumnWidths 50, 50

                #region Installed Components Section
                Section -Style Heading3 'Installed Components' {
                    $VxmComponents = $VxmSystem.installed_components
                    $VxmInstalledComponents = foreach ($VxmComponent in $VxmComponents) {
                        [PSCustomObject]@{
                            'Name' = $VxmComponent.Name
                            'Description' = $VxmComponent.description
                            'Version' = $VxmComponent.current_version
                        }
                    }
                    $VxmInstalledComponents | Sort-Object 'Name' | Table -Name 'Installed Components'
                }
                #endregion Installed Components Section
            }
            #endregion Cluster Section

            #region Appliances Section
            if ($VxmClusterHosts) {
                Section -Style Heading2 'Appliances' {
                    foreach ($VxmClusterHost in $VxmClusterHosts) {
                        Section -Style Heading3 "$($VxmClusterHost.host_name)" {
                            #region Hardware Section
                            Section -Style Heading4 "Hardware" {
                                $ClusterHosts = [PSCustomObject]@{
                                    'PSNT' = $VxmClusterHost.psnt
                                    'Appliance ID' = $VxmClusterHost.id
                                    'Slot' = $VxmClusterHost.slot
                                    'Hostname' = $VxmClusterHost.host_name
                                    'Service Tag' = $VxmClusterHost.serial_number
                                    'Manufacturer' = $VxmClusterHost.Manufacturer
                                    'Model' = $VxmClusterHost.Model
                                    'Power State' = $TextInfo.ToTitleCase(($VxmClusterHost.power_status).ToLower())              
                                    'Connected' = Switch ($VxmClusterHost.missing) {
                                        $true { 'No' }
                                        $false { 'Yes' }
                                    }
                                    'Health State' = $VxmClusterHost.health
                                    'Operation Status' = Switch ($VxmClusterHost.operational_status) {
                                        'NORMAL' { 'Available' }
                                        'powering_off' { 'Powering Off' }
                                        default { $TextInfo.ToTitleCase($VxmClusterHost.operational_status.ToLower()) }
                                    }
                                    'Primary Node' = Switch ($VxmClusterHost.is_primary_node) {
                                        $true { 'Yes' }
                                        $false { 'No' }
                                    }
                                    'Discovered On' = (ConvertFrom-epoch $VxmClusterHost.discovered_date).ToLocalTime()
                                }
                                if ($Healthcheck.Host.PowerState) {
                                    $ClusterHosts | Where-Object { $_.'Power State' -ne 'On' } | Set-Style -Style Critical -Property 'Power State'
                                }
                                if ($Healthcheck.Host.Health) {
                                    $ClusterHosts | Where-Object { $_.'Health State' -eq 'Warning' } | Set-Style -Style Warning -Property 'Health State'
                                    $ClusterHosts | Where-Object { $_.'Health State' -eq 'Error' } | Set-Style -Style Critical -Property 'Health State'

                                }
                                $ClusterHosts | Table -List -Name "$($VxmClusterHost.host_name) Hardware Information" -ColumnWidths 50, 50
                            }
                            #endregion Hardware Section

                            #region ESXi Section
                            Section -Style Heading4 'ESXi' {
                                $ESXiHost = [PSCustomObject]@{
                                    'Management IP Address' = ($VxmClusterHost.ip_set).management_ip
                                    'vMotion IP Address' = ($VxmClusterHost.ip_set).vmotion_ip
                                    'vSAN IP Address' = ($VxmClusterHost.ip_set).vsan_ip
                                }
                                $ESXiHost | Table -List -Name "$($VxmClusterHost.host_name) ESXi Information" -ColumnWidths 50, 50
                            }
                            #endregion ESXi Section

                            #region iDRAC Section
                            $VxmClusterHostiDRAC = Invoke-RestMethod -Method Get -Uri ($api + '/hosts/' + $VxmClusterHost.serial_number + '/idrac/network/') -Headers $Header
                            Section -Style Heading4 'iDRAC' {
                                $VxmHostiDRAC = [PSCustomObject]@{
                                    'DHCP' = Switch ($VxmClusterHostiDRAC.dhcp_enabled) {
                                        $true { 'Enabled' }
                                        $False { 'Disabled' }
                                    }
                                    'IP Address' = $VxmClusterHostiDRAC.ip.ip_address
                                    'Subnet Mask' = $VxmClusterHostiDRAC.ip.netmask
                                    'Default Gateway' = $VxmClusterHostiDRAC.ip.Gateway
                                    'VLAN ID' = $VxmClusterHostiDRAC.vlan.vlan_id
                                }
                                $VxmHostiDRAC | Table -List -Name "$($VxmClusterHost.host_name) iDRAC Information" -ColumnWidths 50, 50
                            }
                            #endregion iDRAC Section
                        }
                    }
                }
            }
            #endregion Appliances Section

            <#
            $AvailableHosts = foreach ($VxmAvailableHost in $VxmAvailableHosts) {
                [PSCustomObject]@{
                    'Appliance ID' = $VxmClusterHost.appliance_id
                    'Model' = $VxmClusterHost.Model
                    'Slot' = $VxmClusterHost.slot
                    'Primary Node' = $VxmClusterHost.is_primary_node
                }
            }
            Write-Output $AvailableHosts
            #>

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
                        $CallHome | Table -List -Name 'Dell EMC Secure Remote Service' -ColumnWidths 50, 50
                    }
                }
            }
            #endregion Support Section

            #region Networking Section
            Section -Style Heading2 'Networking' {
                $Networking = [PSCustomObject]@{
                    'Internet Connection Status' = Switch ($VxmInternetMode.is_dark_site) {
                        $true { 'Enabled' }
                        $false { 'Disabled' }
                    }
                    'Proxy Setting' = Switch ($VxmProxy) {
                        $true { 'Enabled' }
                        $false { 'Disabled' }
                    }
                }
                $Networking | Table -List -Name 'Networking' -ColumnWidths 50, 50

                #region Proxy Server Section
                if ($VxmProxy) {
                    Section -Style Heading3 'Proxy Server' {
                        $ProxyServer = [PSCustomObject]@{
                            'Protocol' = $VxmProxy.Type
                            'IP Address' = $VxmProxy.Server
                            'Port' = $VxmProxy.Port
                        }
                        $ProxyServer | Table -List -Name 'Proxy Server' -ColumnWidths 50, 50
                    }
                }
                #endregion Proxy Server Section
            }
            #endregion Networking Section
        }
        #endregion VxRail Section
    }
    #endregion foreach loop
}