
function Get-AbrVxRailHostComponent {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail installed component information from vCenter Server
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
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Object]$VxrHost
    )

    begin {
        Write-PscriboMessage "Collecting $($VxrHost.hostname) component information."
    }

    process {
        Try {
            if ($esxcli) {
                Section -Style NOTOCHeading4 -ExcludeFromToC "Components" {
                    $DellPtAgent = $esxcli.software.vib.get.invoke() | Where-Object {$_.name -eq 'dellptagent'}
                    $HbaDevice = $esxcli.hardware.pci.list.invoke() | Where-object {($_.modulename -match 'lsi_msgpt3') -or ($_.modulename -match 'nmlx5_core')} | Select-Object -First 1
                    $HbaDriver = $esxcli.system.module.get.invoke(@{module = $HbaDevice.modulename})
                    #$NicDevice = $esxcli.hardware.pci.list.invoke() | Where-Object {($_.ConfiguredOwner -eq 'VMkernel') -and ($_.DeviceClassName -eq 'Ethernet controller') } | Select-Object -First 1
                    #$NicDriver = $esxcli.system.module.get.invoke(@{module = $NicDevice.modulename})
                    $VxRailVib = $esxcli.software.vib.get.invoke() | Where-Object {$_.name -eq 'platform-service'}
                    $VMwareEsxi = $esxcli.system.version.get.invoke()
                    $VxrHostComponent = [PSCustomObject]@{
                        'VMware ESXi' = "$($VMwareEsxi.version)-$((($VMwareESXi.build).Split('-')[1]))"
                        'VxRail VIB' = $VxRailVib.version
                    }
                    $MemberProps = @{
                        'InputObject' = $VxrHostComponent
                        'MemberType' = 'NoteProperty'
                    }
                    if ($DellPtAgent.version) {
                        Add-Member @MemberProps -Name 'Dell PtAgent' -Value $DellPtAgent.version
                    }
                    if ($HbaDriver.version) {
                        Add-Member @MemberProps -Name 'HBsA Driver' -Value $HbaDriver.version
                    }
                    <#
                    if ($NicDriver.version) {
                        Add-Member @MemberProps -Name 'NIC Driver' -Value $NicDriver.version
                    }
                    #>

                    $TableParams = @{
                        Name = "Component Versions - $($VxrHost.hostname)"
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
            Write-PScriboMessage -IsWarning "VxRail Host Component Section: $($_.Exception.Message)"
        }
    }

    end {
    }

}