# Interactive Command History via FZF
Set-PSReadLineKeyHandler -Key Ctrl+r -BriefDescription "FuzzySearchHistory" -ScriptBlock {
    $history = Get-History | Sort-Object Id -Descending | Select-Object -Unique -First 100
    $command = $history | ForEach-Object CommandLine | fzf --height 40% --reverse --prompt='🔍 Search history > '
    if ($command) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($command)
    }
}
Register-EngineEvent PowerShell.Exiting -Action {
    Get-History | Select-Object -Last 100 | Out-File "$env:USERPROFILE\.ps_history"
} | Out-Null
