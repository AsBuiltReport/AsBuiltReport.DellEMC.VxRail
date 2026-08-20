#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

# Discovery-time enumeration for -ForEach test cases only. Every BeforeAll/It below
# recomputes its own paths from $PSScriptRoot, since values set here are not
# guaranteed to be visible inside Run-phase blocks.
$ReportFunctionFiles = Get-ChildItem -Path (Join-Path $PSScriptRoot '..\AsBuiltReport.DellEMC.VxRail\Src\Private') -Filter '*.ps1' |
    Where-Object { $_.BaseName -match '^Get-AbrVxRail' }

BeforeAll {
    $ModuleName = 'AsBuiltReport.DellEMC.VxRail'
    $ModuleRoot = Split-Path -Path $PSScriptRoot -Parent
    $ModulePath = Join-Path -Path $ModuleRoot -ChildPath $ModuleName
    $ManifestPath = Join-Path -Path $ModulePath -ChildPath "$ModuleName.psd1"

    # Requires AsBuiltReport.Core to be installed
    Import-Module AsBuiltReport.Core -ErrorAction Stop
    Import-Module $ManifestPath -Force -ErrorAction Stop
}

Describe 'Module Manifest' {
    BeforeAll {
        $ModuleName = 'AsBuiltReport.DellEMC.VxRail'
        $ModuleRoot = Split-Path -Path $PSScriptRoot -Parent
        $ModulePath = Join-Path -Path $ModuleRoot -ChildPath $ModuleName
        $ManifestPath = Join-Path -Path $ModulePath -ChildPath "$ModuleName.psd1"
        $Manifest = Test-ModuleManifest -Path $ManifestPath -ErrorAction Stop -WarningAction SilentlyContinue
    }

    It 'Has a valid manifest' {
        $Manifest | Should -Not -BeNullOrEmpty
    }

    It 'Has the correct module name' {
        $Manifest.Name | Should -Be $ModuleName
    }

    It 'Has a semantic module version' {
        { [Version] $Manifest.Version } | Should -Not -Throw
    }

    It 'Declares AsBuiltReport.Core as a required module' {
        $Manifest.RequiredModules.Name | Should -Contain 'AsBuiltReport.Core'
    }

    It 'Declares a minimum PowerShell version' {
        $Manifest.PowerShellVersion | Should -Not -BeNullOrEmpty
    }

    It 'Declares compatible PSEditions' {
        $Manifest.CompatiblePSEditions | Should -Not -BeNullOrEmpty
    }
}

Describe 'Public Functions' {
    BeforeAll {
        $ModuleName = 'AsBuiltReport.DellEMC.VxRail'
        $ModuleRoot = Split-Path -Path $PSScriptRoot -Parent
        $PublicPath = Join-Path -Path $ModuleRoot -ChildPath "$ModuleName\Src\Public"
    }

    It 'Exports Invoke-AsBuiltReport.DellEMC.VxRail' {
        $Commands = @(Get-Command -Module $ModuleName)
        $Commands.Name | Should -Contain 'Invoke-AsBuiltReport.DellEMC.VxRail'
    }

    It 'Exports only the public Invoke function' {
        $Commands = @(Get-Command -Module $ModuleName)
        $Commands.Name.Count | Should -Be 1
    }

    It 'Has comment-based help with SYNOPSIS, DESCRIPTION, PARAMETER and EXAMPLE' {
        $Content = Get-Content -Path (Join-Path $PublicPath 'Invoke-AsBuiltReport.DellEMC.VxRail.ps1') -Raw
        $Content | Should -Match '\.SYNOPSIS'
        $Content | Should -Match '\.DESCRIPTION'
        $Content | Should -Match '\.PARAMETER'
        $Content | Should -Match '\.EXAMPLE'
    }
}

