function Get-AbrVxRailClusterPrecheck {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail system precheck (health check) results from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.1.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailClusterPrecheck
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>
    [CmdletBinding()]
    param (
    )

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailClusterPrecheck
        Write-PScriboMessage $LocalizedData.Collecting
    }

    process {
        Try {
            Write-PScriboMessage $LocalizedData.ApiCall
            $VxrPrechecks = (Get-VxRailApi -Version 1 -Uri '/system/prechecks/results').report_list
            if ($VxrPrechecks) {
                Section -Style Heading2 $LocalizedData.Heading {
                    Paragraph ($LocalizedData.Paragraph -f $VxRailMgrHostName)
                    BlankLine
                    $VxrPrecheckInfo = foreach ($VxrPrecheck in $VxrPrechecks) {
                        [PSCustomObject]@{
                            $LocalizedData.Profile = $VxrPrecheck.profile
                            $LocalizedData.Status = $TextInfo.ToTitleCase($VxrPrecheck.status.ToLower().Replace('-', ' '))
                            $LocalizedData.TotalSeverity = $TextInfo.ToTitleCase($VxrPrecheck.total_severity.ToLower())
                            $LocalizedData.ChecksPassed = $VxrPrecheck.total_success_count
                            $LocalizedData.ChecksWarning = $VxrPrecheck.total_warn_count
                            $LocalizedData.ChecksError = $VxrPrecheck.total_error_count
                            $LocalizedData.TotalChecks = $VxrPrecheck.complete_check_count
                        }
                    }
                    if ($Healthcheck.Precheck.TotalSeverity) {
                        $VxrPrecheckInfo | Where-Object { $_.($LocalizedData.TotalSeverity) -eq 'Warn' } | Set-Style -Style Warning -Property $LocalizedData.TotalSeverity
                        $VxrPrecheckInfo | Where-Object { $_.($LocalizedData.TotalSeverity) -in @('Error', 'Critical') } | Set-Style -Style Critical -Property $LocalizedData.TotalSeverity
                    }
                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxRailMgrHostName)
                        ColumnWidths = 16, 14, 14, 14, 14, 14, 14
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrPrecheckInfo | Table @TableParams

                    # Only surface individual checks that did not pass - a full, unfiltered listing of every
                    # OK check across every host would run to hundreds of rows with no diagnostic value.
                    if ($InfoLevel.Precheck -ge 2) {
                        $VxrPrecheckMessages = foreach ($VxrPrecheck in $VxrPrechecks) {
                            foreach ($VxrHostCheck in $VxrPrecheck.results.host_checks) {
                                foreach ($VxrCheck in ($VxrHostCheck.checks | Where-Object { $_.result.severity -ne 'OK' })) {
                                    foreach ($VxrMessage in $VxrCheck.result.messages) {
                                        [PSCustomObject]@{
                                            $LocalizedData.Source = $VxrHostCheck.host_id
                                            $LocalizedData.Check = $VxrCheck.check_id
                                            $LocalizedData.MessageSeverity = $TextInfo.ToTitleCase($VxrMessage.severity.ToLower())
                                            $LocalizedData.Symptom = $VxrMessage.symptom
                                            $LocalizedData.Action = $VxrMessage.action
                                        }
                                    }
                                }
                            }
                            foreach ($VxrGeneralCheck in ($VxrPrecheck.results.general_checks | Where-Object { $_.result.severity -ne 'OK' })) {
                                foreach ($VxrMessage in $VxrGeneralCheck.result.messages) {
                                    [PSCustomObject]@{
                                        $LocalizedData.Source = $LocalizedData.GeneralCheckSource
                                        $LocalizedData.Check = $VxrGeneralCheck.check_id
                                        $LocalizedData.MessageSeverity = $TextInfo.ToTitleCase($VxrMessage.severity.ToLower())
                                        $LocalizedData.Symptom = $VxrMessage.symptom
                                        $LocalizedData.Action = $VxrMessage.action
                                    }
                                }
                            }
                        }
                        if ($VxrPrecheckMessages) {
                            Section -Style NOTOCHeading3 -ExcludeFromTOC $LocalizedData.OutstandingHeading {
                                if ($Healthcheck.Precheck.TotalSeverity) {
                                    $VxrPrecheckMessages | Where-Object { $_.($LocalizedData.MessageSeverity) -eq 'Warn' } | Set-Style -Style Warning -Property $LocalizedData.MessageSeverity
                                    $VxrPrecheckMessages | Where-Object { $_.($LocalizedData.MessageSeverity) -in @('Error', 'Critical') } | Set-Style -Style Critical -Property $LocalizedData.MessageSeverity
                                }
                                $TableParams = @{
                                    Name = ($LocalizedData.OutstandingTableName -f $VxRailMgrHostName)
                                    ColumnWidths = 14, 16, 10, 30, 30
                                }
                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }
                                $VxrPrecheckMessages | Table @TableParams
                            }
                        }
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
