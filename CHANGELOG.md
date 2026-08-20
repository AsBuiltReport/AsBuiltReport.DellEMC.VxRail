# :arrows_clockwise: Dell EMC VxRail As Built Report Changelog

## [0.5.0] - [Unreleased]
### Added
- Add `VCF.PowerCLI` to External Module Dependencies
- Add `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md` and `SECURITY.md`
- Add `Stale` and `Dependabot` GitHub workflows
- Add `Known Issues` section to README
- Add working Sample Reports link to README
- Add en-US and en-GB localization support, including a `Report.Language` configuration key
- Add comment-based help to all private functions
- Add `Tests` folder with Pester manifest/structure and localization test suites, plus a `Pester` GitHub workflow
- Add VxRail trust store certificate reporting (`Get-AbrVxRailClusterCertificate`), with `Certificate` InfoLevel and HealthCheck settings for certificate status and upcoming expiry
- Add Telemetry Tier to the VxRail Cluster Specifications table
- Add VxRail system precheck (health check) results reporting (`Get-AbrVxRailClusterPrecheck`), with `Precheck` InfoLevel and HealthCheck settings; InfoLevel 2 surfaces individual outstanding (non-OK) checks
- Add Codecov and Pester Tests status badges to README

### Changed
- Update Required Modules to AsBuiltReport.Core v1.6.4
- Update module folder structure to nested module folder layout
- Update `actions/checkout` to v7 in all GitHub workflows
- Update README and bug report template references from VMware.PowerCLI to VCF.PowerCLI
- Declare `PowerShellVersion` and `CompatiblePSEditions` explicitly in the module manifest
- Update module script to build paths with `Join-Path` instead of string concatenation
- Rename `ConvertFrom-epoch` to `ConvertFrom-Epoch` and add comment-based help
- Rename `Get-AbrVxRailHostIdracIpv4.ps1` to `Get-AbrVxRailHostIdracIPv4.ps1` to match its function name
- Update CONTRIBUTING.md example AsBuiltReport.Core version reference to v1.6.4
- Update module startup banner (project info, version check) to use AsBuiltReport.Core's `Write-ReportModuleInfo`

### Removed
- Removed tweet action from GitHub release workflow
- Removed `Get-RequiredModule` private function, now provided by AsBuiltReport.Core
- Removed `Export-ModuleMember` calls for private functions; the module manifest's `FunctionsToExport` is now the sole export authority
- Removed dead code from `ConvertFrom-Epoch`
- Removed `AsBuiltReport.DellEMC.VxRail.Style.ps1` — redundant, unreferenced local PScribo style file superseded by AsBuiltReport.Core's default style

### Fixed
- Fixed `Add-Type` failure in `Get-VxRailApi.ps1` on PowerShell 7 caused by the obsolete `ServicePointManager` API (Fix [#18](https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/issues/18))
- Fixed report generation failing with VCF PowerCLI installed by updating the PowerCLI version check from VMware.PowerCLI 13.0 to VCF.PowerCLI 9.1 (Fix [#17](https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/issues/17))
- Fixed missing VxRail VIB information in the Components section on VxRail 8.0.322+, where the platform service VIB was renamed from `platform-service` to `platformsvc` (Fix [#16](https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/issues/16))
- Fixed VxRail Cluster Support health checks never triggering due to a property name mismatch (`SRS Status`/`SRS Connection` vs. `ESRS Status`/`ESRS Connection`)
- Fixed a typo in the VxRail Host Component table (`HBsA Driver` → `HBA Driver`)
- Fixed `Get-AbrVxRailHostEsxi` and `Get-AbrVxRailHostPsu` collection messages referencing an undefined `$VxrHost` variable
- Fixed README `Report` schema table missing the `Language` configuration key
- Fixed README InfoLevel description stating "2 levels (0-1)" when the table below it lists three settings (0-2)
- Fixed README HealthCheck highlight swatches using the discontinued via.placeholder.com service; switched to placehold.co
- Fixed `Get-AbrVxRailCluster` throwing and silently dropping the entire Cluster Specifications table when `/vc/mode` returns no data

## [0.4.5] - 2025-03-28
### Added
- Add VxRail Manager IP information
- Add VxRail Cluster name information
- Add support for VxRail 8.x (Fix [#12](https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/issues/12))
- Add support for reporting of multiple VxRail clusters within the same vCenter Server (Fix [#13](https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/issues/13))

### Fixed
- Fix time & date outputs showing incorrect date format
- Fix GitHub Release workflow
- Fix [#11](https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/issues/11)

### Changed
- Update Required Modules to AsBuiltReport.Core v1.4.3
- Update VMware PowerCLI requirements to version 13.3
- Improve section heading & TOC structure
- Change list tables to 40/60 column widths
- Update GitHub bug and change request templates

### Removed
- Removed support for VxRail 4.7

## [[0.3.0](https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail/releases/tag/v0.3.0)] - 2021-09-10
### Added
- PowerShell 7 compatibility
- Support Account & Contact information
- Include release and issue links in `CHANGELOG.md`
- Release GitHub Action workflow

### Fixed
- Display issues with highlights in `README.md`

### Changed
- Update `README.md`
## [0.2.3] - 2021-06-04
### Added
* Improved verbose logging
## [0.2.2] - 2021-05-25

### Added
* Updated for compatibility with VxRail 7.x
* Improved verbose logging
## [0.2.1] - 2021-01-21

### Added
* GitHub Actions workflow for PSScriptAnalyzer
### Changed
* New module structure. Script split into private functions.
## [0.1.1] - 2021-01-15
### Added
* iDRAC user specifications
### Fixed
* Fix reporting of network pools when multiple pools exist
* Fix script errors when reporting on Available Hosts
## [0.1.0] - 2021-01-13

### Added
* VxRail cluster specifications
    * ESXi Host specifications
    * VxRail Cluster VM specifications
    * Installed VxRail component specifications
* VxRail appliance specifications
   * Hardware specifications
   * Firmware specifications
   * Boot Device specifications
   * Disk specifications
   * NIC specifications
   * iDRAC specifications
   * PSU specifications
   * ESXi specifications
* VxRail network specifications
   * General network specifications
   * Network pool specifications

