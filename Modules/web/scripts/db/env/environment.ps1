function validate-env {
    $required = @("PORT", "JWT_SECRET", "MONGO_URI", "DATABASE_URL")
    $envFile = ".env"

    if (-not (Test-Path $envFile)) {
        Write-Warning ".env file not found"
        return
    }

    $contents = Get-Content $envFile
    $foundKeys = @{}

    foreach ($line in $contents) {
        if ($line -match "^([^#=]+)=") {
            $foundKeys[$matches[1].Trim()] = $true
        }
    }

    foreach ($key in $required) {
        if (-not $foundKeys.ContainsKey($key)) {
            Write-Warning "Missing key: $key"
        }
    }

    Write-Host "✅ .env validation complete"
}
