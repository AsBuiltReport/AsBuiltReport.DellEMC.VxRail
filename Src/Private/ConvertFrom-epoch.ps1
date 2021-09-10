Function ConvertFrom-epoch {
    <#
    .Synopsis
    Convert from epoch time to human
    .Description
    Convert from epoch time to human
    .Example
    ConvertFrom-epoch 1295113860
    #>
    [CmdletBinding()]
    param ([Parameter(ValueFromPipeline = $true)]$epochdate)

    begin {
    }

    process {
        if (!$psboundparameters.count) { help -ex convertFrom-epoch | Out-String | Remove-EmptyLines; return }
        if (("$epochdate").length -gt 10 ) { (Get-Date -Date "01/01/1970").AddMilliseconds($epochdate) }
        else { (Get-Date -Date "01/01/1970").AddSeconds($epochdate) }
    }

    end {
    }

}