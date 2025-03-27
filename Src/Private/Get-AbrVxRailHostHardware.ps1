function Get-AbrVxRailHostHardware {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve Dell EMC VxRail hardware information from the VxRail Manager API
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
        Write-PscriboMessage "Collecting $($VxrHost.hostname) hardware information."
    }

    process {
        Try {
            if ($VxrHost) {
                Section -Style NOTOCHeading4 -ExcludeFromTOC "Hardware" {
                    $VxrHostHW = [PSCustomObject]@{
                        'Hostname' = $VxrHost.hostname
                        'Manufacturer' = $VxrHost.Manufacturer
                        'Model' = $VxrClusterHost.Model
                        'Serial Number' = $VxrHost.sn
                        'Appliance ID' = $VxrHost.psnt
                        'Slot' = $VxrHost.slot
                        'Power Status' = $TextInfo.ToTitleCase($VxrHost.power_status)
                        'Connected' = Switch ($VxrHost.missing) {
                            $true { 'No' }
                            $false { 'Yes' }
                        }
                        'TPM Present' = Switch ($VxrHost.tpm_present) {
                            $true { 'No' }
                            $false { 'Yes' }
                        }
                        'Health Status' = $VxrHost.health
                        'Operation Status' = Switch ($VxrHost.operational_status) {
                            'normal' { 'Available' }
                            'powering_off' { 'Powering Off' }
                            default { $TextInfo.ToTitleCase($VxrHost.operational_status) }
                        }
                    }
                    if ($Healthcheck.Appliance.PowerStatus) {
                        $VxrHostHW | Where-Object { $_.'Power Status' -ne 'On' } | Set-Style -Style Critical -Property 'Power Status'
                    }
                    if ($Healthcheck.Appliance.HealthStatus) {
                        $VxrHostHW | Where-Object { $_.'Health Status' -eq 'Warning' } | Set-Style -Style Warning -Property 'Health Status'
                        $VxrHostHW | Where-Object { $_.'Health Status' -eq 'Error' } | Set-Style -Style Critical -Property 'Health Status'

                    }
                    $TableParams = @{
                        Name = "Hardware Specifications - $($VxrHost.hostname)"
                        List = $true
                        ColumnWidths = 40, 60
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrHostHW | Table @TableParams
                }
            }
        } Catch {
            Write-PScriboMessage -IsWarning "VxRail Host Hardware Section: $($_.Exception.Message)"
        }
    }

    end {
    }

}