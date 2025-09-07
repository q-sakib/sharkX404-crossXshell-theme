# Chaos Configuration
$symbols = @("@", "#", "%", "*", "+", "=", "-", ":", ".", "|", "!", "~", "&", "$", "0", "1", "X", "Z", "█", "▓", "░")
$colors = @("Red", "Green", "Yellow", "Blue", "Cyan", "Magenta", "White")
$lines = 50     # Total lines per frame
$width = 100    # Width of each line
$frames = 200   # Number of total frames to display

# Chaos Loop
for ($frame = 0; $frame -lt $frames; $frame++) {
    Clear-Host

    for ($i = 0; $i -lt $lines; $i++) {
        $line = ""

        for ($j = 0; $j -lt $width; $j++) {
            $line += $symbols | Get-Random
        }

        $color = $colors | Get-Random
        Write-Host $line -ForegroundColor $color
    }

    # Occasionally inject fake ERROR
    if ($frame % 13 -eq 0) {
        Write-Host "`n[ERROR] TERMINAL OVERRIDE DETECTED" -ForegroundColor Red
    }

    Start-Sleep -Milliseconds 50
}

Write-Host "`n💀 CHAOS SIMULATION COMPLETE" -ForegroundColor DarkRed
