# Matrix Rain Chaos in PowerShell
# Characters to rain
$chars = "01", "⧖", "Ξ", "Σ", "λ", "ψ", "|", "/", "\", "#", "$", "%", "@"

# Terminal width & height
$width = 80
$height = 25

# Colors
$bgColors = @("Black", "DarkGreen", "DarkBlue", "DarkRed", "DarkMagenta", "DarkCyan", "DarkYellow")

# Infinite loop - press Ctrl+C to stop
while ($true) {
    Clear-Host

    for ($i = 0; $i -lt $height; $i++) {
        $line = ""
        for ($j = 0; $j -lt $width; $j++) {
            $char = $chars | Get-Random
            $line += "$char"
        }

        # Flashing background + green foreground (Matrix)
        $bg = $bgColors | Get-Random
        Write-Host $line -ForegroundColor Green -BackgroundColor $bg
    }

    Start-Sleep -Milliseconds 100
}
