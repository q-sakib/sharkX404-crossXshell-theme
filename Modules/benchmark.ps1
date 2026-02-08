function bench {
    param([scriptblock]$script)
    Measure-Command $script
}
function bench-run {
    <#
    .SYNOPSIS
    Runs a scriptblock multiple times and reports timing statistics.
    #>
    param(
        [Parameter(Mandatory)]
        [scriptblock]$Script,

        [int]$Iterations = 10,

        [switch]$Quiet
    )

    $results = @()

    for ($i = 1; $i -le $Iterations; $i++) {
        $time = Measure-Command $Script
        $results += $time.TotalMilliseconds
    }

    $stats = [PSCustomObject]@{
        Iterations = $Iterations
        MinMs      = ($results | Measure-Object -Minimum).Minimum
        MaxMs      = ($results | Measure-Object -Maximum).Maximum
        AvgMs      = ($results | Measure-Object -Average).Average
        TotalMs    = ($results | Measure-Object -Sum).Sum
    }

    if (-not $Quiet) {
        $stats | Format-Table -AutoSize
    }

    return $stats
}
function bench-compare {
    <#
    .SYNOPSIS
    Compares performance of two scriptblocks.
    #>
    param(
        [scriptblock]$A,
        [scriptblock]$B,
        [int]$Iterations = 10
    )

    Write-Host "`n🔬 Benchmark A" -ForegroundColor Cyan
    $aStats = bench-run -Script $A -Iterations $Iterations -Quiet

    Write-Host "`n🔬 Benchmark B" -ForegroundColor Cyan
    $bStats = bench-run -Script $B -Iterations $Iterations -Quiet

    $delta = $aStats.AvgMs - $bStats.AvgMs

    [PSCustomObject]@{
        A_AvgMs   = $aStats.AvgMs
        B_AvgMs   = $bStats.AvgMs
        Faster    = if ($delta -gt 0) { 'B' } else { 'A' }
        DeltaMs   = [math]::Abs($delta)
    } | Format-Table -AutoSize
}
function bench-profile {
    <#
    .SYNOPSIS
    High-precision benchmark using Stopwatch.
    #>
    param(
        [Parameter(Mandatory)]
        [scriptblock]$Script,
        [int]$Iterations = 100
    )

    $sw = [System.Diagnostics.Stopwatch]::StartNew()

    for ($i = 0; $i -lt $Iterations; $i++) {
        & $Script
    }

    $sw.Stop()

    [PSCustomObject]@{
        Iterations = $Iterations
        TotalMs   = $sw.Elapsed.TotalMilliseconds
        AvgMs     = $sw.Elapsed.TotalMilliseconds / $Iterations
    } | Format-Table -AutoSize
}
bench { Get-ChildItem }

bench-run { Get-Process } -Iterations 20

bench-compare `
    { Get-ChildItem -Recurse } `
    { ls -R }

bench-profile { 1..1000 | % { $_ * 2 } } -Iterations 500
Export-ModuleMember -Function `
    bench, bench-run, bench-compare, bench-profile
