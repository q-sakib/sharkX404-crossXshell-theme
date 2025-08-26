function try-run {
    param($cmd)
    try {
        Invoke-Expression $cmd
    } catch {
        Write-Host "⚠️ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}
