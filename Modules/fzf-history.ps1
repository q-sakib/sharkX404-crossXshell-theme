# ================================
# 📜 FuzzyHistory PowerShell Module
# Persistent fuzzy history across sessions with autosave
# ================================

$global:PSHistoryFile = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

# Configure PSReadLine history behavior
Set-PSReadLineOption -HistoryNoDuplicates:$true
Set-PSReadLineOption -MaximumHistoryCount:10000
Set-PSReadLineOption -HistorySavePath:$global:PSHistoryFile

# Load persistent history into current session after 1 second delay
$timer = New-Object Timers.Timer 1000
$timer.AutoReset = $false
$timer.Enabled = $true
$timer.Add_Elapsed({
    if (Test-Path $global:PSHistoryFile) {
        Get-Content $global:PSHistoryFile | ForEach-Object {
            if ($_ -and ($_ -notmatch '^\s*$')) {
                try {
                    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($_)
                } catch {
                    # Ignore errors for malformed or duplicate lines
                }
            }
        }
    } else {
        # Create empty file if missing
        New-Item -ItemType File -Path $global:PSHistoryFile -Force | Out-Null
    }
    $timer.Dispose()
})

# 🔍 Ctrl+R fuzzy search from last 100 unique merged commands
Set-PSReadLineKeyHandler -Key Ctrl+r -BriefDescription "FuzzySearchHistory" -ScriptBlock {
    try {
        # Get session + file history
        $sessionHistory = Get-History | Sort-Object Id -Descending | Select-Object -ExpandProperty CommandLine
        $fileHistory = @()
        if (Test-Path $global:PSHistoryFile) {
            $fileHistory = Get-Content $global:PSHistoryFile
        }

        $mergedHistory = ($sessionHistory + $fileHistory) `
            | Where-Object { $_ -and ($_ -notmatch '^\s*$') } `
            | Select-Object -Unique

        $history = $mergedHistory | Select-Object -First 100

        if (-not $history -or $history.Count -eq 0) {
            Write-Host "⚠️ No command history available." -ForegroundColor Yellow
            return
        }

        # Show fzf menu
        $command = $history | fzf `
            --height=80% `
            --min-height=20 `
            --reverse `
            --border `
            --scroll-off=5 `
            --prompt='🔍 Command history > ' `
            --info=inline

        if ($command -and $command.Trim() -ne '') {
            # Insert command at cursor
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($command)

            # Execute the line
            Start-Sleep -Milliseconds 50
            [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
        }

    } catch {
        Write-Host "❌ Ctrl+R handler failed: $_" -ForegroundColor Red
    }
}


# 💾 Save merged, deduplicated history to file
function Save-FuzzyHistory {
    try {
        $sessionHistory = Get-History | Sort-Object Id -Descending | Select-Object -ExpandProperty CommandLine

        $existing = @()
        if (Test-Path $global:PSHistoryFile) {
            $existing = Get-Content $global:PSHistoryFile
        }

        $merged = ($sessionHistory + $existing) `
            | Where-Object { $_ -and ($_ -notmatch '^\s*$') } `
            | Select-Object -Unique

        $merged | Select-Object -First 1000 | Set-Content -Encoding UTF8 -Path $global:PSHistoryFile
    } catch {
        Write-Host "❌ Failed to save history: $_" -ForegroundColor Red
    }
}

# Save history on session exit
Register-EngineEvent PowerShell.Exiting -Action {
    Save-FuzzyHistory
} | Out-Null

# Auto-save every 5 minutes
$script:SaveHistoryTimer = [System.Timers.Timer]::new(300000)
$script:SaveHistoryTimer.AutoReset = $true
$script:SaveHistoryTimer.Enabled = $true
$script:SaveHistoryTimer.add_Elapsed({
    Save-FuzzyHistory
})


















# DELETE

function Invoke-FuzzyHistoryDelete {
    $file = $global:PSHistoryFile

    if (-not (Test-Path $file)) {
        Write-Host "❌ History file not found: $file" -ForegroundColor Red
        return
    }

    $allHistory = Get-Content $file | Where-Object { $_ -and ($_ -notmatch '^\s*$') }

    if (-not $allHistory -or $allHistory.Count -eq 0) {
        Write-Host "⚠️ No command history to delete." -ForegroundColor Yellow
        return
    }

    # Select multiple lines to delete
    $toDelete = $allHistory | fzf --multi `
        --height=80% `
        --reverse `
        --border `
        --prompt='🗑 Select history to delete > ' `
        --header='(Use TAB to mark, ENTER to confirm selection)' `
        --info=inline

    if (-not $toDelete) {
        Write-Host "ℹ️ No entries selected for deletion." -ForegroundColor Cyan
        return
    }

    Write-Host "`n⚠️ You are about to delete $($toDelete.Count) command(s) from history." -ForegroundColor Yellow
    $confirm = Read-Host "Type DELETE to confirm"

    if ($confirm -eq "DELETE") {
        # Remove selected lines
        $updated = $allHistory | Where-Object { $toDelete -notcontains $_ }
        $updated | Set-Content -Encoding UTF8 -Path $file

        Write-Host "✅ Deleted $($toDelete.Count) item(s) from history." -ForegroundColor Green
    } else {
        Write-Host "❌ Deletion canceled." -ForegroundColor Red
    }
}
Set-Alias deletehistory Invoke-FuzzyHistoryDelete
