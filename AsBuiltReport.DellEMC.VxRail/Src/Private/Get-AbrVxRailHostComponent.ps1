function Get-AbrVxRailHostComponent {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail installed component information from vCenter Server
    .DESCRIPTION
    Documents the configuration of Dell EMC VxRail Manager in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.3.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    PS C:\> Get-AbrVxRailHostComponent -VxrHost $VxrHost
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHost
    )

    begin {
        $LocalizedData = $reportTranslate.GetAbrVxRailHostComponent
        Write-PScriboMessage ($LocalizedData.Collecting -f $VxrHost.hostname)
    }

    process {
        Try {
            if ($esxcli) {
                Section -Style NOTOCHeading4 -ExcludeFromToC $LocalizedData.Heading {
                    $DellPtAgent = $esxcli.software.vib.get.invoke() | Where-Object {$_.name -eq 'dellptagent'}
                    $HbaDevice = $esxcli.hardware.pci.list.invoke() | Where-object {($_.modulename -match 'lsi_msgpt3') -or ($_.modulename -match 'nmlx5_core')} | Select-Object -First 1
                    $HbaDriver = $esxcli.system.module.get.invoke(@{module = $HbaDevice.modulename})
                    #$NicDevice = $esxcli.hardware.pci.list.invoke() | Where-Object {($_.ConfiguredOwner -eq 'VMkernel') -and ($_.DeviceClassName -eq 'Ethernet controller') } | Select-Object -First 1
                    #$NicDriver = $esxcli.system.module.get.invoke(@{module = $NicDevice.modulename})
                    $VxRailVib = $esxcli.software.vib.get.invoke() | Where-Object {$_.name -eq 'platform-service'}
                    $VMwareEsxi = $esxcli.system.version.get.invoke()
                    $VxrHostComponent = [PSCustomObject]@{
                        $LocalizedData.VMwareEsxi = "$($VMwareEsxi.version)-$((($VMwareESXi.build).Split('-')[1]))"
                        $LocalizedData.VxRailVib = $VxRailVib.version
                    }
                    $MemberProps = @{
                        'InputObject' = $VxrHostComponent
                        'MemberType' = 'NoteProperty'
                    }
                    if ($DellPtAgent.version) {
                        Add-Member @MemberProps -Name $LocalizedData.DellPtAgent -Value $DellPtAgent.version
                    }
                    if ($HbaDriver.version) {
                        Add-Member @MemberProps -Name $LocalizedData.HbaDriver -Value $HbaDriver.version
                    }
                    <#
                    if ($NicDriver.version) {
                        Add-Member @MemberProps -Name 'NIC Driver' -Value $NicDriver.version
                    }
                    #>

                    $TableParams = @{
                        Name = ($LocalizedData.TableName -f $VxrHost.hostname)
                        List = $true
                        ColumnWidths = 40, 60
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrHostComponent | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning ($LocalizedData.ErrorMessage -f $_.Exception.Message)
        }
    }

    end {
    }

}
