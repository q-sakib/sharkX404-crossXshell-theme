if (Get-Module -ListAvailable PSReadLine) {
    if ($IsWindows) {
        $path = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
    } else {
        $path = "$HOME/.local/share/powershell/PSReadLine/ConsoleHost_history.txt"
        New-Item -ItemType Directory -Force (Split-Path $path) | Out-Null
    }

    Set-PSReadLineOption -HistorySavePath $path -HistoryNoDuplicates
}
