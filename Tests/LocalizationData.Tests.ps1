#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

# Discovery-time enumeration for -ForEach test cases only. Every BeforeAll/It below
# recomputes its own paths from $PSScriptRoot, since values set here are not
# guaranteed to be visible inside Run-phase blocks.
$LanguageFiles = Get-ChildItem -Path (Join-Path $PSScriptRoot '..\AsBuiltReport.DellEMC.VxRail\Language') -Recurse -Filter '*.psd1'
$NonReferenceCultures = ($LanguageFiles | ForEach-Object { $_.Directory.Name } | Sort-Object -Unique) | Where-Object { $_ -ne 'en-US' }
$ReportFunctionFiles = Get-ChildItem -Path (Join-Path $PSScriptRoot '..\AsBuiltReport.DellEMC.VxRail\Src\Private') -Filter '*.ps1' |
    Where-Object { $_.BaseName -match '^Get-AbrVxRail' }

Describe 'Localization Files' {
    BeforeAll {
        $LanguagePath = Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath 'AsBuiltReport.DellEMC.VxRail\Language'
    }

    It 'Has at least an en-US language file' {
        Join-Path $LanguagePath 'en-US' | Should -Exist
    }

    It "<_.FullName>: starts with a culture comment" -ForEach $LanguageFiles {
        (Get-Content -Path $_.FullName -TotalCount 1) | Should -Match "^#\s*culture\s*="
    }

    It "<_.FullName>: parses as valid PowerShell data" -ForEach $LanguageFiles {
        { Invoke-Expression (Get-Content -Path $_.FullName -Raw) } | Should -Not -Throw
    }
}

Describe 'Localization Key Parity' {
    BeforeAll {
        $LanguagePath = Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath 'AsBuiltReport.DellEMC.VxRail\Language'
        $EnUsPath = Join-Path -Path $LanguagePath -ChildPath 'en-US\DellEMCVxRail.psd1'
        $EnUsData = Invoke-Expression (Get-Content -Path $EnUsPath -Raw)
    }

    It 'en-US language file defines at least one function block' {
        $EnUsData.Keys.Count | Should -BeGreaterThan 0
    }

    It "<_>: has the same function blocks and keys as en-US" -ForEach $NonReferenceCultures {
        $CulturePath = Join-Path -Path $LanguagePath -ChildPath "$_\DellEMCVxRail.psd1"
        $CultureData = Invoke-Expression (Get-Content -Path $CulturePath -Raw)

        $CultureData.Keys.Count | Should -Be $EnUsData.Keys.Count -Because 'both cultures should define the same set of function blocks'

        foreach ($Block in $EnUsData.Keys) {
            $CultureData.ContainsKey($Block) | Should -BeTrue -Because "en-US defines block '$Block'"

            $KeyDiff = Compare-Object -ReferenceObject ($EnUsData[$Block].Keys | Sort-Object) -DifferenceObject ($CultureData[$Block].Keys | Sort-Object)
            $KeyDiff | Should -BeNullOrEmpty -Because "block '$Block' should have identical keys to en-US"
        }
    }
}

Describe 'Localization Coverage' {
    BeforeAll {
        $LanguagePath = Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath 'AsBuiltReport.DellEMC.VxRail\Language'
        $EnUsPath = Join-Path -Path $LanguagePath -ChildPath 'en-US\DellEMCVxRail.psd1'
        $EnUsData = Invoke-Expression (Get-Content -Path $EnUsPath -Raw)
    }

    It "<_.BaseName>: has a matching en-US language block" -ForEach $ReportFunctionFiles {
        $BlockName = $_.BaseName -replace '-', ''
        $EnUsData.ContainsKey($BlockName) | Should -BeTrue
    }
}
