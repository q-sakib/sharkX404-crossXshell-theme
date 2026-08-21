# =====================================================================
# ⚡ sharkX404 CrossShell Theme — Modular PowerShell Profile
# Cross-platform dev environment for Windows 11+ and macOS
# =====================================================================

# 0. Resolve repository root (handles symlinks on macOS and Windows)
$ProfileRepoDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }

if ($PSCommandPath -and (Test-Path $PSCommandPath)) {
    $item = Get-Item $PSCommandPath -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType) {
        $target = if ([array]$item.Target) { $item.Target[0] } else { $item.Target }
        if (Test-Path $target) { $ProfileRepoDir = Split-Path $target -Parent }
    }
}

if (-not (Test-Path (Join-Path $ProfileRepoDir "Modules"))) {
    $homePath = if ($env:HOME) { $env:HOME } else { $env:USERPROFILE }
    foreach ($cand in @(
        (Join-Path $homePath "--devX404/admin-shell/sharkX404-crossXshell-theme"),
        (Join-Path $homePath "sharkX404-crossXshell-theme")
    )) {
        if (Test-Path (Join-Path $cand "Modules")) { $ProfileRepoDir = $cand; break }
    }
}

$modulesPath = Join-Path $ProfileRepoDir "Modules"

# 1. Load icons and platform modules first (foundation for the rest)
foreach ($priorityMod in @("icons.ps1", "platform.ps1")) {
    $modPath = Join-Path $modulesPath $priorityMod
    if (Test-Path $modPath) {
        try { . $modPath } catch {
            Write-Warning "⚠️ Failed to load $priorityMod : $($_.Exception.Message)"
        }
    }
}

# 2. Load all remaining top-level module scripts
if (Test-Path $modulesPath) {
    Get-ChildItem -Path $modulesPath -Filter "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.Name -notin @("icons.ps1", "platform.ps1")) {
            try {
                . $_.FullName
                Write-Verbose "Loaded: $($_.Name)"
            } catch {
                Write-Warning "⚠️ Failed to load $($_.Name): $($_.Exception.Message)"
            }
        }
    }
}

# 3. Load deep/nested scripts explicitly
$extraScripts = @(
    "Modules/web/dev-checklist/DevChecklist.ps1",
    "Modules/web/dev-checklist/DevChecklist-Angular.ps1",
    "Modules/web/dev-checklist/DevChecklist-Database.ps1",
    "Modules/web/dev-checklist/DevChecklist-Git.ps1",
    "Modules/web/dev-checklist/DevChecklist-Laravel.ps1",
    "Modules/web/dev-checklist/DevChecklist-Node.ps1",
    "Modules/web/dev-checklist/DevChecklist-PowerShell.ps1",

    "Modules/web/webdev.ps1",
    "Modules/web/scripts/db/env/environment.ps1",

    "Modules/web/scripts/db/ORM/mongoose/MongoDBConnectionHelper.ps1",
    "Modules/web/scripts/db/ORM/mongoose/MongoDBModelScaffolding.ps1",

    "Modules/web/scripts/db/ORM/prisma/PrismaModelBoilerplate.ps1",
    "Modules/web/scripts/db/ORM/prisma/PrismaCLIShortcuts.ps1",

    "Modules/web/scripts/db/ORM/eloquent/DatabaseSeeder.ps1",
    "Modules/web/scripts/db/ORM/eloquent/eloquent-helpers.ps1",
    "Modules/web/scripts/db/ORM/eloquent/FactoryTemplateGenerator.ps1",
    "Modules/web/scripts/db/ORM/eloquent/SeederwithFakerBoilerplate.ps1",
    "Modules/web/scripts/db/ORM/eloquent/SmartFakerFieldGuesser.ps1",
    "Modules/web/scripts/db/ORM/eloquent/Tinker-shortcut-runner.ps1",

    "Modules/web/scripts/laravel/laravel.ps1",
    "Modules/web/scripts/laravel/ai-test-helpers.ps1",
    "Modules/web/scripts/laravel/api-resource-helpers.ps1",
    "Modules/web/scripts/laravel/artisan-helpers.ps1",
    "Modules/web/scripts/laravel/auth-helpers.ps1",
    "Modules/web/scripts/laravel/project-init.ps1",
    "Modules/web/scripts/laravel/test-helpers.ps1",

    "Modules/web/scripts/angular.ps1",
    "Modules/web/scripts/node-js.ps1",
    "Modules/web/scripts/nextCLI.ps1",
    "Modules/web/scripts/make-express-boilerplate.ps1",
    "Modules/web/scripts/JWT-boilerplate.ps1",

    "Modules/simulation/shark/shark-session.ps1",
    "Modules/simulation/shark/randomnymous2.ps1"
)

foreach ($rel in $extraScripts) {
    $full = Join-Path $ProfileRepoDir $rel
    if (Test-Path $full) {
        try {
            . $full
            Write-Verbose "Loaded extra: $rel"
        } catch {
            Write-Warning "⚠️ Failed to load $rel : $($_.Exception.Message)"
        }
    }
}

# ── Function Discovery Helpers ──────────────────────────────────────

function basefuncs {
    <#
    .SYNOPSIS
    Lists a curated set of core utility functions defined in this profile.
    #>
    Get-Command -CommandType Function |
        Where-Object {
            $_.ScriptBlock.File -like "*Modules*" -or
            $_.Name -match "^(up|codehere|jsonpretty|live|dev|api|deploy|gll|grep|ff|dlog|load-env|edit-)"
        } |
        Sort-Object Name |
        Format-Table Name, @{Name="Module";Expression={Split-Path $_.ScriptBlock.File -Leaf}} -AutoSize
}

function Get-DevFunctions {
    <#
    .SYNOPSIS
    Lists every custom CLI function loaded from this profile's Modules directory.
    #>
    Write-Host "`n🛠️  Custom CLI Functions:" -ForegroundColor Cyan

    $basePaths = @(
        (Join-Path $ProfileRepoDir "Modules"),
        (Join-Path $ProfileRepoDir "Modules/web/scripts")
    ) | ForEach-Object { ($_ -replace '\\', '/').ToLower() }

    $fns = Get-Command -CommandType Function | Where-Object {
        $file = $_.ScriptBlock.File
        if (-not $file) { return $false }
        $norm = ($file -replace '\\', '/').ToLower()
        $basePaths | Where-Object { $norm.StartsWith($_) }
    }

    if ($fns.Count -eq 0) {
        Write-Host "⚠️  No custom functions found." -ForegroundColor Yellow
        return
    }

    foreach ($fn in $fns | Sort-Object Name) {
        Write-Host "  • $($fn.Name)" -ForegroundColor Green
    }

    Write-Host "`n  Total: $($fns.Count) functions" -ForegroundColor DarkGray
    Write-Host "  Tip  : Get-Help <FunctionName> for details`n" -ForegroundColor DarkGray
}

Set-Alias clifuncs Get-DevFunctions

Write-Host "`n✅ sharkX404 profile loaded  •  ghelp = git shortcuts  •  clifuncs = all functions  •  Ctrl+R = fuzzy history" -ForegroundColor Cyan
