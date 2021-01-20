
function Get-AbrVxRailHostFirmware {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail firmware information from the VxRail Manager API
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
        Write-PscriboMessage "Collecting $($VxrHost.hostname) firmware information."
    }

    process {
        $VxrHostFw = $VxrHost.FirmwareInfo
        if ($VxrHostFw) {
            Section -Style Heading4 "Firmware" {
                $VxrHostFWInfo = [PSCustomObject]@{
                    'BIOS' = $VxrHostFw.bios_revision
                    'BMC' = $VxrHostFw.bmc_revision
                    'HBA' = $VxrHostFw.hba_version
                    'Expander Back Plane' = $VxrHostFw.expander_bpf_version
                    'BOSS' = $VxrHostFw.boss_version
                    'CPLD Firmware' = $VxrHostFw.cpld_version
                    'IDSDM Firmware' = $VxrHostFw.idsdm_version
                }
                $TableParams = @{
                    Name = "Firmware Versions - $($VxrHost.hostname)"
                    List = $true
                    ColumnWidths = 50, 50
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VxrHostFWInfo | Table @TableParams
            }
        }
    }

    end {
    }

}