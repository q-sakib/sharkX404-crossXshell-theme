function bench {
    param([scriptblock]$script)
    $result = Measure-Command $script
    Write-Host ("{0:N3}s" -f $result.TotalSeconds) -ForegroundColor Cyan
}
