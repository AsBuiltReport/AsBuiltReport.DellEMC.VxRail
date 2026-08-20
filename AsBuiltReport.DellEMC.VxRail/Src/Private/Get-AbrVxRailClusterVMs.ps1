function Get-AbrVxRailClusterVMs {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster VM information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailClusterVMs
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailClusterVMs
        Write-PScriboMessage $LocalizedData.Collecting
    }

    process {
        Try {
            Write-PScriboMessage $LocalizedData.ApiCall
            $VxrClusterVMs = Get-VxRailApi -Version 1 -Uri '/cluster/system-virtual-machines'
            if ($VxrClusterVMs) {
                Section -Style Heading3 $LocalizedData.Heading {
                    $VxrClusterVMInfo = foreach ($VxrClusterVM in $VxrClusterVMs) {
                        [PSCustomObject]@{
                            $LocalizedData.VirtualMachine = $VxrClusterVM.Name
                            $LocalizedData.EsxiHost = $VxrClusterVM.host
                            $LocalizedData.Status = $TextInfo.ToTitleCase(($VxrClusterVM.status).ToLower()).replace('_', ' ')
                        }
                    }
                    if ($Healthcheck.Cluster.VMPowerStatus) {
                        $VxrClusterVMInfo | Where-Object { $_.($LocalizedData.Status) -ne 'Powered On' } | Set-Style -Style Warning -Property $LocalizedData.Status
                    }
                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxRailMgrHostName)
                        ColumnWidths = 33, 34, 33
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrClusterVMInfo | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
