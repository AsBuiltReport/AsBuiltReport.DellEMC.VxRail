function ConvertFrom-Epoch {
    <#
    .SYNOPSIS
    Used by As Built Report to convert Unix epoch time to a [DateTime] object
    .DESCRIPTION
    Converts a Unix epoch timestamp, in either seconds or milliseconds, to a [DateTime] object.
    .PARAMETER EpochDate
    The Unix epoch timestamp to convert, in seconds or milliseconds.
    .NOTES
        Version:        0.2.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
    .EXAMPLE
    ConvertFrom-Epoch 1295113860
    .LINK
    https://github.com/AsBuiltReport/AsBuiltReport.DellEMC.VxRail
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $EpochDate
    )

    process {
        if ($EpochDate.Length -gt 10) {
            (Get-Date -Date '01/01/1970').AddMilliseconds($EpochDate)
        } else {
            (Get-Date -Date '01/01/1970').AddSeconds($EpochDate)
        }
    }
}
