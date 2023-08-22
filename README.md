<p align="center">
    <a href="https://www.asbuiltreport.com/" alt="AsBuiltReport"></a>
            <img src='https://github.com/AsBuiltReport.png' width="8%" height="8%" /></a>
</p>
<p align="center">
    <a href="https://www.powershellgallery.com/packages/AsBuiltReport.DellEMC.VxRail/" alt="PowerShell Gallery Version">
        <img src="https://img.shields.io/powershellgallery/v/AsBuiltReport.DellEMC.VxRail.svg" /></a>
    <a href="https://www.powershellgallery.com/packages/AsBuiltReport.DellEMC.VxRail/" alt="PS Gallery Downloads">
        <img src="https://img.shields.io/powershellgallery/dt/AsBuiltReport.DellEMC.VxRail.svg" /></a>
    <a href="https://www.powershellgallery.com/packages/AsBuiltReport.DellEMC.VxRail/" alt="PS Platform">
        <img src="https://img.shields.io/powershellgallery/p/AsBuiltReport.DellEMC.VxRail.svg" /></a>
</p>
<p align="center">
    <a href="https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/graphs/commit-activity" alt="GitHub Last Commit">
        <img src="https://img.shields.io/github/last-commit/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/master.svg" /></a>
    <a href="https://raw.githubusercontent.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/master/LICENSE" alt="GitHub License">
        <img src="https://img.shields.io/github/license/AsBuiltReport/AsBuiltReport.DellEMC.VxRail.svg" /></a>
    <a href="https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/graphs/contributors" alt="GitHub Contributors">
        <img src="https://img.shields.io/github/contributors/AsBuiltReport/AsBuiltReport.DellEMC.VxRail.svg"/></a>
</p>
<p align="center">
    <a href="https://twitter.com/AsBuiltReport" alt="Twitter">
            <img src="https://img.shields.io/twitter/follow/AsBuiltReport.svg?style=social"/></a>
</p>

<p align="center">
    <a href='https://ko-fi.com/B0B7DDGZ7' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
</p>

# Dell EMC VxRail As Built Report

