function Get-AbrVxRailRequiredModule {
    <#
    .SYNOPSIS
    Used by As Built Report to check the required 3rd party modules are installed
    .DESCRIPTION

    .NOTES
        Version:        0.1.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    
    .LINK
        
    #>

    $RequiredVersion = '12.1'
    $RequiredModule = Get-Module -ListAvailable -Name 'VMware.PowerCLI' | Sort-Object -Property Version -Descending | Select-Object -First 1
    $ModuleVersion = "$($RequiredModule.Version.Major)" + "." + "$($RequiredModule.Version.Minor)"
    if ($null -eq $ModuleVersion) {
        Write-Warning -Message "VMware PowerCLI $RequiredVersion or higher is required to run the Dell EMC VxRail As Built Report. Run 'Install-Module -Name VMware.PowerCLI -MinimumVersion $RequiredVersion' to install the required modules."
        break
    } elseif ($ModuleVersion -lt $RequiredVersion) {
        Write-Warning -Message "VMware PowerCLI $RequiredVersion or higher is required to run the Dell EMC VxRail As Built Report. Run 'Update-Module -Name VMware.PowerCLI -MinimumVersion $RequiredVersion' to update PowerCLI."
        break
    }

}