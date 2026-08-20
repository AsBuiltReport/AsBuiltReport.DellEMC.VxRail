function Get-AbrVxRailHostDisk {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail disk information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailHostDisk -VxrHost $VxrHost
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
        $LocalizedData = $reportTranslate.GetAbrVxRailHostDisk
        Write-PScriboMessage ($LocalizedData.Collecting -f $VxrHost.hostname)
    }

    process {
        Try {
            $VxrHostDisks = $VxrHost.disks | Sort-Object enclosure, slot
            if ($VxrHostDisks) {
                Section -Style NOTOCHeading4 -ExcludeFromToC $LocalizedData.Heading {
                    $VxrHostDiskInfo = foreach ($VxrHostDisk in $VxrHostDisks) {
                        [PSCustomObject]@{
                            $LocalizedData.Enclosure = $VxrHostDisk.Enclosure
                            $LocalizedData.Slot = $VxrHostDisk.Slot
                            $LocalizedData.SerialNumber = $VxrHostDisk.sn
                            $LocalizedData.Manufacturer = $VxrHostDisk.manufacturer
                            $LocalizedData.Model = $VxrHostDisk.model
                            $LocalizedData.Firmware = $VxrHostDisk.firmware_revision
                            $LocalizedData.DiskType = $VxrHostDisk.disk_type
                            $LocalizedData.Capacity = $VxrHostDisk.capacity
                            $LocalizedData.Speed = $VxrHostDisk.max_capable_speed
                            $LocalizedData.Status = $VxrHostDisk.disk_state
                        }
                    }
                    if ($Healthcheck.Appliance.DiskStatus) {
                        $VxrHostDiskInfo | Where-Object { $_.($LocalizedData.Status) -ne 'OK' } | Set-Style -Style Critical
                    }
                    if ($InfoLevel.Appliance -ge 2) {
                        foreach ($VxrHostDisk in $VxrHostDiskInfo) {
                            Section -Style NOTOCHeading5 -ExcludeFromTOC ($LocalizedData.DeviceHeading -f $VxrHostDisk.($LocalizedData.Enclosure), $VxrHostDisk.($LocalizedData.Slot)) {
                                $TableParams = @{
                                    Name = ($LocalizedData.DeviceTableName -f $VxrHostDisk.($LocalizedData.Enclosure), $VxrHostDisk.($LocalizedData.Slot), $VxrHost.hostname)
                                    List = $true
                                    ColumnWidths = 40, 60
                                }
                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }
                                $VxrHostDisk | Table @TableParams
                            }
                        }
                    } else {
                        $TableParams = @{
                            Name = ($LocalizedData.TableName -f $VxrHost.hostname)
                            Headers = $LocalizedData.HeaderEncl, $LocalizedData.Slot, $LocalizedData.SerialNumber, $LocalizedData.HeaderType, $LocalizedData.Capacity, $LocalizedData.Speed, $LocalizedData.Status, $LocalizedData.Firmware
                            Columns = $LocalizedData.Enclosure, $LocalizedData.Slot, $LocalizedData.SerialNumber, $LocalizedData.DiskType, $LocalizedData.Capacity, $LocalizedData.Speed, $LocalizedData.Status, $LocalizedData.Firmware
                            ColumnWidths = 9, 9, 22, 10, 14, 12, 12, 12
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $VxrHostDiskInfo | Table @TableParams
                    }
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
