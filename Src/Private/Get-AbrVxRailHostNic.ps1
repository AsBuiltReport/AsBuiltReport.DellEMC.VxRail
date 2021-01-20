function Get-AbrVxRailHostNic {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail NIC information from the VxRail Manager API
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
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHost
    )

    begin {
        Write-PscriboMessage "Collecting $($VxrHost.hostname) NIC information."
    }

    process {
        $VxrHostNics = $VxrHost.nics | Sort-Object slot
        if ($VxrHostNics) {
            Section -Style Heading4 "NICs" {
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
                    ColumnWidths = 20, 20, 20, 20, 20
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VxrHostNicInfo | Table @TableParams
            }
        }
    }

    end {
    }

}