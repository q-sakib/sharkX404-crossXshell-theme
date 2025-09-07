# Chaos characters and colors
$chars = @("!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "=", "+", "[", "]", "{", "}", "|", "\", ":", ";", "'", "<", ">", ",", ".", "?", "/", "~", [char]96, "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "X", "Z")
$colors = @("Red", "Green", "Yellow", "Blue", "Cyan", "Magenta", "White")

# Number of chaos lines
$lines = 100

for ($i = 0; $i -lt $lines; $i++) {
    # Build a chaotic line
    $line = ""
    for ($j = 0; $j -lt (Get-Random -Minimum 20 -Maximum 80); $j++) {
        $line += ($chars | Get-Random)
    }

    # Pick random color
    $color = $colors | Get-Random

    # Print chaotic line
    Write-Host $line -ForegroundColor $color

    # Random short delay to simulate chaotic pace
    Start-Sleep -Milliseconds (Get-Random -Minimum 20 -Maximum 100)
}

# Final blow
Write-Host "`n⚠️  CHAOS COMPLETE. Your terminal survived... this time." -ForegroundColor Red
