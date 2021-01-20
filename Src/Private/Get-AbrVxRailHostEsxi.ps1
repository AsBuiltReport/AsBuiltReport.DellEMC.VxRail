function Get-AbrVxRailHostEsxi {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail ESXi information from the VxRail Manager API
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
        [Object]$VxrClusterHost
    )

    begin {
        Write-PscriboMessage "Collecting $($VxrHost.hostname) NIC information."
    }

    process {
        if ($VxrClusterHost) {
            Section -Style Heading4 'ESXi' {
                $ESXiHost = [PSCustomObject]@{
                    'Management IP Address' = ($VxrClusterHost.ip_set).management_ip
                    'vMotion IP Address' = ($VxrClusterHost.ip_set).vmotion_ip
                    'vSAN IP Address' = ($VxrClusterHost.ip_set).vsan_ip
                }
                $TableParams = @{
                    Name = "ESXi Specifications - $($VxrClusterHost.host_name)"
                    List = $true
                    ColumnWidths = 50, 50
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $ESXiHost | Table @TableParams
            }
        }
    }

    end {
    }

}