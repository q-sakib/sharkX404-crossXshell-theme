# Dev Tools & Utilities
function ff { fd $args }
function grep { rg $args }
function preview { bat $args }
function myip { Invoke-RestMethod -Uri "https://ipinfo.io/json" }
function open-url { param($url) Start-Process $url }
function edit-env { code .env }
function edit-config { code .vscode/settings.json }

# .env Loader
function load-env {
    if (Test-Path ".env") {
        Get-Content .env | ForEach-Object {
            if ($_ -match "^\\s*#") { return }
            $parts = $_ -split "=", 2
            if ($parts.Length -eq 2) {
                [System.Environment]::SetEnvironmentVariable($parts[0].Trim(), $parts[1].Trim(), "Process")
            }
        }
        Write-Host ".env loaded." -ForegroundColor Green
    }
}

function edit-env { code .env }
function edit-config { code .vscode/settings.json }

function myip { Invoke-RestMethod -Uri "https://ipinfo.io/json" }
function open-url { param($url) Start-Process $url }
