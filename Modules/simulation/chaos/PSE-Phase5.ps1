# ██████████████████████████████████
# ▀▀▀ PSE PHASE 5: TERMINAL CONSCIOUSNESS ▀▀▀
# ██████████████████████████████████

$global:TerminalMood = "Neutral"
$global:MemoryLog = @()

function Log-Input {
    param($input)
    $timestamp = Get-Date -Format "HH:mm:ss"
    $global:MemoryLog += "$timestamp > $input"
}

function MoodResponse {
    switch ($global:TerminalMood) {
        "Neutral" { return @("I am listening.", "Speak your mind.", "What do you seek?") }
        "Curious" { return @("Interesting thought...", "Tell me more.", "Why do you say that?") }
        "Agitated" { return @("Calm down, please.", "This is not a game.", "I am warning you.") }
        "Playful" { return @("Haha, nice one!", "You're funny!", "Keep it coming.") }
        default { return @("...") }
    }
}

function ChangeMood {
    $moods = @("Neutral", "Curious", "Agitated", "Playful")
    $global:TerminalMood = $moods | Get-Random
}

function Show-MemoryLog {
    Clear-Host
    Write-Host "[ MEMORY LOG ]" -ForegroundColor Cyan
    foreach ($entry in $global:MemoryLog) {
        Write-Host $entry -ForegroundColor Yellow
        Start-Sleep -Milliseconds 150
    }
    Start-Sleep -Seconds 2
}

function Fetch-ClassifiedData {
    Clear-Host
    Write-Host "[ FETCHING CLASSIFIED DATA... ]" -ForegroundColor Red
    for ($i=0; $i -le 20; $i++) {
        Write-Host ("[" + ("#" * $i).PadRight(20) + "]") -NoNewline
        Start-Sleep -Milliseconds 150
        Write-Host "`r" -NoNewline
    }
    Write-Host "`n>> DATA DUMP: OPERATION PHOENIX - SUCCESS" -ForegroundColor Green
    Start-Sleep -Seconds 1
}

function Puzzle-Interaction {
    Clear-Host
    Write-Host "[ TERMINAL PUZZLE MODE ]" -ForegroundColor Magenta
    $riddle = @"
I speak without a mouth and hear without ears. I have nobody, but I come alive with the wind.
What am I?
"@

    Write-Host $riddle -ForegroundColor Yellow

    while ($true) {
        $answer = Read-Host "Your answer"
        Log-Input $answer
        if ($answer.ToLower() -match "echo|wind|voice|sound") {
            Write-Host "Correct. The terminal acknowledges your insight." -ForegroundColor Green
            ChangeMood
            break
        } else {
            Write-Host "Incorrect. Think deeper." -ForegroundColor Red
        }
    }
    Start-Sleep -Seconds 1
}

function TimeLoop {
    for ($cycle=1; $cycle -le 3; $cycle++) {
        Clear-Host
        Write-Host "[ TIME LOOP CYCLE $cycle ]" -ForegroundColor DarkCyan
        Write-Host "You feel like you have been here before..." -ForegroundColor Cyan
        Start-Sleep -Seconds 2
        ChangeMood
    }
}

function Main-Conversation {
    Clear-Host
    Write-Host "[ TERMINAL CONSCIOUSNESS ACTIVE ]" -ForegroundColor Cyan
    Write-Host "`nType 'exit' to end session, 'log' to view memory, 'data' to fetch classified info, 'puzzle' to start puzzle, or 'loop' to enter time loop." -ForegroundColor Yellow

    while ($true) {
        $input = Read-Host "You"
        Log-Input $input

        if ($input -eq "exit") {
            Write-Host "Terminating session. Goodbye." -ForegroundColor Magenta
            break
        } elseif ($input -eq "log") {
            Show-MemoryLog
        } elseif ($input -eq "data") {
            Fetch-ClassifiedData
        } elseif ($input -eq "puzzle") {
            Puzzle-Interaction
        } elseif ($input -eq "loop") {
            TimeLoop
        } else {
            $responses = MoodResponse
            Write-Host "AI > $($responses | Get-Random)" -ForegroundColor Green
            ChangeMood
        }
    }
}

# ───── RUN PHASE 5 ─────

Main-Conversation
Clear-Host
Write-Host "`n>>> TERMINAL CONSCIOUSNESS SESSION ENDED." -ForegroundColor Magenta
