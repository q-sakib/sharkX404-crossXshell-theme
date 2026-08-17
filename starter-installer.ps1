# ---------------------------------------------------------------------
# 🚀 FULLSTACK DEV STARTER INSTALLER (Cross-Platform: macOS & Windows)
# ---------------------------------------------------------------------

function Test-Command {
    param ($cmd)
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

function Install-NpmIfMissing {
    param($pkg)
    if (Test-Command npm) {
        if (-not (npm list -g --depth=0 2>$null | Select-String $pkg)) {
            Write-Host "➡ Installing npm package: $pkg" -ForegroundColor Yellow
            npm install -g $pkg
        } else {
            Write-Host "✅ npm package '$pkg' already installed." -ForegroundColor Gray
        }
    }
}

$isMac = $IsMacOS -or $IsLinux -or ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::OSX))

Write-Host "`n📦 Bootstrapping fullstack development tools ($($if ($isMac) { 'macOS' } else { 'Windows' }))..." -ForegroundColor Cyan

if ($isMac) {
    # 🍎 macOS Homebrew Installation Pathway
    if (-not (Test-Command brew)) {
        Write-Host "➡ Installing Homebrew..." -ForegroundColor Yellow
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    }

    $brewPackages = @(
        @{ Cmd = "gh";          Pkg = "gh" },
        @{ Cmd = "eza";         Pkg = "eza" },
        @{ Cmd = "oh-my-posh";  Pkg = "jandedobbeleer/oh-my-posh/oh-my-posh" },
        @{ Cmd = "fzf";         Pkg = "fzf" },
        @{ Cmd = "tldr";        Pkg = "tldr" },
        @{ Cmd = "http";        Pkg = "httpie" },
        @{ Cmd = "node";        Pkg = "node" },
        @{ Cmd = "nvm";         Pkg = "nvm" },
        @{ Cmd = "php";         Pkg = "php" },
        @{ Cmd = "composer";    Pkg = "composer" }
    )

    foreach ($item in $brewPackages) {
        if (-not (Test-Command $item.Cmd)) {
            Write-Host "➡ Installing $($item.Pkg) via brew..." -ForegroundColor Yellow
            brew install $item.Pkg
        } else {
            Write-Host "✅ Command '$($item.Cmd)' already installed." -ForegroundColor Gray
        }
    }
} else {
    # 🪟 Windows Winget Installation Pathway
    $wingetPackages = @(
        @{ Cmd = "gh";          Id = "GitHub.cli" },
        @{ Cmd = "node";        Id = "OpenJS.NodeJS.LTS" },
        @{ Cmd = "php";         Id = "PHP.PHP" },
        @{ Cmd = "composer";    Id = "Composer.Composer" },
        @{ Cmd = "docker";      Id = "Docker.DockerDesktop" },
        @{ Cmd = "eza";         Id = "eza-community.eza" },
        @{ Cmd = "oh-my-posh";  Id = "JanDeDobbeleer.OhMyPosh" },
        @{ Cmd = "tldr";        Id = "tldr-pages.tldr" },
        @{ Cmd = "http";        Id = "httpie" },
        @{ Cmd = "fzf";         Id = "fzf" }
    )

    foreach ($item in $wingetPackages) {
        if (-not (Test-Command $item.Cmd)) {
            Write-Host "➡ Installing $($item.Id) via winget..." -ForegroundColor Yellow
            winget install --id $item.Id --accept-package-agreements --accept-source-agreements -e
        } else {
            Write-Host "✅ Command '$($item.Cmd)' already installed." -ForegroundColor Gray
        }
    }
}

# --- Hugging Face CLI ---
if (-not (Test-Command huggingface-cli)) {
    if (Test-Command pip3) { pip3 install huggingface_hub }
    elseif (Test-Command pip) { pip install huggingface_hub }
}

# --- Global NPM CLI Tools ---
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

# --- Laravel Installer ---
if (Test-Command composer -and -not (Test-Command laravel)) {
    composer global require laravel/installer
}

# --- PowerShell Modules ---
$psModules = @("PSReadLine", "posh-git", "z")
foreach ($mod in $psModules) {
    if (-not (Get-Module -ListAvailable -Name $mod)) {
        Write-Host "➡ Installing PowerShell module '$mod'..." -ForegroundColor Yellow
        Install-Module $mod -Force -Scope CurrentUser -ErrorAction SilentlyContinue
    } else {
        Write-Host "✅ PowerShell module '$mod' already installed." -ForegroundColor Gray
    }
}

Write-Host "`n✅ Fullstack environment installation check complete!" -ForegroundColor Green
Write-Host "🧩 Run './setup-profile.ps1' to automatically link your profile." -ForegroundColor Cyan
