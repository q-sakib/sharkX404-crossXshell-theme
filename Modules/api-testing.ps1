# -----------------------------------------
# API Helpers (httpie + Invoke-RestMethod)
# -----------------------------------------

function api-get {
    <#
    .SYNOPSIS
    Makes a GET request to a given URL and returns the parsed JSON response.
    #>
    param([string]$url)

    if (-not $url) {
        Write-Host "Usage: api-get <URL>" -ForegroundColor Red
        return
    }

    Invoke-RestMethod -Uri $url -Method Get |
        ConvertTo-Json -Depth 10
}

function api-post {
    <#
    .SYNOPSIS
    Sends a POST request with a JSON payload.
    #>
    param(
        [string]$url,
        [hashtable]$body
    )

    if (-not $url -or -not $body) {
        Write-Host "Usage: api-post <URL> <HashtableBody>" -ForegroundColor Red
        return
    }

    Invoke-RestMethod -Uri $url -Method Post `
        -Body ($body | ConvertTo-Json -Depth 10) `
        -ContentType "application/json" |
        ConvertTo-Json -Depth 10
}

function api {
    <#
    .SYNOPSIS
    Makes API requests using httpie (if installed),
    or PowerShell Invoke-RestMethod fallback.
    #>

    # Preferred: httpie
    if (Get-Command http -ErrorAction SilentlyContinue) {
        http @args
        return
    }

    Write-Host "⚠️ 'httpie' not found. Falling back to Invoke-RestMethod." -ForegroundColor Yellow

    if ($args.Count -lt 2) {
        Write-Host "Usage: api <METHOD> <URL> [JSON-BODY]" -ForegroundColor Red
        return
    }

    $method = $args[0].ToUpper()
    $url    = $args[1]
    $body   = if ($args.Count -gt 2) {
        ($args[2..($args.Count - 1)] -join " ")
    } else { $null }

    try {
        $response = switch ($method) {
            'GET'    { Invoke-RestMethod -Uri $url -Method Get }
            'POST'   { Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json" }
            'PUT'    { Invoke-RestMethod -Uri $url -Method Put -Body $body -ContentType "application/json" }
            'DELETE' { Invoke-RestMethod -Uri $url -Method Delete }
            default  { throw "Unsupported HTTP method: $method" }
        }

        $response | ConvertTo-Json -Depth 10
    }
    catch {
        Write-Host "❌ Request failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}
