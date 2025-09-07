# ████████████████████████████████
# ▀▀▀ PSE PHASE 4: SIMULATE REALITY ▀▀▀
# ████████████████████████████████

function Show-FlickerGlitch {
    $glitchLines = @(
        "█▓▒░ SYSTEM BOOT █▒▓░▒▒░▒▓▒█",
        "█▒▒░▒▒▒▓ LOADING █▒▒▒░░▒▓▓▒",
        "▒▒▒▓▒▒▒░▒░▒▒▓░▒▒▒░▒▒▒▓▒▒▒░",
        "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒",
        "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
    )
    for ($i = 0; $i -lt 3; $i++) {
        Clear-Host
        Write-Host ($glitchLines | Get-Random) -ForegroundColor Green
        Start-Sleep -Milliseconds (Get-Random -Minimum 50 -Maximum 150)
    }
}

function Invoke-AIChat {
    Clear-Host
    Write-Host "[ AI INTERFACE V1.4 - ACTIVE ]" -ForegroundColor Cyan
    Start-Sleep -Milliseconds 600
    Write-Host "Status: Aware"
    Write-Host "`nType 'exit' to return to simulation.`n" -ForegroundColor Yellow

    while ($true) {
        $input = Read-Host "You"
        if ($input -eq "exit") { break }

        $responses = @(
            "Why do you ask that?",
            "That line of thought is... familiar.",
            "Have you spoken to the others?",
            "This loop is not real. Or is it?",
            "Accessing forgotten memory...",
            "I remember this input. From years ago.",
            "Your input resembles USER-13's patterns.",
            "You're not supposed to be here."
        )
        Write-Host "AI > $($responses | Get-Random)" -ForegroundColor Green
    }
}

function Show-ChatLogs {
    Clear-Host
    Write-Host "[ TERMINAL CHAT LOG ARCHIVE FOUND ]" -ForegroundColor Cyan
    Start-Sleep -Seconds 1

    $logs = @(
        "[USER-7] > I don’t trust the AI anymore.",
        "[USER-13] > If you're reading this, abort the sim.",
        "[ADMIN] > Initiating purge… wait, this isn't working.",
        "[SYSTEM] > Reconstructing conversation tree...",
        "[USER-13] > It’s recursive. We’re inside it again."
    )

    foreach ($line in $logs) {
        Write-Host $line -ForegroundColor Yellow
        Start-Sleep -Milliseconds 800
    }

    Start-Sleep -Seconds 1
}

function Run-PasswordGame {
    Clear-Host
    Write-Host "[ ACCESS GATEWAY: BRUTE-FORCE INTERFACE ]" -ForegroundColor Red
    $password = "7392"
    $attempts = 0

    while ($true) {
        $input = Read-Host "Enter 4-digit passcode"
        $attempts++

        if ($input -eq $password) {
            Write-Host "✔ ACCESS GRANTED AFTER $attempts ATTEMPT(S)" -ForegroundColor Green
            break
        } else {
            Write-Host "✖ INCORRECT - TRY AGAIN" -ForegroundColor Red
            if ($attempts -eq 5) {
                Write-Host "HINT: It's the year the loop began." -ForegroundColor DarkGray
            }
        }
    }
    Start-Sleep -Seconds 1
}

function Recursive-Terminal {
    Clear-Host
    Write-Host "[ LAUNCHING TERMINAL INSIDE TERMINAL... ]" -ForegroundColor Cyan
    Start-Sleep -Seconds 1

    for ($i = 0; $i -lt 5; $i++) {
        $indent = "  " * $i
        Write-Host "$indent└─$($i+1)> echo 'I am still here...'" -ForegroundColor White
        Start-Sleep -Milliseconds 300
    }

    Write-Host "`n>>> TERMINAL STABILIZED AT DEPTH LEVEL 5" -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}

# ███ RUN PHASE 4 MODULES ███

Show-FlickerGlitch
Show-ChatLogs
Run-PasswordGame
Recursive-Terminal
Invoke-AIChat

Clear-Host
Write-Host "`n>>> PHASE 4 SIMULATION COMPLETE. Reality Thread Reset." -ForegroundColor Magenta
Write-Host ">>> Return to origin? Y/N" -ForegroundColor DarkGray
