# --- Modular PowerShell Profile for Fullstack Dev (Cross-Platform) ---

# 0. Resolve true repository root (handles symlinks on macOS & Windows under all invocation modes)
$ProfileRepoDir = if ($PSScriptRoot) { $PSScriptRoot } else { Get-Location }

# Check $PSCommandPath symlink
if ($PSCommandPath -and (Test-Path $PSCommandPath)) {
    $item = Get-Item $PSCommandPath -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType) {
        $target = if ([array]$item.Target) { $item.Target[0] } else { $item.Target }
        if (Test-Path $target) {
            $ProfileRepoDir = Split-Path $target -Parent
        }
    }
}

# Check standard profile symlink target if Modules folder is not found
if (-not (Test-Path (Join-Path $ProfileRepoDir "Modules"))) {
    $homePath = if ($env:HOME) { $env:HOME } else { $env:USERPROFILE }
    $stdProfile = Join-Path $homePath ".config/powershell/Microsoft.PowerShell_profile.ps1"
    if (Test-Path $stdProfile) {
        $item = Get-Item $stdProfile -ErrorAction SilentlyContinue
        if ($item -and $item.LinkType) {
            $target = if ([array]$item.Target) { $item.Target[0] } else { $item.Target }
            if (Test-Path $target) {
                $ProfileRepoDir = Split-Path $target -Parent
            }
        }
    }
}

# Fallback candidate check if Modules directory is still not found
if (-not (Test-Path (Join-Path $ProfileRepoDir "Modules"))) {
    $homePath = if ($env:HOME) { $env:HOME } else { $env:USERPROFILE }
    $candidates = @(
        "/Users/shark/--devX404/admin-shell/sharkX404-crossXshell-theme",
        (Join-Path $homePath "--devX404/admin-shell/sharkX404-crossXshell-theme"),
        (Join-Path $homePath "sharkX404-crossXshell-theme")
    )
    foreach ($cand in $candidates) {
        if (Test-Path (Join-Path $cand "Modules")) {
            $ProfileRepoDir = $cand
            break
        }
    }
}

# 1. Load Icons module first for font resilience
$iconsScript = Join-Path $ProfileRepoDir "Modules/icons.ps1"
if (Test-Path $iconsScript) {
    try { . "$iconsScript" } catch {}
}

# 2. Load all top-level helper scripts from 'Modules'
$modulesPath = Join-Path $ProfileRepoDir "Modules"
if (Test-Path $modulesPath) {
    Get-ChildItem -Path $modulesPath -Filter "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.Name -ne "icons.ps1") {
            try {
                . "$($_.FullName)"
                Write-Verbose "Loaded module script: $($_.Name)"
            } catch {
                Write-Warning "⚠️ Failed to load script: $($_.FullName) - $($_.Exception.Message)"
            }
        }
    }
}

# 3. Explicitly load additional deep/nested scripts
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

foreach ($relPath in $extraScripts) {
    $script = Join-Path $ProfileRepoDir $relPath
    if (Test-Path $script) {
        try {
            . "$script"
            Write-Verbose "Loaded extra script: $script"
        } catch {
            Write-Warning "⚠️ Failed to load script: $script - $($_.Exception.Message)"
        }
    }
}

# 4. Custom CLI Function Listing Helpers
function basefuncs {
    Get-Command -CommandType Function |
    Where-Object { 
        $file = $_.ScriptBlock.File
        ($file -and ($file -replace '\\','/') -like "*/Modules/*") -or $_.Name -match "^(up|codehere|jsonpretty|live|dev|api|deploy|gll|ghelp|git-aliases|grep|ff|dlog|load-env|edit-)" 
    } |
    Sort-Object Name |
    Format-Table Name, @{Name="DefinedIn";Expression={$_.ScriptBlock.File}}, Description -AutoSize
}

function list-dev-functions {
    Write-Host "`n🛠️  Custom CLI Functions Loaded:" -ForegroundColor Cyan

    $customPaths = @(
        (Join-Path $ProfileRepoDir "Modules"),
        (Join-Path $ProfileRepoDir "Modules/web/scripts")
    ) | ForEach-Object { $_ -replace '\\', '/' }

    $functions = Get-Command -CommandType Function | Where-Object {
        $file = $_.ScriptBlock.File
        if (-not $file) { return $false }
        $normalizedFile = $file -replace '\\', '/'
        $customPaths | Where-Object { $normalizedFile.ToLower().StartsWith($_.ToLower()) }
    }

    if ($functions.Count -eq 0) {
        Write-Host "⚠️  No custom CLI functions loaded from script paths." -ForegroundColor Yellow
        return
    }

    foreach ($fn in $functions | Sort-Object Name) {
        Write-Host "• $($fn.Name)" -ForegroundColor Green
    }

    Write-Host "`n🧭 Total: $($functions.Count) custom functions loaded" -ForegroundColor DarkGray
    Write-Host "🔍 Tip: Use 'ghelp' for Git aliases or 'Get-Help <FunctionName>' for function details." -ForegroundColor DarkGray
}

Set-Alias clifuncs list-dev-functions -ErrorAction SilentlyContinue

Write-Host "`n✅ Fullstack PowerShell Loaded (Cross-Platform). Press Ctrl+R for history search or type 'ghelp' for Git shortcuts!" -ForegroundColor Cyan
