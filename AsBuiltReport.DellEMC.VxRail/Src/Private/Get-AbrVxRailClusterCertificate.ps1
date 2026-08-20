function Get-AbrVxRailClusterCertificate {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail trust store certificate information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.1.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailClusterCertificate
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>
    [CmdletBinding()]
    param (
    )

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailClusterCertificate
        Write-PScriboMessage $LocalizedData.Collecting
    }

    process {
        Try {
            Write-PScriboMessage $LocalizedData.ApiCall
            $VxrCertificates = Get-VxRailApi -Version 1 -Uri '/trust-store/certificates'
            if ($VxrCertificates) {
                Section -Style Heading2 $LocalizedData.Heading {
                    Paragraph ($LocalizedData.Paragraph -f $VxRailMgrHostName)
                    BlankLine
                    $VxrCertificateInfo = foreach ($VxrCertificate in $VxrCertificates) {
                        # Parse the certificate expiration time. The VxRail API returns this in OpenSSL's
                        # ASN1_TIME format (e.g. 'Mar  1 18:38:26 2033 UTC') - note the double space before a
                        # single-digit day, which [DateTime]::Parse cannot handle, hence the explicit format
                        # and whitespace normalization instead of a generic parse.
                        Try {
                            $VxrCertExpirationString = ($VxrCertificate.expiration_time -replace ' UTC$', '') -replace '\s+', ' '
                            $VxrCertExpiration = [DateTime]::ParseExact($VxrCertExpirationString, 'MMM d HH:mm:ss yyyy', [System.Globalization.CultureInfo]::InvariantCulture)
                        } Catch {
                            $VxrCertExpiration = $null
                        }
                        [PSCustomObject]@{
                            $LocalizedData.Name = $VxrCertificate.name
                            $LocalizedData.Status = $TextInfo.ToTitleCase($VxrCertificate.status.ToLower())
                            $LocalizedData.IssuedBy = $VxrCertificate.issued_by
                            $LocalizedData.ExpirationDate = if ($VxrCertExpiration) { $VxrCertExpiration.ToString('dd MMMM yyyy') } else { $VxrCertificate.expiration_time }
                            $LocalizedData.SignatureAlgorithm = $VxrCertificate.signature_algorithm
                            $LocalizedData.Fingerprint = $VxrCertificate.fingerprint
                            'SortExpiration' = $VxrCertExpiration
                        }
                    }
                    if ($Healthcheck.Certificate.Status) {
                        # 'Valid' is the raw VxRail API status value (TitleCased), not an author-controlled
                        # mapping, so it is compared literally rather than via $LocalizedData - the full set
                        # of possible status values (Expired, Revoked, etc.) is not documented.
                        $VxrCertificateInfo | Where-Object { $_.($LocalizedData.Status) -ne 'Valid' } | Set-Style -Style Critical -Property $LocalizedData.Status
                    }
                    if ($Healthcheck.Certificate.ExpiringSoon) {
                        $VxrCertificateInfo | Where-Object { $_.SortExpiration -and ($_.SortExpiration -lt (Get-Date).AddDays(90)) -and ($_.SortExpiration -gt (Get-Date)) } | Set-Style -Style Warning -Property $LocalizedData.ExpirationDate
                    }
                    if ($InfoLevel.Certificate -ge 2) {
                        $TableParams = @{
                            Name = ($LocalizedData.TableName -f $VxRailMgrHostName)
                            Columns = $LocalizedData.Name, $LocalizedData.Status, $LocalizedData.IssuedBy, $LocalizedData.ExpirationDate, $LocalizedData.SignatureAlgorithm, $LocalizedData.Fingerprint
                            ColumnWidths = 14, 9, 20, 12, 15, 30
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $VxrCertificateInfo | Sort-Object $LocalizedData.Name | Table @TableParams
                    } else {
                        $TableParams = @{
                            Name = ($LocalizedData.TableName -f $VxRailMgrHostName)
                            Columns = $LocalizedData.Name, $LocalizedData.Status, $LocalizedData.IssuedBy, $LocalizedData.ExpirationDate
                            ColumnWidths = 25, 15, 30, 30
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $VxrCertificateInfo | Sort-Object $LocalizedData.Name | Table @TableParams
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
