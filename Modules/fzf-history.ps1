# =====================================================================
# 📜 FuzzyHistory PowerShell Module
# Persistent fuzzy history across sessions with autosave & deletion
# =====================================================================

# Dynamic history file path resolution across macOS, Linux, and Windows
$global:PSHistoryFile = try {
    [Microsoft.PowerShell.PSConsoleReadLine]::GetHistorySavePath()
} catch {
    if ($env:APPDATA) {
        "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
    } else {
        "$HOME/.local/share/powershell/PSReadLine/ConsoleHost_history.txt"
    }
}

# Ensure parent directory exists
$historyDir = Split-Path $global:PSHistoryFile -Parent
if (-not (Test-Path $historyDir)) {
    New-Item -ItemType Directory -Path $historyDir -Force -ErrorAction SilentlyContinue | Out-Null
}

# Configure PSReadLine history behavior safely
if (Get-Command Set-PSReadLineOption -ErrorAction SilentlyContinue) {
    try {
        Set-PSReadLineOption -HistoryNoDuplicates:$true -ErrorAction SilentlyContinue
        Set-PSReadLineOption -MaximumHistoryCount 10000 -ErrorAction SilentlyContinue
        if ($global:PSHistoryFile) {
            Set-PSReadLineOption -HistorySavePath $global:PSHistoryFile -ErrorAction SilentlyContinue
        }
    } catch {
        # Ignore if PSReadLine is loading in non-interactive environment
    }
}

# Load persistent history into current session after 1 second delay
$timer = New-Object Timers.Timer 1000
$timer.AutoReset = $false
$timer.Enabled = $true
$timer.Add_Elapsed({
    if (Test-Path $global:PSHistoryFile) {
        Get-Content $global:PSHistoryFile -ErrorAction SilentlyContinue | ForEach-Object {
            if ($_ -and ($_ -notmatch '^\s*$')) {
                try {
                    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($_)
                } catch {}
            }
        }
    } else {
        New-Item -ItemType File -Path $global:PSHistoryFile -Force -ErrorAction SilentlyContinue | Out-Null
    }
    $timer.Dispose()
})

# 🔍 Ctrl+R fuzzy search from merged unique history
if (Get-Command Set-PSReadLineKeyHandler -ErrorAction SilentlyContinue) {
    try {
        Set-PSReadLineKeyHandler -Key Ctrl+r -BriefDescription "FuzzySearchHistory" -ScriptBlock {
            try {
                if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
                    Write-Host "⚠️ 'fzf' is not installed. Install via homebrew/winget to enable fuzzy search." -ForegroundColor Yellow
                    return
                }

                $sessionHistory = Get-History | Sort-Object Id -Descending | Select-Object -ExpandProperty CommandLine
                $fileHistory = @()
                if (Test-Path $global:PSHistoryFile) {
                    $fileHistory = Get-Content $global:PSHistoryFile -ErrorAction SilentlyContinue
                }

                $mergedHistory = ($sessionHistory + $fileHistory) `
                    | Where-Object { $_ -and ($_ -notmatch '^\s*$') } `
                    | Select-Object -Unique

                $history = $mergedHistory | Select-Object -First 200

                if (-not $history -or $history.Count -eq 0) {
                    Write-Host "⚠️ No command history available." -ForegroundColor Yellow
                    return
                }

                $command = $history | fzf `
                    --height=80% `
                    --min-height=20 `
                    --reverse `
                    --border `
                    --scroll-off=5 `
                    --prompt='🔍 Command history > ' `
                    --info=inline

                if ($command -and $command.Trim() -ne '') {
                    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($command)
                    Start-Sleep -Milliseconds 50
                    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
                }
            } catch {
                Write-Host "❌ Ctrl+R handler error: $_" -ForegroundColor Red
            }
        }
    } catch {}
}

# 💾 Save merged, deduplicated history to file
function Save-FuzzyHistory {
    try {
        if (-not $global:PSHistoryFile) { return }
        $sessionHistory = Get-History | Sort-Object Id -Descending | Select-Object -ExpandProperty CommandLine

        $existing = @()
        if (Test-Path $global:PSHistoryFile) {
            $existing = Get-Content $global:PSHistoryFile -ErrorAction SilentlyContinue
        }

        $merged = ($sessionHistory + $existing) `
            | Where-Object { $_ -and ($_ -notmatch '^\s*$') } `
            | Select-Object -Unique

        $merged | Select-Object -First 2000 | Set-Content -Encoding UTF8 -Path $global:PSHistoryFile -ErrorAction SilentlyContinue
    } catch {}
}

# Save history on session exit
Register-EngineEvent PowerShell.Exiting -Action {
    Save-FuzzyHistory
} -ErrorAction SilentlyContinue | Out-Null

# 🗑 Interactive History Deletion
function Invoke-FuzzyHistoryDelete {
    <#
    .SYNOPSIS
    Interactively select and delete entries from persistent command history using fzf.
    #>
    $file = $global:PSHistoryFile

    if (-not (Test-Path $file)) {
        Write-Host "❌ History file not found: $file" -ForegroundColor Red
        return
    }

    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
        Write-Host "❌ 'fzf' is required for interactive history deletion. Please install fzf." -ForegroundColor Red
        return
    }

    $allHistory = Get-Content $file | Where-Object { $_ -and ($_ -notmatch '^\s*$') }

    if (-not $allHistory -or $allHistory.Count -eq 0) {
        Write-Host "⚠️ No command history to delete." -ForegroundColor Yellow
        return
    }

    $toDelete = $allHistory | fzf --multi `
        --height=80% `
        --reverse `
        --border `
        --prompt='🗑 Select history to delete > ' `
        --header='(Use TAB to mark multiple items, ENTER to confirm selection)' `
        --info=inline

    if (-not $toDelete) {
        Write-Host "ℹ️ No entries selected for deletion." -ForegroundColor Cyan
        return
    }

    Write-Host "`n⚠️ You are about to delete $($toDelete.Count) command(s) from history." -ForegroundColor Yellow
    $confirm = Read-Host "Type DELETE to confirm"

    if ($confirm -eq "DELETE") {
        $updated = $allHistory | Where-Object { $toDelete -notcontains $_ }
        $updated | Set-Content -Encoding UTF8 -Path $file
        Write-Host "✅ Deleted $($toDelete.Count) item(s) from history." -ForegroundColor Green
    } else {
        Write-Host "❌ Deletion canceled." -ForegroundColor Red
    }
}

function Clean-History {
    <#
    .SYNOPSIS
    Deduplicates persistent command history file.
    #>
    Save-FuzzyHistory
    Write-Host "✅ History file deduplicated and cleaned." -ForegroundColor Green
}

Set-Alias deletehistory Invoke-FuzzyHistoryDelete -ErrorAction SilentlyContinue
Set-Alias clean-history Clean-History -ErrorAction SilentlyContinue
