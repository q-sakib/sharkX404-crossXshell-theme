# Define ASCII arts
$sakib = @(
    "  _____    _    _  __   _  ",
    " / ___/   | |  | |/ /  | | ",
    "/ /___    | |__| ' /   | | ",
    "\___  \   |  __  | |   | | ",
    " ___/ /   | |  | | |   |_| ",
    "/____/    |_|  |_|_|       "
)

$shark = @(
    "  ____  _   _    _    ____  _  __ ",
    " / ___|| | | |  / \  |  _ \| |/ / ",
    " \___ \| |_| | / _ \ | |_) | ' /  ",
    "  ___) |  _  |/ ___ \|  __/| . \  ",
    " |____/|_| |_/_/   \_\_|   |_|\_\ "
)

$denzi = @(
    " ____   _____ _   _ ____  ",
    "|  _ \ | ____| \ | |  _ \ ",
    "| | | ||  _| |  \| | | | |",
    "| |_| || |___| |\  | |_| |",
    "|____/ |_____|_| \_|____/ "
)

$x404 = @(
    " __   ___  ___   ___ ",
    " \ \ / / |/ _ \ / _ \ ",
    "  \ V /| | | | | | | |",
    "   | | | | |_| | |_| |",
    "   |_| |_|\___/ \___/ "
)

# Put them in an array
$asciiOptions = @($sakib, $shark, $denzi, $x404)

# Terminal width and padding params
$termWidth = [console]::WindowWidth
$artWidth = 30   # estimate max width of each art block, adjust if needed

# Colors for cyberpunk neon effect
$colors = @("Cyan", "Magenta", "Yellow", "Green")

# Pick a random art
$art = $asciiOptions | Get-Random

# Function to print with neon effect left to right animation
function Show-AsciiAnimation {
    param($artLines)

    for ($pos = 0; $pos -le ($termWidth - $artWidth); $pos += 2) {
        cls
        foreach ($line in $artLines) {
            Write-Host (" " * $pos) -NoNewline
            $color = $colors | Get-Random
            Write-Host $line -ForegroundColor $color
        }
        Start-Sleep -Milliseconds 100
    }

    # Clear after animation
    cls
}

# Run animation
Show-AsciiAnimation $art

# After animation, print cool cyberpunk welcome text
$welcomeText = @(
    "  ██████╗ ██╗   ██╗███████╗██████╗ ",
    "  ██╔══██╗██║   ██║██╔════╝██╔══██╗",
    "  ██████╔╝██║   ██║█████╗  ██████╔╝",
    "  ██╔═══╝ ██║   ██║██╔══╝  ██╔══██╗",
    "  ██║     ╚██████╔╝███████╗██║  ██║",
    "  ╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝",
    "",
    "   Welcome to your cyberpunk terminal.",
    "    Stay sharp. Code sharper.",
    "    ~ powered by neon vibes ~"
)

foreach ($line in $welcomeText) {
    $color = $colors | Get-Random
    Write-Host $line -ForegroundColor $color
    Start-Sleep -Milliseconds 150
}
