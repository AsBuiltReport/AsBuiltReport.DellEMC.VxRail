function Get-AbrVxRailClusterSupport {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster support information from the VxRail Manager API
    .DESCRIPTION

    .NOTES
        Version:        0.2.0
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
        Write-PScriboMessage "Performing API reference call to path /callhome/mode"
        $VxrCallHomeMode = Get-VxRailApi -Version 1 -Uri  '/callhome/mode'
        Write-PScriboMessage "Performing API reference call to path /callhome/info"
        $VxrCallHomeInfo = Get-VxRailApi -Version 1 -Uri '/callhome/info'
        Write-PScriboMessage "Performing API reference call to path /support/account"
        $VxrSupportAccount = Get-VxRailApi -Version 1 -Uri '/support/account'
        Write-PScriboMessage "Performing API reference call to path /support/contact"
        $VxrSupportContact = Get-VxRailApi -Version 1 -Uri '/support/contact'

        Section -Style Heading2 'Support' {
            if ($VxrSupportAccount.Username) {
                Section -Style Heading3 'Dell EMC Support Account' {
                    $SupportAcct = [PSCustomObject]@{
                        'Support Account' = $VxrSupportAccount.Username
                        }
                    $TableParams = @{
                        Name = "Dell EMC Support Account - $($VxRailMgrHostName)"
                        List = $true
                        ColumnWidths = 50, 50
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $SupportAcct | Table @TableParams
                }
            }
            if (($VxrCallHomeMode) -and ($VxrCallHomeInfo)) {
                Section -Style Heading3 'Dell EMC Secure Remote Service (SRS)' {
                    $SupportInfo = [PSCustomObject]@{
                        'SRS Status' = Switch ($VxrCallHomeInfo.status) {
                            'Not_Configured' { 'Not Configured' }
                            default { $TextInfo.ToTitleCase($VxrCallHomeInfo.status) }
                        }
                        'SRS Type' = Switch ($VxrCallHomeInfo.integrated) {
                            $true { 'Internal ESRS' }
                            $false { 'External ESRS' }
                        }
                        'SRS Connection' = Switch ($VxrCallHomeMode.is_muted) {
                            $true { 'Enabled' }
                            $false { 'Disabled' }
                        }
                        'SRS VM IP Address' = $VxrCallHomeInfo.ip_list.ip -join ', '
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
            if ($VxrSupportContact.Company) {
                Section -Style Heading3 'Support Contact' {
                    $SupportContactInfo = [PSCustomObject]@{
                        'Company' = Switch ($VxrSupportContact.Company) {
                            $null { '--' }
                            default { $VxrSupportContact.Company }
                        }
                        'Email' = Switch ($VxrSupportContact.Email) {
                            $null { '--' }
                            default { $VxrSupportContact.Email }
                        }
                        'First Name' = Switch ($VxrSupportContact.first_name) {
                            $null { '--' }
                            default { $VxrSupportContact.first_name }
                        }
                        'Last Name' = Switch ($VxrSupportContact.last_name) {
                            $null { '--' }
                            default { $VxrSupportContact.last_name }
                        }
                        'Phone Number' = Switch ($VxrSupportContact.phone) {
                            $null { '--' }
                            default { $VxrSupportContact.phone }
                        }
                    }
                    $TableParams = @{
                        Name = "Support Contact Information - $($VxRailMgrHostName)"
                        List = $true
                        ColumnWidths = 50, 50
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $SupportContactInfo | Table @TableParams
                }
            }
        }
    }

    end {
    }

}