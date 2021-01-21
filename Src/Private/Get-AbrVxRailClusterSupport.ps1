function Get-AbrVxRailClusterSupport {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster support information from the VxRail Manager API
    .DESCRIPTION

    .NOTES
        Version:        0.1.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE

    .LINK

    #>
    [CmdletBinding()]
    param (
    )

    begin {
        Write-PscriboMessage "Collecting VxRail cluster support information."
    }

    process {
        $VxrCallHomeMode = Get-VxRailApi -Version 1 -Uri  '/callhome/mode'
        $VxrCallHomeInfo = Get-VxRailApi -Version 1 -Uri '/callhome/info'
        $VxrSupportAccount = Get-VxRailApi -Version 1 -Uri '/support/account'

        if (($VxrCallHomeMode) -and ($VxrCallHomeInfo)) {
            Section -Style Heading2 'Support' {
                Section -Style Heading3 'Dell EMC Secure Remote Service (ESRS)' {
                    $SupportInfo = [PSCustomObject]@{
                        'ESRS Status' = $TextInfo.ToTitleCase($VxrCallHomeInfo.status)
                        'ESRS Type' = Switch ($VxrCallHomeInfo.integrated) {
                            $true { 'Internal ESRS' }
                            $false { 'External ESRS' }
                        }
                        'ESRS Connection' = Switch ($VxrCallHomeMode.is_muted) {
                            $true { 'Disabled' }
                            $false { 'Enabled' }
                        }
                        'ESRS VM IP Address' = $VxrCallHomeInfo.ip_list.ip -join ', '
                        'Site ID' = $VxrCallHomeInfo.site_id
                    }
                    if ($Healthcheck.Support.EsrsStatus) {
                        $SupportInfo | Where-Object { $_.'ESRS Status' -ne 'Registered' } | Set-Style -Style Warning -Property 'ESRS Status'
                    }
                    if ($Healthcheck.Support.EsrsConnection) {
                        $SupportInfo | Where-Object { $_.'ESRS Connection' -ne 'Enabled' } | Set-Style -Style Warning -Property 'ESRS Connection'
                    }
                    $TableParams = @{
                        Name = "Dell EMC Secure Remote Service - $($VxRailMgrHostName)"
                        List = $true
                        ColumnWidths = 50, 50
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $SupportInfo | Table @TableParams
                }
            }
        }
    }

    end {
    }

}