# Chaos Matrix with errors, timers, mutations
$chars = @("0", "1", "⧖", "Ξ", "Σ", "λ", "ψ", "|", "/", "\", "#", "$", "%", "@")
$width = 80
$height = 25
$bgColors = @("Black", "DarkGreen", "DarkBlue", "DarkRed", "DarkMagenta", "DarkCyan", "DarkYellow")

# Countdown timer
$countdown = 10

# Initialize random matrix buffer (mutating stream)
$buffer = @()
for ($i = 0; $i -lt $height; $i++) {
    $buffer += ,(@())
    for ($j = 0; $j -lt $width; $j++) {
        $buffer[$i] += ($chars | Get-Random)
    }
}

# Main loop
while ($true) {
    Clear-Host

    # Draw mutated matrix rain
    for ($i = 0; $i -lt $height; $i++) {
        $line = ""
        for ($j = 0; $j -lt $width; $j++) {
            # Occasionally mutate a character
            if ((Get-Random -Minimum 0 -Maximum 100) -lt 10) {
                $buffer[$i][$j] = $chars | Get-Random
            }
            $line += $buffer[$i][$j]
        }

        # Flashing background
        $bg = $bgColors | Get-Random
        Write-Host $line -ForegroundColor Green -BackgroundColor $bg
    }

    # Randomly insert red ERROR messages
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 20) {
        $errX = Get-Random -Minimum 5 -Maximum ($width - 10)
        $errY = Get-Random -Minimum 3 -Maximum ($height - 3)
        $errorMsg = "!!! ERROR 0x" + ((Get-Random -Minimum 1000 -Maximum 9999).ToString("X")) + " !!!"
        Write-Host ("`e[$errY;${errX}H") -NoNewline  # ANSI cursor move
        Write-Host $errorMsg -ForegroundColor Red
    }

    # Countdown effect at top right
    if ($countdown -ge 0) {
        $timerMsg = "[ SYSTEM FAILURE IN: $countdown ]"
        Write-Host ("`e[1;${width}H") -NoNewline
        Write-Host $timerMsg.PadLeft($width) -ForegroundColor Yellow
        $countdown--
    }

    Start-Sleep -Milliseconds 150
}
