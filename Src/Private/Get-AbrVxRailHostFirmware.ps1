
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
                    'BIOS' = Switch ($VxrHostFw.bios_revision) {
                        $null { '--' }
                        default { $VxrHostFw.bios_revision }
                    }
                    'BMC' = Switch ($VxrHostFw.bmc_revision) {
                        $null { '--' }
                        default { $VxrHostFw.bmc_revision }
                    }
                    'HBA' = Switch ($VxrHostFw.hba_version) {
                        $null { '--' }
                        default { $VxrHostFw.hba_version }
                    }
                    'Expander Back Plane' = Switch ($VxrHostFw.expander_bpf_version) {
                        $null { '--' }
                        default { $VxrHostFw.expander_bpf_version }
                    }
                    'BOSS' = Switch ($VxrHostFw.boss_version) {
                        $null { '--' }
                        default { $VxrHostFw.boss_version }
                    }
                    'CPLD Firmware' = Switch ($VxrHostFw.cpld_version) {
                        $null { '--' }
                        default { $VxrHostFw.cpld_version }
                    }
                    'IDSDM Firmware' = Switch ($VxrHostFw.idsdm_version) {
                        $null { '--' }
                        default { $VxrHostFw.idsdm_version }
                    }
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