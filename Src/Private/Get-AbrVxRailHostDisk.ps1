function Get-AbrVxRailHostDisk {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail disk information from the VxRail Manager API
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
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHost
    )

    begin {
        Write-PScriboMessage "Collecting $($VxrHost.hostname) disk information."
    }

    process {
        $VxrHostDisks = $VxrHost.disks | Sort-Object enclosure, slot
        if ($VxrHostDisks) {
            Section -Style Heading4 "Disks" {
                $VxrHostDiskInfo = foreach ($VxrHostDisk in $VxrHostDisks) {
                    [PSCustomObject]@{
                        'Enclosure' = $VxrHostDisk.Enclosure
                        'Slot' = $VxrHostDisk.Slot
                        'Serial Number' = $VxrHostDisk.sn
                        'Manufacturer' = $VxrHostDisk.manufacturer
                        'Model' = $VxrHostDisk.model
                        'Firmware' = $VxrHostDisk.firmware_revision
                        'Disk Type' = $VxrHostDisk.disk_type
                        'Capacity' = $VxrHostDisk.capacity
                        'Speed' = $VxrHostDisk.max_capable_speed
                        'Status' = $VxrHostDisk.disk_state
                    }
                }
                if ($Healthcheck.Appliance.DiskStatus) {
                    $VxrHostDiskInfo | Where-Object { $_.'Status' -ne 'OK' } | Set-Style -Style Critical
                }
                if ($InfoLevel.Appliance -ge 2) {
                    foreach ($VxrHostDisk in $VxrHostDiskInfo) {
                        Section -Style Heading5 -ExcludeFromTOC "Enclosure $($VxrHostDisk.Enclosure) Disk $($VxrHostDisk.Slot)" {
                            $TableParams = @{
                                Name = "Enclosure $($VxrHostDisk.Enclosure) Disk $($VxrHostDisk.Slot) Specifications - $($VxrHost.hostname)"
                                List = $true
                                ColumnWidths = 50, 50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $VxrHostDisk | Table @TableParams
                        }
                    }
                } else {
                    $TableParams = @{
                        Name = "Disk Specifications - $($VxrHost.hostname)"
                        Headers = 'Encl', 'Slot', 'Serial Number', 'Type', 'Capacity', 'Speed', 'Status', 'Firmware'
                        Columns = 'Enclosure', 'Slot', 'Serial Number', 'Disk Type', 'Capacity', 'Speed', 'Status', 'Firmware'
                        ColumnWidths = 9, 9, 22, 10, 14, 12, 12, 12
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrHostDiskInfo | Table @TableParams
                }
            }
        }
    }

    end {
    }

}