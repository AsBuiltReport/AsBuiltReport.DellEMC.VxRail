
function Get-AbrVxRailHostComponent {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail installed component information from vCenter Server
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
        Write-PscriboMessage "Collecting $($VxrHost.hostname) component information."
    }

    process {
        if ($esxcli) {
            Section -Style Heading4 "Components" {
                $DellPtAgent = $esxcli.software.vib.get.invoke() | Where-Object {$_.name -eq 'dellptagent'}
                $HbaDevice = $esxcli.hardware.pci.list.invoke() | Where-object {$_.modulename -eq 'lsi_msgpt3'}
                $HbaDriver = $esxcli.system.module.get.invoke(@{module = $HbaDevice.modulename})
                $NicDevice = $esxcli.hardware.pci.list.invoke() | Where-Object {$_.VMkernelName -eq 'vmnic0'}
                $NicDriver = $esxcli.system.module.get.invoke(@{module = $NicDevice.modulename})
                $VxRailVib = $esxcli.software.vib.get.invoke() | Where-Object {$_.name -eq 'platform-service'}
                $VMwareEsxi = $esxcli.system.version.get.invoke()
                $VxrHostComponent = [PSCustomObject]@{
                    'Dell PtAgent' = Switch ($DellPtAgent.version) {
                        $null { '--' }
                        default { ($DellPtAgent.version) }
                    }
                    'HBA Driver' = Switch ($HbaDriver.version) {
                        $null { '--' }
                        default { ($HbaDriver.version) }
                    }
                    'NIC Driver' = Switch ($NicDriver.version) {
                        $null { '--' }
                        default { ($NicDriver.version) }
                    }
                    'VMware ESXi' = "$($VMwareEsxi.version)-$((($VMwareESXi.build).Split('-')[1]))"
                    'VxRail VIB' = Switch ($VxRailVib.version) {
                        $null { '--' }
                        default { ($VxRailVib.version) }
                    }
                }
                $TableParams = @{
                    Name = "Component Versions - $($VxrHost.hostname)"
                    List = $true
                    ColumnWidths = 50, 50
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VxrHostComponent | Table @TableParams
            }
        }
    }

    end {
    }

}