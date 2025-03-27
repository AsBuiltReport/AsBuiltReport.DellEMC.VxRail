function Get-AbrVxRailHostFirmware {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail firmware information from the VxRail Manager API
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
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHost
    )

    begin {
        Write-PScriboMessage "Collecting $($VxrHost.hostname) firmware information."
    }

    process {
        Try {
            $VxrHostFw = $VxrHost.FirmwareInfo
            if ($VxrHostFw) {
                Section -Style NOTOCHeading4 -ExcludeFromTOC "Firmware" {
                    $VxrHostFWInfo = [PSCustomObject]@{
                        'BIOS' = $VxrHostFw.bios_revision
                        'BMC' = $VxrHostFw.bmc_revision
                        'CPLD Firmware' = $VxrHostFw.cpld_version
                    }
                    $MemberProps = @{
                        'InputObject' = $VxrHostFWInfo
                        'MemberType' = 'NoteProperty'
                    }
                    if ($VxrHostFw.hba_version) {
                        Add-Member @MemberProps -Name 'HBA' -Value $VxrHostFw.hba_version
                    }
                    if ($VxrHostFw.expander_bpf_version) {
                        Add-Member @MemberProps -Name 'Expander Back Plane' -Value $VxrHostFw.expander_bpf_version
                    }
                    if ($VxrHostFw.nonexpander_bpf_version) {
                        Add-Member @MemberProps -Name 'Non-Expander Back Plane' -Value $VxrHostFw.nonexpander_bpf_version
                    }
                    if ($VxrHostFw.boss_version) {
                        Add-Member @MemberProps -Name 'BOSS' -Value $VxrHostFw.boss_version
                    }
                    if ($VxrHostFw.idsdm_version) {
                        Add-Member @MemberProps -Name 'IDSDM Firmware' -Value $VxrHostFw.idsdm_version
                    }
                    if ($VxrHostFw.dcpm_version) {
                        Add-Member @MemberProps -Name 'DCPM Firmware' -Value $VxrHostFw.dcpm_version
                    }
                    if ($VxrHostFw.perc_version) {
                        Add-Member @MemberProps -Name 'PERC Firmware' -Value $VxrHostFw.perc_version
                    }
                    $TableParams = @{
                        Name = "Firmware Versions - $($VxrHost.hostname)"
                        List = $true
                        ColumnWidths = 40, 60
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrHostFWInfo | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning "VxRail Host Firmware Section: $($_.Exception.Message)"
        }
    }

    end {
    }
}