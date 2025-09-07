# Number of animation frames
$frames = 30
# Shark ASCII (as an array of strings)
$shark = @(
    "                          ___",
    "                        /`  _\",
    "       ______      __  |__/  /",
    "     /` ____ `.  /'_ `\     /",
    "    | (___ \_| | (_| |    |",
    "     \____\`\  \__, |    |",
    "           `\ \__/ /    /",
    "             \___/    /",
    "              ____   /",
    "          .-''    ``'.",
    "         /     __     \\",
    "        /    .'__`.    \\",
    "       |   / (__) \_\   |",
    "       \_/|  |___|  |\_/",
    "         \__/     \__/",
    "           \       /",
    "           |  .-.  |",
    "           | |   | |",
    "           |_|   |_|",
    "          (__)   (__)",
    "",
    "        ~ WILD SHARK ATTACK ~"
)

# Blood trail (red splash)
$blood = @(
    "  ~~~~",
    "    ~~~~~~",
    " ~~~~~",
    "   ~~~~~~~~"
)

for ($i = 0; $i -lt $frames; $i++) {
    Clear-Host

    # Print blood trail in red
    foreach ($line in $blood) {
        Write-Host (" " * $i) -NoNewline
        Write-Host $line -ForegroundColor Red
    }

    # Print shark in blue
    foreach ($line in $shark) {
        Write-Host (" " * $i) -NoNewline
        Write-Host $line -ForegroundColor Blue
    }

    Start-Sleep -Milliseconds 150
}
