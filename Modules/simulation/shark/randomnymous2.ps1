function Run-BannerAnimation {
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
            "╚█████╗ ███████║███████║█████╔╝ ██║███████║",
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

    $termWidth = try { [console]::WindowWidth } catch { 80 }
    $selectedBanner = Get-Random -InputObject $banners
    $bannerWidth = ($selectedBanner | Measure-Object -Maximum Length).Maximum

    $maxPos = [math]::Max(0, $termWidth - $bannerWidth)
    $steps = 10
    $stepSize = [math]::Max(1, [math]::Floor($maxPos / $steps))

    for ($pos = 0; $pos -le $maxPos; $pos += $stepSize) {
        foreach ($line in $selectedBanner) {
            $spaces = " " * $pos
            Write-Host "$spaces$line" -ForegroundColor Blue
        }
        Start-Sleep -Milliseconds 20
    }

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
        $foundColor = $null
        foreach ($keyword in $fixedColorsMap.Keys) {
            if ($line -like "*$keyword*") {
                $foundColor = $fixedColorsMap[$keyword]
                break
            }
        }

        if ($foundColor) {
            Write-Host $line -ForegroundColor $foundColor
        } else {
            $color = Get-Random -InputObject $randomColors
            Write-Host $line -ForegroundColor $color
        }
        Start-Sleep -Milliseconds 2
    }
}

function start-shark-banner {
    if (Get-Command Run-SharkAnimation -ErrorAction SilentlyContinue) { Run-SharkAnimation }
    Start-Sleep -Milliseconds 100
    Run-BannerAnimation
}