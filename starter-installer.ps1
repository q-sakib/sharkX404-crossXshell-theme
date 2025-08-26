# -----------------------------------------
# 🚀 FULLSTACK DEV STARTER INSTALLER
# -----------------------------------------

function Test-Command {
    param ($cmd)
    return (Get-Command $cmd -ErrorAction SilentlyContinue)
}

function Install-NpmIfMissing {
    param($pkg)
    if (-not (npm list -g --depth=0 | Select-String $pkg)) {
        Write-Host "➡ Installing npm package: $pkg" -ForegroundColor Yellow
        npm install -g $pkg
    } else {
        Write-Host "✅ npm package '$pkg' already installed." -ForegroundColor Gray
    }
}

Write-Host "`n📦 Installing essential tools..." -ForegroundColor Cyan

# --- GitHub CLI ---
if (-not (Test-Command gh)) {
    winget install --id GitHub.cli --accept-package-agreements --accept-source-agreements -e
} else {
    winget upgrade --id GitHub.cli --accept-package-agreements --accept-source-agreements -e
}

# --- Hugging Face CLI ---
if (-not (Test-Command huggingface-cli)) {
    pip install huggingface_hub
} else {
    pip install --upgrade huggingface_hub
}

# --- NVM for Windows ---
if (-not (Test-Command nvm)) {
    Write-Host "➡ Installing NVM for Node.js version control..." -ForegroundColor Yellow
    winget install CoreyButler.NVMforWindows --accept-package-agreements --accept-source-agreements -e
} else {
    Write-Host "✅ NVM already installed." -ForegroundColor Gray
}

# --- Node.js via winget ---
if (-not (Test-Command node)) {
    winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements -e
} else {
    Write-Host "✅ Node.js already installed." -ForegroundColor Gray
}

# --- Install npm global CLI tools ---
$npmCLIs = @(
    "live-server",
    "nodemon",
    "prettier",
    "eslint",
    "@githubnext/copilot-cli",
    "vercel",
    "firebase-tools",
    "heroku",
    "next",
    "@angular/cli"
)
foreach ($cli in $npmCLIs) {
    Install-NpmIfMissing $cli
}

# --- PHP, Composer, Laravel ---
if (-not (Test-Command php)) {
    winget install PHP.PHP --accept-package-agreements --accept-source-agreements -e
} else {
    Write-Host "✅ PHP already installed." -ForegroundColor Gray
}

if (-not (Test-Command composer)) {
    winget install Composer.Composer --accept-package-agreements --accept-source-agreements -e
} else {
    Write-Host "✅ Composer already installed." -ForegroundColor Gray
}

if (-not (Test-Command laravel)) {
    composer global require laravel/installer
    $env:Path += ";$env:APPDATA\Composer\vendor\bin"
    Write-Host "✅ Laravel installer added to path." -ForegroundColor Gray
} else {
    Write-Host "✅ Laravel already installed." -ForegroundColor Gray
}

# --- Docker ---
if (-not (Test-Command docker)) {
    winget install Docker.DockerDesktop --accept-package-agreements --accept-source-agreements -e
} else {
    Write-Host "✅ Docker already installed." -ForegroundColor Gray
}

# --- PostgreSQL / MySQL / MongoDB Selection ---
Write-Host "`n🗄️ Choose a database to install (enter number):" -ForegroundColor Cyan
Write-Host "1. PostgreSQL"
Write-Host "2. MySQL"
Write-Host "3. MongoDB"
Write-Host "4. None"
$selection = Read-Host "Select [1/2/3/4]"

switch ($selection) {
    '1' {
        if (-not (Test-Command psql)) {
            winget install PostgreSQL.PostgreSQL --accept-package-agreements --accept-source-agreements -e
        } else {
            Write-Host "✅ PostgreSQL already installed." -ForegroundColor Gray
        }
    }
    '2' {
        if (-not (Test-Command mysql)) {
            winget install Oracle.MySQL --accept-package-agreements --accept-source-agreements -e
        } else {
            Write-Host "✅ MySQL already installed." -ForegroundColor Gray
        }
    }
    '3' {
        if (-not (Test-Command mongod)) {
            winget install MongoDB.MongoDBCommunity --accept-package-agreements --accept-source-agreements -e
        } else {
            Write-Host "✅ MongoDB already installed." -ForegroundColor Gray
        }
    }
    '4' {
        Write-Host "🚫 Skipping database install." -ForegroundColor Yellow
    }
    Default {
        Write-Host "⚠️ Invalid selection. No database installed." -ForegroundColor Red
    }
}

# --- PowerShell Modules ---
$psModules = @("PSReadLine", "Terminal-Icons", "posh-git", "z")
foreach ($mod in $psModules) {
    if (-not (Get-Module -ListAvailable -Name $mod)) {
        Install-Module $mod -Force -Scope CurrentUser
    } else {
        Write-Host "✅ PowerShell module '$mod' already installed." -ForegroundColor Gray
    }
}

# --- Oh My Posh ---
if (-not (Test-Command oh-my-posh)) {
    winget install JanDeDobbeleer.OhMyPosh --accept-package-agreements --accept-source-agreements -e
} else {
    Write-Host "✅ Oh My Posh already installed." -ForegroundColor Gray
}

# --- Extras ---
if (-not (Test-Command tldr)) {
    winget install tldr-pages.tldr --accept-package-agreements --accept-source-agreements -e
}
if (-not (Test-Command http)) {
    winget install httpie --accept-package-agreements --accept-source-agreements -e
}
if (-not (Test-Command fzf)) {
    winget install fzf --accept-package-agreements --accept-source-agreements -e
}

# ✅ Done
Write-Host "`n✅ All tools installed and up to date!" -ForegroundColor Green
Write-Host "🧩 You can now run your full PowerShell setup script." -ForegroundColor Cyan
