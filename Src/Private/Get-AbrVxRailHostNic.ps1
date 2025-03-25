function Get-AbrVxRailHostNic {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail NIC information from the VxRail Manager API
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
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHost
    )

    begin {
        Write-PscriboMessage "Collecting $($VxrHost.hostname) NIC information."
    }

    process {
        Try {
            $VxrHostNics = $VxrHost.nics | Sort-Object slot
            if ($VxrHostNics) {
                Section -Style NOTOCHeading4 -ExcludeFromTOC "NICs" {
                    $VxrHostNicInfo = foreach ($VxrHostNic in $VxrHostNics) {
                        [PSCustomObject]@{
                            'NIC' = $VxrHostNic.slot
                            'MAC Address' = $VxrHostNic.mac
                            'Link Speed' = $VxrHostNic.link_speed
                            'Link Status' = $VxrHostNic.link_status
                            'Firmware' = $VxrHostNic.firmware_family_version
                        }
                    }
                    if ($Healthcheck.Appliance.NetworkLinkStatus) {
                        $VxrHostNicInfo | Where-Object { $_.'Link Status' -ne 'Up' } | Set-Style -Style Critical -Property 'Link Status'
                    }
                    $TableParams = @{
                        Name = "NIC Specifications - $($VxrHost.hostname)"
                        ColumnWidths = 15, 25, 20, 20, 20
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrHostNicInfo | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning "VxRail Host NIC Section: $($_.Exception.Message)"
        }
    }

    end {
    }

}