Describe 'Module Structure' {
    BeforeAll {
        $ModuleName = 'AsBuiltReport.DellEMC.VxRail'
        $ModuleRoot = Split-Path -Path $PSScriptRoot -Parent
        $ModulePath = Join-Path -Path $ModuleRoot -ChildPath $ModuleName
    }

    It 'Has a Src\Public directory' {
        Join-Path $ModulePath 'Src\Public' | Should -Exist
    }

    It 'Has a Src\Private directory' {
        Join-Path $ModulePath 'Src\Private' | Should -Exist
    }

    It 'Has a Language\en-US directory' {
        Join-Path $ModulePath 'Language\en-US' | Should -Exist
    }

    It 'Has a Tests directory' {
        $PSScriptRoot | Should -Exist
    }
}

Describe 'Private Functions' -ForEach $ReportFunctionFiles {
    BeforeAll {
        $Content = Get-Content -Path $_.FullName -Raw
    }

    It "<_.BaseName>: filename matches the function it defines" {
        ($Content -cmatch "function\s+$([regex]::Escape($_.BaseName))\s*\{") | Should -BeTrue
    }

    It "<_.BaseName>: has comment-based help" {
        $Content | Should -Match '\.SYNOPSIS'
    }

    It "<_.BaseName>: declares `$LocalizedData in its begin block" {
        $Content | Should -Match '\$LocalizedData\s*=\s*\$reportTranslate\.'
    }

    It "<_.BaseName>: uses begin/process/end blocks" {
        $Content | Should -Match 'begin\s*\{'
        $Content | Should -Match 'process\s*\{'
    }
}

Describe 'JSON Configuration' {
    BeforeAll {
        $ModuleName = 'AsBuiltReport.DellEMC.VxRail'
        $ModuleRoot = Split-Path -Path $PSScriptRoot -Parent
        $ModulePath = Join-Path -Path $ModuleRoot -ChildPath $ModuleName
        $JsonConfigPath = Join-Path -Path $ModulePath -ChildPath "$ModuleName.json"
        $Config = Get-Content -Path $JsonConfigPath -Raw | ConvertFrom-Json
    }

    It 'Exists and is valid JSON' {
        $Config | Should -Not -BeNullOrEmpty
    }

    It 'Has a Report section' {
        $Config.Report | Should -Not -BeNullOrEmpty
    }

    It 'Declares a Report.Language value' {
        $Config.Report.Language | Should -Not -BeNullOrEmpty
    }

    It 'Has an InfoLevel section' {
        $Config.InfoLevel | Should -Not -BeNullOrEmpty
    }

    It 'Has InfoLevel values within the documented 0-5 range' {
        $InfoLevelValues = $Config.InfoLevel.PSObject.Properties |
            Where-Object Name -ne '_comment_' |
            ForEach-Object Value
        foreach ($Value in $InfoLevelValues) {
            $Value | Should -BeGreaterOrEqual 0
            $Value | Should -BeLessOrEqual 5
        }
    }

    It 'Has a HealthCheck section with boolean leaf values' {
        function Test-BooleanLeaf ($InputObject) {
            foreach ($Property in $InputObject.PSObject.Properties) {
                if ($Property.Value -is [System.Management.Automation.PSCustomObject]) {
                    Test-BooleanLeaf -InputObject $Property.Value
                } else {
                    $Property.Value | Should -BeOfType [bool]
                }
            }
        }
        Test-BooleanLeaf -InputObject $Config.HealthCheck
    }
}

Describe 'Code Quality' {
    BeforeAll {
        $ModuleName = 'AsBuiltReport.DellEMC.VxRail'
        $ModuleRoot = Split-Path -Path $PSScriptRoot -Parent
        $ModulePath = Join-Path -Path $ModuleRoot -ChildPath $ModuleName
    }

    It 'Passes PSScriptAnalyzer with no errors' {
        if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
            Set-ItResult -Skipped -Because 'PSScriptAnalyzer is not installed'
            return
        }
        $SettingsPath = Join-Path -Path $ModuleRoot -ChildPath '.github\workflows\PSScriptAnalyzerSettings.psd1'
        $Results = Invoke-ScriptAnalyzer -Path $ModulePath -Recurse -Settings $SettingsPath -Severity Error
        $Results | Should -BeNullOrEmpty
    }
}
