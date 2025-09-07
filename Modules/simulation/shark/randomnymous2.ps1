function Run-BannerAnimation {
    Clear-Host
    # Define big ASCII banners
    $banners = @(
        @(
            " ██████╗ █████╗ ██╗  ██╗██╗██████╗ ",
            "██╔════╝██╔══██╗██║ ██╔╝██║██╔══██╗",
            "╚█████╗ ███████║█████╔╝ ██║███████║",
            " ╚═══██╗██╔══██║██╔═██╗ ██║██║  ██║",
            "██████╔╝██║  ██║██║  ██╗██║██████╔╝",
            "╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═════╝ "
        ), @(
            " ██████╗██╗  ██╗ █████╗ ██████╗ ██╗  ██╗",
            "██╔════╝██║  ██║██╔══██╗██╔══██╗██║ ██╔╝",
            "╚█████╗ ███████║███████║██████╔╝█████╔╝ ",
            " ╚═══██╗██╔══██║██╔══██║██╔══██╗██╔═██╗ ",
            "██████╔╝██║  ██║██║  ██║██║  ██║██║  ██╗",
            "╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝"
        ), @(
            "██████╗ ███████╗███╗   ██╗████████╗██╗",
            "██╔══██╗██╔════╝████╗  ██║╚══██╔══╝██║",
            "██║  ██║█████╗  ██╔██╗ ██║  ██╔╝   ██║",
            "██║  ██║██╔══╝  ██║╚██╗██║ ██╔╝    ██║",
            "██████╔╝███████╗██║ ╚████║████████╗██║",
            "╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═══════╝╚═╝"
        ), @(
            "██╗  ██╗██╗  ██╗ ██████╗ ██╗  ██╗",
            "╚██╗██╔╝██║  ██║██╔═══██╗██║  ██║",
            " ╚███╔╝ ███████║██║   ██║███████║",
            " ██╔██╗ ╚════██║██║   ██║╚════██║",
            "██╔╝╚██╗     ██║╚██████╔╝     ██║",
            "╚═╝  ╚═╝     ╚═╝ ╚═════╝      ╚═╝"
        )
    )

    $termWidth = [console]::WindowWidth
    $selectedBanner = Get-Random -InputObject $banners
    $bannerWidth = ($selectedBanner | Measure-Object -Maximum Length).Maximum

    $maxPos = $termWidth - $bannerWidth
    $steps = 10
    $stepSize = [math]::Max(1, [math]::Floor($maxPos / $steps))

    for ($pos = 0; $pos -le $maxPos; $pos += $stepSize) {
        Clear-Host
        foreach ($line in $selectedBanner) {
            $spaces = " " * $pos
            Write-Host "$spaces$line" -ForegroundColor Blue
        }
        Start-Sleep -Milliseconds 40
    }

    Clear-Host

    Write-Host "💡 Terminal Ready! Try: Ready for your command...`n" -ForegroundColor Cyan

    $asciiArt = @(   
        "@@@@@@@@@@@@@@@@@@██╗  ██╗██╗  ██╗ ██████╗ ██╗  ██╗@@@@@@@@@@@@@@@@@@                           "
        "@@@@@@@@@@@@@@@@@@╚██╗██╔╝██║  ██║██╔═══██╗██║  ██║@@@@@@@%%%%%@@@@@@                           "
        "@@@@%%%%%%%@@@@@@@ ╚███╔╝ ███████║██║   ██║███████║@@@@%%%#%%%%%%%@@@                           "
        "@%@##%%%%###%%@@@@ ██╔██╗ ╚════██║██║   ██║╚════██║@@%%##%%@@@@@#%%@@                   ██╗  ██╗"
        "@%%#%%@@%%%###%%@@██╔╝╚██╗     ██║╚██████╔╝     ██║%%##%%@@@@@@@##%%@                   ██║  ██║"
        "@%%#%@%%@%%%%###%%╚═╝  ╚═╝     ╚═╝ ╚═════╝      ╚═╝##%%%%@@@@%@@##%@@                   ███████║"
        "@%%*%%#@%@%%%%##*#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%###%%%@@@@@@%@@##%@@→ live             ╚════██║"
        "@%%→ live@@@%%%###*#%@@# Launch live server@@@%%##%%%%@@@@@@@%%%##%@@                        ██║"
        "@@%##%#%%@@@@%%%#####%%@@@@@@@@@@@@@@@@@@@@@%%##%%%%%%@@@@@@@%%%*%%@@                        ╚═╝"
        "@@%%*%#%%%@@@@@%%%###*#%@@@@@@@@@@@@@@@@@@@%%##%%%%%%@@@@@@@%%%%#%@@@→ deploy-                  "
        "@@%→ deploy-@@@@@%%### Deploy to Vercel, Firebase, or Heroku%%%##%@@@                           "
        "@@@%#*##%%@@@@@@@@@%%###*#%@@@@@@@@@@@@@%%#%%%%%%@@@@@@@@@%%%%%*%%@@@                           "
        "@@@%%*##%%@@@@@@@@@@%%#####%%@@@@@@@@@@%##%%%%%%@@@@@@@@@%%%%%##%@@@@→ copilot-auth             "
        "@@@→ copilot-auth@@@@# GitHub Copilot CLI login@@@@@@@@@@%%%%%*%%@@@@                   ██████╗   ██╗  ██╗"
        "@@@@%%*###%%@@@@@@@@@@%%%#%#*%@@@@@%%%#%@%%%%%@@@@@@@@@@%%%%%##%@@@@@                  ██╔═══██╗  ╚██╗██╔╝"
        "@@@@@%#*##%%@@@@@@@@@@@%%%#%%##%%@@%%#%@%%@%%@@@@@@@@@@@%%%%%*%%@@@@@→ hf-login        ██║   ██║   ╚███╔╝ "
        "@@@→ hf-login@@@@@@@@# Hugging Face CLI login@@@@@@@@@@%%%%%*#%@@@@@@                  ██║   ██║   ██╔██╗ "
        "@@@@@@%%*###%%@@@@@@@@@@@%%%#%#*#%%#%@%%@@%%@@@@@@@@@@%%%%%##%@@@@@@@                  ╚██████╔╝  ██╔╝╚██╗"
        "@@@@@@@%#*##%%%@@@@@@@@@@%%%##%#*%##%@%%%@%@@@@@@@@@@%%%%%%#%%@@@@@@@→ api <url>        ╚═════╝   ╚═╝  ╚═╝"
        "@@@→ api <url>%%@@@@@# Test REST API via httpie@@@@@%%%%%%#%%@@@@@@@@                           "
        "@@@@@@@@%%*#%#%%%@@@@@@@@%%%%##%#+#%%%%@@@%@@@@@@@@%%%%%%##%@@@@@@@@@                           "
        "@@@@@@@@@%%*#%#%%%@@@@@@%%%@#%#%#*#%@#@%@@@@@@@@@@@@@%%%##%@@@@@@@@@@→ fzf                      "
        "@@@→ fzf*@%%*#%#%%%@@# Start fuzzy file search@@@@@@%%%##%@@@@@@@@@@@                           "
        "@@@@@@@@@@@%%##%%%%%@@@@@%@%%%###%##%%@%@@@@@@@@@@@%@%##%%@@@@@@@@@@@                   ██╗  ██╗"
        "@@@@@@@@@@@@%%##%%%%@@@@@@%%@%###%##%%@@%@@@@@@@@%%@%##%%@@@@@@@@@@@@→ deletehistory    ██║  ██║"
        "@@@→ deletehistory%%%# Delete selected history from search@@@@@@@@@@@                   ███████║"
        "@@@@@@@@@@@@@@%@%##%@@@@@@@@%%#%%@%%%%@@@@@@@@@@@@%#%%@@@@@@@@@@@@@@@                   ╚════██║"
        "@@@@@@@@@@@@@@@@@%##%%@@@@@%%#%@%@%%%#%@@@@@@@@@%#%%%@@@@@@@@@@@@@@@@→ basefuncs             ██║"
        "@@@→ basefuncs@@@@@%%# Show list of some custom utility functions@@@@                        ╚═╝"
        "@@@@@@@@@@@@@@@@@@@@@@%%%%%%@@@@@@%@@@@%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@                           "
        "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@→ clifuncs                 "
        "@@@→ clifuncs@@@@@@@@# Show list of all dev, test, utility & CLI functions                      "
    )
    # Mapping from keywords to fixed colors
    $fixedColorsMap = @{
        "→ live"          = "Green"
        "→ deploy"        = "DarkCyan"
        "→ copilot-auth"  = "Gray"
        "→ hf-login"      = "White"
        "→ api"           = "Green"
        "→ fzf"           = "DarkGray"
        "→ deletehistory" = "Red"
        "→ basefuncs"     = "Blue"
        "→ clifuncs"      = "Magenta"
    }

    $randomColors = @("Cyan", "Magenta", "Yellow", "Green", "Blue")

    foreach ($line in $asciiArt) {
        # Check if line contains any fixed keyword
        $foundColor = $null
        foreach ($keyword in $fixedColorsMap.Keys) {
            if ($line -like "*$keyword*") {
                $foundColor = $fixedColorsMap[$keyword]
                break
            }
        }

        if ($foundColor) {
            # Use fixed color for this line
            Write-Host $line -ForegroundColor $foundColor
        }
        else {
            # Use random color
            $color = Get-Random -InputObject $randomColors
            Write-Host $line -ForegroundColor $color
        }
        Start-Sleep -Milliseconds 5
    }

}
# Run animations with 200ms gap
Run-SharkAnimation
Start-Sleep -Milliseconds 200
Run-BannerAnimation