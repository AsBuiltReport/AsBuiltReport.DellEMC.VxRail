function Get-AbrVxRailClusterHost {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail cluster host information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailClusterHost
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailClusterHost
        Write-PScriboMessage $LocalizedData.Collecting
    }

    process {
        Try {
            Write-PScriboMessage $LocalizedData.ApiCall
            $VxrClusterHosts = Get-VxRailApi -Version 1 -Uri '/system/cluster-hosts'
            if ($VxrClusterHosts) {
                Section -Style NOTOCHeading4 -ExcludeFromToC $LocalizedData.Heading {
                    $VxrClusterHostInfo = foreach ($VxrClusterHost in ($VxrClusterHosts | Sort-Object host_name)) {
                        [PSCustomObject]@{
                            $LocalizedData.Hostname = $VxrClusterHost.host_name
                            $LocalizedData.ManagementIP = ($VxrClusterHost.ip_set).management_ip
                            $LocalizedData.ServiceTag = $VxrClusterHost.serial_number
                            $LocalizedData.ApplianceID = $VxrClusterHost.psnt
                            $LocalizedData.Model = $VxrClusterHost.Model
                        }
                    }
                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxRailMgrHostName)
                        ColumnWidths = 25, 20, 15, 20, 20
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrClusterHostInfo | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
