function Get-AbrVxRailHostPsu {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail PSU information from the VxRail Manager API
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
        [Object]$VxrHostChassis
    )

    begin {
        Write-PscriboMessage "Collecting $($VxrHost.hostname) PSU information."
    }

    process {
        $VxrHostPSUs = $VxrHostChassis.power_supplies | Sort-Object slot
        if ($VxrHostPSUs) {
            Section -Style Heading4 "PSUs" {
                $VxrHostPsuInfo = foreach ($VxrHostPSU in $VxrHostPSUs) {
                    [PSCustomObject]@{
                        'PSU' = $VxrHostPSU.slot
                        'Manufacturer' = $VxrHostPSU.manufacturer
                        'Serial Number' = $VxrHostPSU.sn
                        'Part Number' = $VxrHostPSU.part_number
                        'Health' = $VxrHostPSU.health
                        'Revision' = $VxrHostPSU.revision_number
                    }
                }
                if ($Healthcheck.Appliance.PowerSupply) {
                    $VxrHostPsuInfo | Where-Object { $_.'Health' -ne 'Healthy' } | Set-Style -Style Critical -Property 'Health'
                }
                $TableParams = @{
                    Name = "PSU Specifications - $($VxrHost.hostname)"
                    ColumnWidths = 13, 17, 21, 21, 14, 14
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VxrHostPsuInfo | Table @TableParams
            }
        }
    }

    end {
    }

}