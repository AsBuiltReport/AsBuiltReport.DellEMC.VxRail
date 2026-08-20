function Get-AbrVxRailClusterSupport {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster support information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailClusterSupport
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailClusterSupport
        Write-PScriboMessage $LocalizedData.Collecting
    }

    process {
        Try {
            Write-PScriboMessage $LocalizedData.ApiCallCallHomeMode
            $VxrCallHomeMode = Get-VxRailApi -Version 1 -Uri  '/callhome/mode'
            Write-PScriboMessage $LocalizedData.ApiCallCallHomeInfo
            $VxrCallHomeInfo = Get-VxRailApi -Version 1 -Uri '/callhome/info'
            Write-PScriboMessage $LocalizedData.ApiCallSupportAccount
            $VxrSupportAccount = Get-VxRailApi -Version 1 -Uri '/support/account'
            Write-PScriboMessage $LocalizedData.ApiCallSupportContact
            $VxrSupportContact = Get-VxRailApi -Version 1 -Uri '/support/contact'

            Section -Style Heading2 $LocalizedData.Heading {
                Paragraph ($LocalizedData.Paragraph -f $VxRailMgrHostName)
                BlankLine
                if ($VxrSupportAccount.Username) {
                    Section -Style Heading3 $LocalizedData.SupportAccountHeading {
                        $SupportAcct = [PSCustomObject]@{
                            $LocalizedData.SupportAccount = $VxrSupportAccount.Username
                            }
                        $TableParams = @{
                            Name = ($LocalizedData.SupportAccountTableName -f $VxRailMgrHostName)
                            List = $true
                            ColumnWidths = 40, 60
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $SupportAcct | Table @TableParams
                    }
                }
                if (($VxrCallHomeMode) -and ($VxrCallHomeInfo)) {
                    Section -Style Heading3 $LocalizedData.SrsHeading {
                        $SupportInfo = [PSCustomObject]@{
                            $LocalizedData.SrsStatus = Switch ($VxrCallHomeInfo.status) {
                                'Not_Configured' { $LocalizedData.NotConfigured }
                                default { $TextInfo.ToTitleCase($VxrCallHomeInfo.status) }
                            }
                            $LocalizedData.SrsType = Switch ($VxrCallHomeInfo.integrated) {
                                $true { $LocalizedData.InternalEsrs }
                                $false { $LocalizedData.ExternalEsrs }
                            }
                            $LocalizedData.SrsConnection = Switch ($VxrCallHomeMode.is_muted) {
                                $true { $LocalizedData.Enabled }
                                $false { $LocalizedData.Disabled }
                            }
                            $LocalizedData.SrsVmIPAddress = $VxrCallHomeInfo.ip_list.ip -join ', '
                            $LocalizedData.SiteID = $VxrCallHomeInfo.site_id
                        }
                        if ($Healthcheck.Support.EsrsStatus) {
                            $SupportInfo | Where-Object { $_.($LocalizedData.SrsStatus) -ne 'Registered' } | Set-Style -Style Warning -Property $LocalizedData.SrsStatus
                        }
                        if ($Healthcheck.Support.EsrsConnection) {
                            $SupportInfo | Where-Object { $_.($LocalizedData.SrsConnection) -ne $LocalizedData.Enabled } | Set-Style -Style Warning -Property $LocalizedData.SrsConnection
                        }
                        $TableParams = @{
                            Name = ($LocalizedData.SrsTableName -f $VxRailMgrHostName)
                            List = $true
                            ColumnWidths = 40, 60
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $SupportInfo | Table @TableParams
                    }
                }
                if ($VxrSupportContact.Company) {
                    Section -Style Heading3 $LocalizedData.SupportContactHeading {
                        $SupportContactInfo = [PSCustomObject]@{
                            $LocalizedData.Company = Switch ($VxrSupportContact.Company) {
                                $null { $LocalizedData.NotAvailable }
                                default { $VxrSupportContact.Company }
                            }
                            $LocalizedData.Email = Switch ($VxrSupportContact.Email) {
                                $null { $LocalizedData.NotAvailable }
                                default { $VxrSupportContact.Email }
                            }
                            $LocalizedData.FirstName = Switch ($VxrSupportContact.first_name) {
                                $null { $LocalizedData.NotAvailable }
                                default { $VxrSupportContact.first_name }
                            }
                            $LocalizedData.LastName = Switch ($VxrSupportContact.last_name) {
                                $null { $LocalizedData.NotAvailable }
                                default { $VxrSupportContact.last_name }
                            }
                            $LocalizedData.PhoneNumber = Switch ($VxrSupportContact.phone) {
                                $null { $LocalizedData.NotAvailable }
                                default { $VxrSupportContact.phone }
                            }
                        }
                        $TableParams = @{
                            Name = ($LocalizedData.SupportContactTableName -f $VxRailMgrHostName)
                            List = $true
                            ColumnWidths = 40, 60
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $SupportContactInfo | Table @TableParams
                    }
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
