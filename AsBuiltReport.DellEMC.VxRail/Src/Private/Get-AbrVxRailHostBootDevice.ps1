function Get-AbrVxRailHostBootDevice {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail boot device information from the VxRail Manager API
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailHostBootDevice -VxrHost $VxrHost
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true, ValueFromPipeline=$True)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHost
    )

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailHostBootDevice
        Write-PScriboMessage ($LocalizedData.Collecting -f $VxrHost.hostname)
    }

    process {
        Try {
            $VxrHostBootDevices = $VxrHost.boot_devices
            if ($VxrHostBootDevices) {
                Section -Style NOTOCHeading4 -ExcludeFromToC $LocalizedData.Heading {
                    $VxrHostBootDeviceSlot = 0
                    $VxrHostBootDeviceInfo = foreach ($VxrHostBootDevice in $VxrHostBootDevices) {
                        [PSCustomObject]@{
                            $LocalizedData.BootDevice = $VxrHostBootDeviceSlot++
                            $LocalizedData.DeviceType = $VxrHostBootDevice.bootdevice_type
                            $LocalizedData.SerialNumber = $VxrHostBootDevice.sn
                            $LocalizedData.Model = $VxrHostBootDevice.device_model
                            $LocalizedData.SataType = $VxrHostBootDevice.sata_type
                            $LocalizedData.Capacity = $VxrHostBootDevice.capacity
                            $LocalizedData.Health = $VxrHostBootDevice.health
                            $LocalizedData.Firmware = $VxrHostBootDevice.firmware_version
                        }
                    }
                    if ($Healthcheck.Appliance.BootDevice) {
                        $VxrHostBootDeviceInfo | Where-Object { $_.($LocalizedData.Health) -ne '100%' } | Set-Style -Style Warning -Property $LocalizedData.Health
                    }
                    if ($InfoLevel.Appliance -ge 2) {
                        foreach ($VxrHostBootDevice in $VxrHostBootDeviceInfo) {
                            Section -Style NOTOCHeading5 -ExcludeFromTOC ($LocalizedData.DeviceHeading -f $VxrHostBootDevice.($LocalizedData.BootDevice)) {
                                $TableParams = @{
                                    Name = ($LocalizedData.DeviceTableName -f $VxrHostBootDevice.($LocalizedData.BootDevice), $VxrHost.hostname)
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
                            Name = ($LocalizedData.TableName -f $VxrHost.hostname)
                            Columns = $LocalizedData.BootDevice, $LocalizedData.DeviceType, $LocalizedData.SataType, $LocalizedData.Capacity, $LocalizedData.Health, $LocalizedData.Firmware
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
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
