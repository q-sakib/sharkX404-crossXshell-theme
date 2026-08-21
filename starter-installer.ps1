#Requires -Version 7.0
# =====================================================================
# ⚡ sharkX404 CrossShell Theme — Fullstack Dev Starter Installer
# Cross-Platform: Windows 11 (winget) + macOS (Homebrew)
# Run as Administrator on Windows for Docker Desktop & symlink support.
# =====================================================================

# ── Admin check (Windows only) ───────────────────────────────────────
if ($IsWindows) {
    $currentPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Warning "⚠️  Not running as Administrator. Docker Desktop and symlink creation may fail."
        Write-Warning "    Restart PowerShell as Administrator for a full install."
    }
}

# ── Helpers ──────────────────────────────────────────────────────────

function Test-Command {
    param([string]$cmd)
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

function Install-WingetPackage {
    param([string]$Cmd, [string]$Id)
    if (-not (Test-Command $Cmd)) {
        Write-Host "  ➡ Installing $Id via winget..." -ForegroundColor Yellow
        winget install --id $Id --accept-package-agreements --accept-source-agreements -e
    } else {
        Write-Host "  ✅ $Cmd already installed." -ForegroundColor Gray
    }
}

function Install-BrewPackage {
    param([string]$Cmd, [string]$Pkg)
    if (-not (Test-Command $Cmd)) {
        Write-Host "  ➡ Installing $Pkg via brew..." -ForegroundColor Yellow
        brew install $Pkg
    } else {
        Write-Host "  ✅ $Cmd already installed." -ForegroundColor Gray
    }
}

function Install-NpmPackage {
    param([string]$pkg)
    if (-not (Test-Command npm)) {
        Write-Warning "  ⚠️  npm not found — skipping $pkg. Restart terminal after Node.js install and re-run."
        return
    }
    $installed = npm list -g --depth=0 2>$null | Select-String ([regex]::Escape($pkg))
    if (-not $installed) {
        Write-Host "  ➡ Installing npm package: $pkg" -ForegroundColor Yellow
        npm install -g $pkg
    } else {
        Write-Host "  ✅ npm:$pkg already installed." -ForegroundColor Gray
    }
}

function Install-PsModule {
    param([string]$mod)
    if (-not (Get-Module -ListAvailable -Name $mod)) {
        Write-Host "  ➡ Installing PowerShell module: $mod" -ForegroundColor Yellow
        Install-Module $mod -Force -Scope CurrentUser -ErrorAction SilentlyContinue
    } else {
        Write-Host "  ✅ PS module '$mod' already installed." -ForegroundColor Gray
    }
}

# ── Platform detection ────────────────────────────────────────────────
$isMac = $IsMacOS -or [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform(
    [System.Runtime.InteropServices.OSPlatform]::OSX)

$platform = if ($isMac) { "macOS (Homebrew)" } else { "Windows (winget)" }
Write-Host "`n📦 Bootstrapping fullstack dev environment — $platform`n" -ForegroundColor Cyan

# ═════════════════════════════════════════════════════════════════════
# SECTION 1 — System CLIs (terminal tools, language runtimes, editors)
# ═════════════════════════════════════════════════════════════════════
Write-Host "── System CLIs ──────────────────────────────────────────────" -ForegroundColor DarkGray

if ($isMac) {
    # Ensure Homebrew is present
    if (-not (Test-Command brew)) {
        Write-Host "  ➡ Installing Homebrew..." -ForegroundColor Yellow
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Inject Homebrew into PATH for the rest of this session
        foreach ($p in @("/opt/homebrew/bin", "/usr/local/bin")) {
            if ((Test-Path $p) -and ($env:PATH -notlike "*$p*")) {
                $env:PATH = "${p}:$($env:PATH)"
            }
        }
    } else {
        Write-Host "  ✅ Homebrew already installed." -ForegroundColor Gray
    }

    $brewTools = @(
        @{ Cmd = "gh";         Pkg = "gh" },
        @{ Cmd = "oh-my-posh"; Pkg = "jandedobbeleer/oh-my-posh/oh-my-posh" },
        @{ Cmd = "eza";        Pkg = "eza" },
        @{ Cmd = "fzf";        Pkg = "fzf" },
        @{ Cmd = "fd";         Pkg = "fd" },
        @{ Cmd = "bat";        Pkg = "bat" },
        @{ Cmd = "rg";         Pkg = "ripgrep" },
        @{ Cmd = "tldr";       Pkg = "tldr" },
        @{ Cmd = "http";       Pkg = "httpie" },
        @{ Cmd = "node";       Pkg = "node" },
        @{ Cmd = "php";        Pkg = "php" },
        @{ Cmd = "composer";   Pkg = "composer" }
    )
    foreach ($t in $brewTools) { Install-BrewPackage $t.Cmd $t.Pkg }

} else {
    # Windows — winget pathway
    # Note: Node.js is installed directly (LTS). For multiple Node versions use
    #   winget install CoreyButler.NVMforWindows  then  nvm install --lts
    # in a new terminal after this installer finishes.

    $wingetTools = @(
        @{ Cmd = "gh";         Id = "GitHub.cli" },
        @{ Cmd = "oh-my-posh"; Id = "JanDeDobbeleer.OhMyPosh" },
        @{ Cmd = "eza";        Id = "eza-community.eza" },
        @{ Cmd = "fzf";        Id = "junegunn.fzf" },
        @{ Cmd = "fd";         Id = "sharkdp.fd" },
        @{ Cmd = "bat";        Id = "sharkdp.bat" },
        @{ Cmd = "rg";         Id = "BurntSushi.ripgrep.MSVC" },
        @{ Cmd = "tldr";       Id = "tldr-pages.tldr" },
        @{ Cmd = "http";       Id = "httpie.httpie" },
        @{ Cmd = "node";       Id = "OpenJS.NodeJS.LTS" },
        @{ Cmd = "php";        Id = "PHP.PHP" },
        @{ Cmd = "composer";   Id = "Composer.Composer" },
        @{ Cmd = "docker";     Id = "Docker.DockerDesktop" }
    )
    foreach ($t in $wingetTools) { Install-WingetPackage $t.Cmd $t.Id }
}

# ═════════════════════════════════════════════════════════════════════
# SECTION 2 — Python / HuggingFace CLI
# ═════════════════════════════════════════════════════════════════════
Write-Host "`n── Python / AI CLI ──────────────────────────────────────────" -ForegroundColor DarkGray

if (-not (Test-Command huggingface-cli)) {
    $pip = if (Test-Command pip3) { "pip3" } elseif (Test-Command pip) { "pip" } else { $null }
    if ($pip) {
        Write-Host "  ➡ Installing huggingface_hub via $pip..." -ForegroundColor Yellow
        & $pip install huggingface_hub
    } else {
        Write-Warning "  ⚠️  pip not found. Install Python first, then: pip install huggingface_hub"
    }
} else {
    Write-Host "  ✅ huggingface-cli already installed." -ForegroundColor Gray
}

# ═════════════════════════════════════════════════════════════════════
# SECTION 3 — Laravel global installer
# ═════════════════════════════════════════════════════════════════════
Write-Host "`n── Laravel ──────────────────────────────────────────────────" -ForegroundColor DarkGray

if ((Test-Command composer) -and -not (Test-Command laravel)) {
    Write-Host "  ➡ Installing Laravel installer via composer..." -ForegroundColor Yellow
    composer global require laravel/installer

    # Persist Composer bin in user PATH (survives restarts)
    $composerBin = if ($isMac) {
        "$HOME/.composer/vendor/bin"
    } else {
        "$env:APPDATA\Composer\vendor\bin"
    }
    $pathSep = if ($isMac) { ":" } else { ";" }

    $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($userPath -notlike "*$composerBin*") {
        [Environment]::SetEnvironmentVariable("PATH", "$userPath$pathSep$composerBin", "User")
        Write-Host "  ✅ Added Composer bin to user PATH: $composerBin" -ForegroundColor Green
        Write-Host "     Restart your terminal for 'laravel' to become available." -ForegroundColor Gray
    }
} elseif (Test-Command laravel) {
    Write-Host "  ✅ laravel installer already installed." -ForegroundColor Gray
} else {
    Write-Warning "  ⚠️  composer not found — skipping laravel installer."
}

# ═════════════════════════════════════════════════════════════════════
# SECTION 4 — Global npm CLI tools
# ═════════════════════════════════════════════════════════════════════
Write-Host "`n── npm global packages ──────────────────────────────────────" -ForegroundColor DarkGray

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
foreach ($cli in $npmCLIs) { Install-NpmPackage $cli }

# ═════════════════════════════════════════════════════════════════════
# SECTION 5 — PowerShell modules
# ═════════════════════════════════════════════════════════════════════
Write-Host "`n── PowerShell modules ───────────────────────────────────────" -ForegroundColor DarkGray

foreach ($mod in @("PSReadLine", "posh-git", "z")) {
    Install-PsModule $mod
}

# ═════════════════════════════════════════════════════════════════════
# SECTION 6 — Optional database (interactive)
# ═════════════════════════════════════════════════════════════════════
Write-Host "`n── Database (optional) ──────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  Choose a database to install:" -ForegroundColor Cyan
Write-Host "    1. PostgreSQL"
Write-Host "    2. MySQL"
Write-Host "    3. MongoDB"
Write-Host "    4. Skip (default)"
$selection = (Read-Host "  Select [1/2/3/4] or press Enter to skip").Trim()

switch ($selection) {
    '1' {
        if ($isMac) { Install-BrewPackage "psql" "postgresql@16" }
        else        { Install-WingetPackage "psql" "PostgreSQL.PostgreSQL" }
    }
    '2' {
        if ($isMac) { Install-BrewPackage "mysql" "mysql" }
        else        { Install-WingetPackage "mysql" "Oracle.MySQL" }
    }
    '3' {
        if ($isMac) { Install-BrewPackage "mongod" "mongodb-community" }
        else        { Install-WingetPackage "mongod" "MongoDB.MongoDBCommunity" }
    }
    { $_ -in @('4', '') } {
        Write-Host "  Skipping database install." -ForegroundColor DarkGray
    }
    Default {
        Write-Host "  ⚠️  Unrecognised selection '$_' — skipping database install." -ForegroundColor Yellow
    }
}

# ═════════════════════════════════════════════════════════════════════
# DONE
# ═════════════════════════════════════════════════════════════════════
Write-Host @"

✅ Installation check complete!

Next steps:
  1. Run .\setup-profile.ps1   — symlinks the PowerShell profile
  2. Restart your terminal     — refreshes PATH for newly installed tools
  3. Open pwsh and type:
       ghelp       → Git shortcuts reference
       clifuncs    → All loaded custom functions
       Ctrl+R      → Fuzzy command history search

"@ -ForegroundColor Green
