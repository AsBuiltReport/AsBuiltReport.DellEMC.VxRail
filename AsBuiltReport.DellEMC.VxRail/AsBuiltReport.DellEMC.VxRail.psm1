# Dot-source all Public and Private function files
foreach ($Folder in @('Public', 'Private')) {
    $FolderPath = Join-Path -Path $PSScriptRoot -ChildPath 'Src' | Join-Path -ChildPath $Folder
    if (Test-Path -Path $FolderPath) {
        Get-ChildItem -Path $FolderPath -Filter '*.ps1' -Recurse | ForEach-Object {
            try {
                . $_.FullName
            } catch {
                Write-Warning -Message "Failed to import function $($_.FullName): $_"
            }
        }
    }
}

# FunctionsToExport in the module manifest is the sole authority on what is publicly exported.
