# --- Modular PowerShell Profile for Fullstack Dev ---

# 1. Load all top-level helper scripts from 'modules'
$modulesPath = "$PSScriptRoot\modules"
Get-ChildItem "$modulesPath\*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        . $_.FullName
        Write-Verbose "Loaded module script: $($_.Name)"
    } catch {
        Write-Warning "⚠️ Failed to load script: $($_.FullName) - $($_.Exception.Message)"
    }
}

# 2. Explicitly load additional deep/nested scripts
$extraScripts = @(
    "$PSScriptRoot\modules\web\webdev.ps1",
    "$PSScriptRoot\modules\web\scripts\db\env\environment.ps1",

    "$PSScriptRoot\modules\web\scripts\db\ORM\mongoose\MongoDBConnectionHelper.ps1",
    "$PSScriptRoot\modules\web\scripts\db\ORM\mongoose\MongoDBModelScaffolding.ps1",

    "$PSScriptRoot\modules\web\scripts\db\ORM\prisma\PrismaModelBoilerplate.ps1",
    "$PSScriptRoot\modules\web\scripts\db\ORM\prisma\PrismaCLIShortcuts.ps1",

    "$PSScriptRoot\modules\web\scripts\db\ORM\eloquent\DatabaseSeeder.ps1",
    "$PSScriptRoot\modules\web\scripts\db\ORM\eloquent\eloquent-helpers.ps1",
    "$PSScriptRoot\modules\web\scripts\db\ORM\eloquent\FactoryTemplateGenerator.ps1",
    "$PSScriptRoot\modules\web\scripts\db\ORM\eloquent\SeederwithFakerBoilerplate.ps1",
    "$PSScriptRoot\modules\web\scripts\db\ORM\eloquent\SmartFakerFieldGuesser.ps1",
    "$PSScriptRoot\modules\web\scripts\db\ORM\eloquent\Tinker-shortcut-runner.ps1",

    "$PSScriptRoot\modules\web\scripts\laravel\laravel.ps1",
    "$PSScriptRoot\modules\web\scripts\laravel\ai-test-helpers.ps1",
    "$PSScriptRoot\modules\web\scripts\laravel\api-resource-helpers.ps1",
    "$PSScriptRoot\modules\web\scripts\laravel\artisan-helpers.ps1",
    "$PSScriptRoot\modules\web\scripts\laravel\auth-helpers.ps1",
    "$PSScriptRoot\modules\web\scripts\laravel\project-init.ps1",
    "$PSScriptRoot\modules\web\scripts\laravel\test-helpers.ps1",

    "$PSScriptRoot\modules\web\scripts\angular.ps1",
    "$PSScriptRoot\modules\web\scripts\node-js.ps1",
    "$PSScriptRoot\modules\web\scripts\nextCLI.ps1",
    "$PSScriptRoot\modules\web\scripts\make-express-boilerplate.ps1",
    "$PSScriptRoot\modules\web\scripts\JWT-boilerplate.ps1",
    "$PSScriptRoot\modules\simulation\shark\shark-session.ps1",
    "$PSScriptRoot\modules\simulation\shark\randomnymous2.ps1"
    # "$PSScriptRoot\modules\simulation\chaos\chaos-text.ps1"
)

foreach ($script in $extraScripts) {
    if (Test-Path $script) {
        try {
            . $script
            Write-Verbose "Loaded extra script: $script"
        } catch {
            Write-Warning "⚠️ Failed to load script: $script - $($_.Exception.Message)"
        }
    } else {
        Write-Warning "⚠️ Script not found: $script"
    }
}

function basefuncs {
    Get-Command -CommandType Function |
    Where-Object { $_.ScriptBlock.File -like "*PowerShell\\modules\\*" -or $_.Name -match "^(up|codehere|jsonpretty|live|dev|api|deploy|gll|grep|ff|dlog|load-env|edit-)" } |
    Sort-Object Name |
    Format-Table Name, @{Name="DefinedIn";Expression={$_.ScriptBlock.File}}, Description -AutoSize
}
function list-dev-functions {
    Write-Host "`n🛠️  Custom CLI Functions Loaded:" -ForegroundColor Cyan

    $customPaths = @(
        "$PSScriptRoot\modules",
        "$PSScriptRoot\modules\web\scripts"
    ) | ForEach-Object { $_ -replace '\\', '/' }  # Normalize slashes

    $functions = Get-Command -CommandType Function | Where-Object {
        $file = $_.ScriptBlock.File
        if (-not $file) { return $false }

        $normalizedFile = $file -replace '\\', '/'  # Normalize slashes for comparison
        $customPaths | Where-Object { $normalizedFile.ToLower().StartsWith($_.ToLower()) }
    }

    if ($functions.Count -eq 0) {
        Write-Host "⚠️  No custom CLI functions loaded from your script paths." -ForegroundColor Yellow
        return
    }

    foreach ($fn in $functions | Sort-Object Name) {
        Write-Host "• $($fn.Name)" -ForegroundColor Green
    }

    Write-Host "`n🧭 Total: $($functions.Count) custom functions" -ForegroundColor DarkGray
    Write-Host "🔍 Tip: Use 'Get-Help <FunctionName>' for more info." -ForegroundColor DarkGray
}
Set-Alias clifuncs list-dev-functions


# # 3. Help message
# Write-Host "`n💡 Terminal Ready! Try:" -ForegroundColor Cyan
# Write-Host "  → live         # Launch live server" -ForegroundColor Gray
# Write-Host "  → deploy-*     # Deploy to Vercel, Firebase, or Heroku" -ForegroundColor Gray
# Write-Host "  → copilot-auth # GitHub Copilot CLI login" -ForegroundColor Gray
# Write-Host "  → hf-login     # Hugging Face CLI login" -ForegroundColor Gray
# Write-Host "  → api <url>    # Test REST API via httpie" -ForegroundColor Gray

Write-Host "`n✅ Fullstack PowerShell loaded. Type Ctrl+R for searchable history!" -ForegroundColor Cyan
