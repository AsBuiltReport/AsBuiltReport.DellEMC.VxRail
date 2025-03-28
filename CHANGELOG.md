# :arrows_clockwise: Dell EMC VxRail As Built Report Changelog

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

