function Get-AbrVxRailHostEsxi {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail ESXi information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailHostEsxi -VxrClusterHost $VxrClusterHost
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrClusterHost
    )

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailHostEsxi
        Write-PScriboMessage ($LocalizedData.Collecting -f $VxrClusterHost.host_name)
    }

    process {
        Try {
            if ($VxrClusterHost) {
                Section -Style NOTOCHeading4 -ExcludeFromTOC $LocalizedData.Heading {
                    $ESXiHost = [PSCustomObject]@{
                        $LocalizedData.ManagementIP = ($VxrClusterHost.ip_set).management_ip
                        $LocalizedData.VmotionIP = ($VxrClusterHost.ip_set).vmotion_ip
                        $LocalizedData.VsanIP = ($VxrClusterHost.ip_set).vsan_ip
                    }
                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxrClusterHost.host_name)
                        List = $true
                        ColumnWidths = 40, 60
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $ESXiHost | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
