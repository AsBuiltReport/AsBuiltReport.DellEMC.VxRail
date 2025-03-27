
function Get-AbrVxRailHostBootDevice {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail boot device information from the VxRail Manager API
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
        [parameter(Mandatory=$true, ValueFromPipeline=$True)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHost
    )

    begin {
        Write-PscriboMessage "Collecting $($VxrHost.hostname) boot device information."
    }

    process {
        Try {
            $VxrHostBootDevices = $VxrHost.boot_devices
            if ($VxrHostBootDevices) {
                Section -Style NOTOCHeading4 -ExcludeFromToC "Boot Devices" {
                    $VxrHostBootDeviceSlot = 0
                    $VxrHostBootDeviceInfo = foreach ($VxrHostBootDevice in $VxrHostBootDevices) {
                        [PSCustomObject]@{
                            'Boot Device' = $VxrHostBootDeviceSlot++
                            'Device Type' = $VxrHostBootDevice.bootdevice_type
                            'Serial Number' = $VxrHostBootDevice.sn
                            'Model' = $VxrHostBootDevice.device_model
                            'SATA Type' = $VxrHostBootDevice.sata_type
                            'Capacity' = $VxrHostBootDevice.capacity
                            'Health' = $VxrHostBootDevice.health
                            'Firmware' = $VxrHostBootDevice.firmware_version
                        }
                    }
                    if ($Healthcheck.Appliance.BootDevice) {
                        $VxrHostBootDeviceInfo | Where-Object { $_.'Health' -ne '100%' } | Set-Style -Style Warning -Property 'Health'
                    }
                    if ($InfoLevel.Appliance -ge 2) {
                        foreach ($VxrHostBootDevice in $VxrHostBootDeviceInfo) {
                            Section -Style NOTOCHeading5 -ExcludeFromTOC "Boot Device $($VxrHostBootDevice.'Boot Device')" {
                                $TableParams = @{
                                    Name = "Boot Device $($VxrHostBootDevice.'Boot Device') Specifications - $($VxrHost.hostname)"
                                    List = $true
                                    ColumnWidths = 40, 60
                                }
                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }
                                $VxrHostBootDevice | Table @TableParams
                            }
                        }
                    } else {
                        $TableParams = @{
                            Name = "Boot Device Specifications - $($VxrHost.hostname)"
                            Columns = 'Boot Device', 'Device Type', 'SATA Type', 'Capacity', 'Health', 'Firmware'
                            #ColumnWidths = 20, 20, 20, 20, 20
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $VxrHostBootDeviceInfo | Table @TableParams
                    }
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning "VxRail Host Boot Device Section: $($_.Exception.Message)"
        }
    }

    end {
    }

}