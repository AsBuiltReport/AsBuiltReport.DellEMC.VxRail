function Get-AbrVxRailHostFirmware {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail firmware information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailHostFirmware -VxrHost $VxrHost
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHost
    )

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailHostFirmware
        Write-PScriboMessage ($LocalizedData.Collecting -f $VxrHost.hostname)
    }

    process {
        Try {
            $VxrHostFw = $VxrHost.FirmwareInfo
            if ($VxrHostFw) {
                Section -Style NOTOCHeading4 -ExcludeFromTOC $LocalizedData.Heading {
                    $VxrHostFWInfo = [PSCustomObject]@{
                        $LocalizedData.Bios = $VxrHostFw.bios_revision
                        $LocalizedData.Bmc = $VxrHostFw.bmc_revision
                        $LocalizedData.CpldFirmware = $VxrHostFw.cpld_version
                    }
                    $MemberProps = @{
                        'InputObject' = $VxrHostFWInfo
                        'MemberType' = 'NoteProperty'
                    }
                    if ($VxrHostFw.hba_version) {
                        Add-Member @MemberProps -Name $LocalizedData.Hba -Value $VxrHostFw.hba_version
                    }
                    if ($VxrHostFw.expander_bpf_version) {
                        Add-Member @MemberProps -Name $LocalizedData.ExpanderBackPlane -Value $VxrHostFw.expander_bpf_version
                    }
                    if ($VxrHostFw.nonexpander_bpf_version) {
                        Add-Member @MemberProps -Name $LocalizedData.NonExpanderBackPlane -Value $VxrHostFw.nonexpander_bpf_version
                    }
                    if ($VxrHostFw.boss_version) {
                        Add-Member @MemberProps -Name $LocalizedData.Boss -Value $VxrHostFw.boss_version
                    }
                    if ($VxrHostFw.idsdm_version) {
                        Add-Member @MemberProps -Name $LocalizedData.IdsdmFirmware -Value $VxrHostFw.idsdm_version
                    }
                    if ($VxrHostFw.dcpm_version) {
                        Add-Member @MemberProps -Name $LocalizedData.DcpmFirmware -Value $VxrHostFw.dcpm_version
                    }
                    if ($VxrHostFw.perc_version) {
                        Add-Member @MemberProps -Name $LocalizedData.PercFirmware -Value $VxrHostFw.perc_version
                    }
                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxrHost.hostname)
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
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }
}