Dell EMC VxRail As Built Report is a PowerShell module which works in conjunction with [AsBuiltReport.Core](https://github.com/AsBuiltReport/AsBuiltReport.Core).

[AsBuiltReport](https://github.com/AsBuiltReport/AsBuiltReport) is an open-sourced community project which utilises PowerShell to produce as-built documentation in multiple document formats for multiple vendors and technologies.

The Dell EMC VxRail As Built Report module is used to generate as built documentation for Dell EMC VxRail hyperconverged infrastructure.

## :books: Sample Reports
### Sample Report - Default Style
Sample Dell EMC VxRail As Built Report with health checks, using default report style.

![Sample Dell EMC VxRail As Built Report](https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/blob/master/Samples/Sample%20Dell%20EMC%20VxRail%20As%20Built%20Report.jpg "Sample Dell EMC VxRail As Built Report")

Sample Dell EMC VxRail As Built Report HTML file: [Sample Dell EMC VxRail As Built Report.html](https://htmlpreview.github.io/?https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/blob/master/Samples/Sample%20Dell%20EMC%20VxRail%20As%20Built%20Report.html "Sample Dell EMC VxRail As Built Report")

# :beginner: Getting Started
Below are the instructions on how to install, configure and generate a Dell EMC VxRail As Built Report.

## :floppy_disk: Supported Versions

* VxRail 4.7 and higher

### PowerShell
This report is compatible with the following PowerShell versions;

| Windows PowerShell 5.1 | PowerShell 7 |
|:----------------------:|:------------:|
|   :white_check_mark:|  :white_check_mark:  |

## :wrench: System Requirements
PowerShell 5.1 or PowerShell 7, and the following PowerShell modules are required for generating a Dell EMC VxRail As Built report.

Install the following modules by following the [module installation](https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail#package-module-installation) procedure.

- [VMware PowerCLI Module](https://www.powershellgallery.com/packages/VMware.PowerCLI/)
- [AsBuiltReport.DellEMC.VxRail Module](https://www.powershellgallery.com/packages/AsBuiltReport.DellEMC.VxRail/)

### Linux & macOS
* .NET Core is required for cover page image support on Linux and macOS operating systems.
    * [Installing .NET Core for macOS](https://docs.microsoft.com/en-us/dotnet/core/install/macos)
    * [Installing .NET Core for Linux](https://docs.microsoft.com/en-us/dotnet/core/install/linux)

❗ If you are unable to install .NET Core, you must set `ShowCoverPageImage` to `False` in the report JSON configuration file.

### :closed_lock_with_key: Required Privileges
* A VMware vSphere user account with administrator privileges is required to generate a Dell EMC VxRail As Built Report.

## :package: Module Installation

### PowerShell

Open a PowerShell terminal window and install the required module.

:warning: VMware PowerCLI 12.3 or higher is required. Please ensure older PowerCLI versions have been uninstalled.

```powershell
install-module VMware.PowerCLI -MinimumVersion 12.3 -AllowClobber
install-module AsBuiltReport.DellEMC.VxRail
```
### GitHub
If you are unable to use the PowerShell Gallery, you can still install the module manually. Ensure you repeat the following steps for the [system requirements](https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail#wrench-system-requirements) also.

1. Download the code package / [latest release](https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/releases/latest) zip from GitHub
2. Extract the zip file
3. Copy the folder `AsBuiltReport.DellEMC.VxRail` to a path that is set in `$env:PSModulePath`.
4. Open a PowerShell terminal window and unblock the downloaded files with
    ```powershell
    $path = (Get-Module -Name AsBuiltReport.DellEMC.VxRail -ListAvailable).ModuleBase; Unblock-File -Path $path\*.psd1; Unblock-File -Path $path\Src\Public\*.ps1; Unblock-File -Path $path\Src\Private\*.ps1
    ```
5. Close and reopen the PowerShell terminal window.

_Note: You are not limited to installing the module to those example paths, you can add a new entry to the environment variable PSModulePath if you want to use another path._
## :pencil2: Configuration
The Dell EMC VxRail As Built Report utilises a JSON file to allow configuration of report information, options, detail and healthchecks.

A Dell EMC VxRail report configuration file can be generated by executing the following command;
```powershell
New-AsBuiltReportConfig -Report DellEMC.VxRail -FolderPath <User specified folder> -Filename <Optional>
```

Executing this command will copy the default Dell EMC VxRail report JSON configuration to a user specified folder.

All report settings can then be configured via the JSON file.

The following provides information of how to configure each schema within the report's JSON file.

### Report
The **Report** schema provides configuration of the VxRail Manager report information

| Sub-Schema          | Setting      | Default                     | Description                                                  |
|---------------------|--------------|-----------------------------|--------------------------------------------------------------|
| Name                | User defined | Dell VxRail As Built Report | The name of the As Built Report                              |
| Version             | User defined | 1.0                         | The report version                                           |
| Status              | User defined | Released                    | The report release status                                    |
| ShowCoverPageImage  | true / false | true                        | Toggle to enable/disable the display of the cover page image |
| ShowTableOfContents | true / false | true                        | Toggle to enable/disable table of contents                   |
| ShowHeaderFooter    | true / false | true                        | Toggle to enable/disable document headers & footers          |
| ShowTableCaptions   | true / false | true                        | Toggle to enable/disable table captions/numbering            |

### Options
The **Options** schema allows certain options within the report to be toggled on or off.

### InfoLevel
The **InfoLevel** schema allows configuration of each section of the report at a granular level.

There are 2 levels (0-1) of detail granularity for each section as follows;

| Setting | InfoLevel         | Description                                                 |
|:-------:|-------------------|-------------------------------------------------------------|
|    0    | Disabled          | Does not collect or display any information                 |
|    1    | Enabled / Summary | Provides summarised information for a collection of objects |
|    2    | Detailed          | Provides detailed information for individual objects        |

The table below outlines the default and maximum **InfoLevel** settings for each section.

| Sub-Schema | Default Setting | Maximum Setting |
|------------|:---------------:|:---------------:|
| Cluster    |        1        |        2        |
| Appliance  |        1        |        2        |
| Support    |        1        |        1        |
| Network    |        1        |        1        |

### Healthcheck
The **Healthcheck** schema is used to toggle health checks on or off.

#### Cluster
The **Cluster** schema is used to configure health checks for VxRail clusters.

| Sub-Schema    | Setting      | Default | Description                                         | Highlight                                                                                     |
|---------------|--------------|---------|-----------------------------------------------------|-----------------------------------------------------------------------------------------------|
| HealthStatus  | true / false | true    | Highlights VxRail clusters which report an error    | ![Critical](https://via.placeholder.com/15/F5DBD9/F5DBD9.png) VxRail cluster is in an error state |
| VMPowerStatus | true / false | true    | Highlights VxRail cluster VMs which are powered off | ![Warning](https://via.placeholder.com/15/FEF3B5/FEF3B5.png) VxRail cluster VM is powered off     |

#### Appliance
The **Appliance** schema is used to configure health checks for VxRail appliances.


| Sub-Schema        | Setting      | Default | Description                                                              | Highlight                                                                                                                                                                                            |
|-------------------|--------------|---------|--------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| HealthStatus      | true / false | true    | Highlights VxRail appliances which report an issue                       | ![Warning](https://via.placeholder.com/15/FEF3B5/FEF3B5.png) VxRail appliance is reporting a warning<br>![Critical](https://via.placeholder.com/15/F5DBD9/F5DBD9.png) VxRail appliance is reporting an error |
| PowerStatus       | true / false | true    | Highlights VxRail appliances which are powered off                       | ![Critical](https://via.placeholder.com/15/F5DBD9/F5DBD9.png) VxRail appliance is powered off                                                                                                            |
| BootDevice        | true / false | true    | Highlights VxRail boot devices which report less than 100% health        | ![Warning](https://via.placeholder.com/15/FEF3B5/FEF3B5.png) Boot device reports <100% health                                                                                                            |
| NetworkLinkStatus | true / false | true    | Highlights VxRail network adpaters with a link status of `Down`          | ![Critical](https://via.placeholder.com/15/F5DBD9/F5DBD9.png) Network adapter link status is `Down`                                                                                                      |
| DiskStatus        | true / false | true    | Highlights VxRail disks which report a status which is not equal to `OK` | ![Critical](https://via.placeholder.com/15/F5DBD9/F5DBD9.png) Disk status is not `OK`                                                                                                                    |
| PowerSupply       | true / false | true    | Highlights VxRail power supplies which are not `Healthy`                 | ![Critical](https://via.placeholder.com/15/F5DBD9/F5DBD9.png) Power supply is not `Healthy`                                                                                                              |

#### Support
The **Support** schema is used to configure health checks for the VxRail support configuration.


| Sub-Schema     | Setting      | Default | Description                                   | Highlight                                                                              |
|----------------|--------------|---------|-----------------------------------------------|----------------------------------------------------------------------------------------|
| EsrsStatus     | true / false | true    | Highlights when ESRS is `Not Configured`      | ![Warning](https://via.placeholder.com/15/FEF3B5/FEF3B5.png) ESRS is `Not Configured`      |
| EsrsConnection | true / false | true    | Highlights when ESRS connection is `Disabled` | ![Warning](https://via.placeholder.com/15/FEF3B5/FEF3B5.png) ESRS connection is `Disabled` |

## :computer: Examples

:exclamation: The `Target` parameter **MUST** specify the vCenter Server IP/FQDN which manages the VxRail cluster. The `Username`, `Password` and `Credential` parameters must also use relevant vCenter Server credentials.


```powershell
# Generate a VxRail As Built Report for VxRail cluster 'vxrail-01.corp.local' using specified vCenter Server credentials. The VxRail cluster is managed by vCenter Server 'vcenter-01.corp.local'. Export report to HTML & DOCX formats. Use default report style. Append timestamp to report filename. Save reports to 'C:\Users\Tim\Documents'
PS C:\> New-AsBuiltReport -Report DellEMC.VxRail -Target 'vcenter-01.corp.local' -Username 'administrator@vsphere.local' -Password 'VMware1!' -Format Html,Word -OutputFolderPath 'C:\Users\Tim\Documents' -Timestamp

# Generate a VxRail As Built Report for VxRail cluster 'vxrail-01.corp.local' using specified vCenter Server credentials and VxRail report configuration file. The VxRail cluster is managed by vCenter Server 'vcenter-01.corp.local'. Export report to Text, HTML & DOCX formats. Use default report style. Save reports to 'C:\Users\Tim\Documents'. Display verbose messages to the console.
PS C:\> New-AsBuiltReport -Report -Report DellEMC.VxRail -Target 'vcenter-01.corp.local' -Username 'administrator@vsphere.local' -Password 'VMware1!' -Format Text,Html,Word -OutputFolderPath 'C:\Users\Tim\Documents' -Verbose

# Generate a VxRail As Built Report for VxRail cluster 'vxrail-01.corp.local' using stored vCenter Server credentials. The VxRail cluster is managed by vCenter Server 'vcenter-01.corp.local'. Export report to HTML & Text formats. Use default report style. Highlight environment issues within the report. Save reports to 'C:\Users\Tim\Documents'.
PS C:\> $Creds = Get-Credential # Store vCenter Server credentials
PS C:\> New-AsBuiltReport -Report DellEMC.VxRail -Target 'vcenter-01.corp.local' -Credential $Creds -Format Html,Text -OutputFolderPath 'C:\Users\Tim\Documents' -EnableHealthCheck

# Generate a single VxRail As Built Report for VxRail clusters 'vxrail-01.corp.local' and 'vxrail-02.corp.local'. The VxRail clusters are managed by two individual vCenter Servers 'vcenter-01.corp.local' and 'vcenter-02.corp.local'. Report exports to WORD format by default. Apply custom style to the report. Reports are saved to the user profile folder by default.
PS C:\> New-AsBuiltReport -Report DellEMC.VxRail -Target 'vcenter-01.corp.local','vcenter-02.corp.local' -Username 'administrator@vsphere.local' -Password 'VMware1!' -StyleFilePath 'C:\Scripts\Styles\MyCustomStyle.ps1'

# Generate a VxRail As Built Report for VxRail cluster 'vxrail-01.corp.local' using specified credentials. he VxRail cluster is managed by vCenter Server 'vcenter-01.corp.local'. Export report to HTML & DOCX formats. Use default report style. Reports are saved to the user profile folder by default. Attach and send reports via e-mail.
PS C:\> New-AsBuiltReport -Report DellEMC.VxRail -Target 'vcenter-01.corp.local' -Username 'administrator@vsphere.local' -Password 'VMware1!' -Format Html,Word -OutputFolderPath 'C:\Users\Tim\Documents' -SendEmail
```
