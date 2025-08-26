function api-get {
    <#
    .SYNOPSIS
    Makes a GET request to a given URL and returns the parsed JSON response.

    .PARAMETER url
    The full URL to send the GET request to.

    .EXAMPLE
    api-get "https://jsonplaceholder.typicode.com/posts/1"
    #>
    param([string]$url)
    Invoke-RestMethod -Uri $url -Method Get | ConvertTo-Json -Depth 10
}

function api-post {
    <#
    .SYNOPSIS
    Sends a POST request with a JSON payload.

    .PARAMETER url
    The endpoint URL.

    .PARAMETER body
    A hashtable representing the JSON payload.

    .EXAMPLE
    $body = @{ title = "Test"; body = "Something"; userId = 1 }
    api-post "https://jsonplaceholder.typicode.com/posts" $body
    #>
    param([string]$url, [hashtable]$body)
    Invoke-RestMethod -Uri $url -Method Post `
        -Body ($body | ConvertTo-Json -Depth 10) `
        -ContentType "application/json" |
        ConvertTo-Json -Depth 10
}





function api {
    <#
    .SYNOPSIS
    Makes API requests using httpie (if installed), or PowerShell's Invoke-RestMethod fallback.

    .EXAMPLE
    api GET https://example.com/posts
    api POST https://api.site.com/data '{ "name": "test" }'
    #>
    if (Get-Command http -ErrorAction SilentlyContinue) {
        http @args
        return
    }

    Write-Host "⚠️ 'httpie' is not installed. Using built-in Invoke-RestMethod..." -ForegroundColor Yellow

    $method = $args[0].ToUpper()
    $url    = $args[1]
    $body   = ($args.Count -gt 2) ? ($args[2..($args.Count - 1)] -join " ") : $null

    if (-not $method -or -not $url) {
        Write-Host "Usage: api <METHOD> <URL> [JSON-BODY]" -ForegroundColor Red
        return
    }

    try {
        $response = switch ($method) {
            'GET'    { Invoke-RestMethod -Uri $url -Method Get }
            'POST'   { Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json" }
            'PUT'    { Invoke-RestMethod -Uri $url -Method Put -Body $body -ContentType "application/json" }
            'DELETE' { Invoke-RestMethod -Uri $url -Method Delete }
            default  { throw "Unsupported HTTP method: $method" }
        }

        $response | ConvertTo-Json -Depth 10
    } catch {
        Write-Host "❌ Request failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}
