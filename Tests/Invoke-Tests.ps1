<#
.SYNOPSIS
    Invoke Pester tests for the AsBuiltReport.DellEMC.VxRail module

.DESCRIPTION
    This script runs Pester tests with optional code coverage analysis.
    It's designed to work with CI/CD pipelines and local development.

.PARAMETER CodeCoverage
    Enable code coverage analysis

.PARAMETER OutputFormat
    Specify the output format for test results (Console, NUnitXml, JUnitXml)

.EXAMPLE
    .\Invoke-Tests.ps1

.EXAMPLE
    .\Invoke-Tests.ps1 -CodeCoverage -OutputFormat NUnitXml
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$CodeCoverage,

    [Parameter(Mandatory = $false)]
    [ValidateSet('Console', 'NUnitXml', 'JUnitXml')]
    [string]$OutputFormat = 'Console'
)

# Ensure we're in the Tests directory
$TestsPath = $PSScriptRoot
if (-not (Test-Path $TestsPath)) {
    Write-Error "Tests directory not found at: $TestsPath"
    exit 1
}

# Get the module root directory
$ModuleRoot = Split-Path -Path $TestsPath -Parent
$ModuleName = 'AsBuiltReport.DellEMC.VxRail'
$ModulePath = Join-Path -Path $ModuleRoot -ChildPath $ModuleName

Write-Host "Module Root: $ModuleRoot" -ForegroundColor Cyan
Write-Host "Module Path: $ModulePath" -ForegroundColor Cyan
Write-Host "Tests Path: $TestsPath" -ForegroundColor Cyan

# Check PowerShell version
$PSVersion = $PSVersionTable.PSVersion
Write-Host "PowerShell Version: $PSVersion" -ForegroundColor Cyan

if ($PSVersion.Major -lt 7) {
    Write-Warning "PowerShell 7 or higher is recommended for optimal test execution"
}

# Remove any pre-loaded Pester module (Windows PowerShell 5.1 ships with old Pester 3.4.0,
# which can otherwise shadow-conflict with the version installed above)
Get-Module Pester | Remove-Module -Force -ErrorAction SilentlyContinue

# Import Pester with explicit minimum version
Import-Module Pester -MinimumVersion 5.0.0 -Force -ErrorAction Stop

# Configure Pester
$PesterConfiguration = New-PesterConfiguration

# Run settings
$PesterConfiguration.Run.Path = $TestsPath
$PesterConfiguration.Run.Exit = $false
$PesterConfiguration.Run.PassThru = $true

# Output settings
$PesterConfiguration.Output.Verbosity = 'Detailed'

# TestResult settings
if ($OutputFormat -ne 'Console') {
    $PesterConfiguration.TestResult.Enabled = $true
    $ResultFile = Join-Path -Path $TestsPath -ChildPath 'testResults.xml'
    $PesterConfiguration.TestResult.OutputPath = $ResultFile
    $PesterConfiguration.TestResult.OutputFormat = $OutputFormat

    Write-Host "Test results will be saved to: $ResultFile" -ForegroundColor Cyan
}

# Code Coverage settings
if ($CodeCoverage) {
    Write-Host "`nEnabling code coverage analysis..." -ForegroundColor Yellow

    $PesterConfiguration.CodeCoverage.Enabled = $true
    $PesterConfiguration.CodeCoverage.OutputFormat = 'JaCoCo'
    $CoverageFile = Join-Path -Path $TestsPath -ChildPath 'coverage.xml'
    $PesterConfiguration.CodeCoverage.OutputPath = $CoverageFile

    # Include all PowerShell files in the module
    $CoverageFiles = @(
        (Join-Path -Path $ModulePath -ChildPath '*.psm1')
        (Join-Path -Path $ModulePath -ChildPath 'Src' | Join-Path -ChildPath 'Public' | Join-Path -ChildPath '*.ps1')
        (Join-Path -Path $ModulePath -ChildPath 'Src' | Join-Path -ChildPath 'Private' | Join-Path -ChildPath '*.ps1')
    )

    $PesterConfiguration.CodeCoverage.Path = $CoverageFiles

    Write-Host "Code coverage will be saved to: $CoverageFile" -ForegroundColor Cyan
    Write-Host "Coverage files included:" -ForegroundColor Cyan
    foreach ($File in $CoverageFiles) {
        Write-Host "  - $File" -ForegroundColor Gray
    }
}

# Run Pester tests
Write-Host "`nRunning Pester tests..." -ForegroundColor Yellow
Write-Host "======================================" -ForegroundColor Cyan

$TestResults = Invoke-Pester -Configuration $PesterConfiguration

# Display results
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "Test Results Summary" -ForegroundColor Yellow
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Total Tests: $($TestResults.TotalCount)" -ForegroundColor White
Write-Host "Passed: $($TestResults.PassedCount)" -ForegroundColor Green
Write-Host "Failed: $($TestResults.FailedCount)" -ForegroundColor $(if ($TestResults.FailedCount -gt 0) { 'Red' } else { 'Green' })
Write-Host "Skipped: $($TestResults.SkippedCount)" -ForegroundColor Yellow
Write-Host "Duration: $($TestResults.Duration)" -ForegroundColor White

# Display failed tests
if ($TestResults.FailedCount -gt 0) {
    Write-Host "`nFailed Tests:" -ForegroundColor Red
    foreach ($FailedTest in $TestResults.Failed) {
        Write-Host "  - $($FailedTest.Name)" -ForegroundColor Red
        Write-Host "    $($FailedTest.ErrorRecord)" -ForegroundColor Gray
    }
}

# Display code coverage summary
if ($CodeCoverage -and $TestResults.CodeCoverage) {
    Write-Host "`n======================================" -ForegroundColor Cyan
    Write-Host "Code Coverage Summary" -ForegroundColor Yellow
    Write-Host "======================================" -ForegroundColor Cyan

    # Pester 5's CodeCoverage result exposes CommandsAnalyzedCount / CommandsExecutedCount /
    # CommandsMissedCount and a pre-computed CoveragePercent - not the Number-Of-* names this
    # used previously, which don't exist on the object and silently returned $null.
    $Coverage = $TestResults.CodeCoverage
    $CoveragePercent = [math]::Round($Coverage.CoveragePercent, 2)

    Write-Host "Commands Analyzed: $($Coverage.CommandsAnalyzedCount)" -ForegroundColor White
    Write-Host "Commands Executed: $($Coverage.CommandsExecutedCount)" -ForegroundColor White
    Write-Host "Commands Missed: $($Coverage.CommandsMissedCount)" -ForegroundColor White
    Write-Host "Coverage: $CoveragePercent%" -ForegroundColor $(if ($CoveragePercent -ge 80) { 'Green' } elseif ($CoveragePercent -ge 60) { 'Yellow' } else { 'Red' })
}

Write-Host "`n======================================" -ForegroundColor Cyan

# Exit with appropriate code
if ($TestResults.FailedCount -gt 0) {
    Write-Host "Tests FAILED" -ForegroundColor Red
    exit 1
} else {
    Write-Host "All tests PASSED" -ForegroundColor Green
    exit 0
}
