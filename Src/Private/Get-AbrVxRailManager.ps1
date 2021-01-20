function Get-AbrVxRailManager {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail Manager information from the VxRail Manager API
    .DESCRIPTION
    
    .NOTES
        Version:        0.1.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    
    .LINK
        
    #>

    try {
        Write-PScriboMessage "Connecting to vCenter Server '$VIServer'."
        $vCenter = Connect-VIServer $VIServer -Credential $Credential -ErrorAction Stop
    } catch {
        throw
    }

    if ($vCenter) {
        Write-PScriboMessage "Collecting VxRail Manager Information"
        $global:vCenterServer = (Get-AdvancedSetting -Entity $vCenter | Where-Object { $_.name -eq 'VirtualCenter.FQDN' }).Value

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
    }

}
