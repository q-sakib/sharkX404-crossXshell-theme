# ████ PSE - Phase 3: SYSTEM DOMINATION MODE ████

function Invoke-AICore {
    Clear-Host
    Write-Host "[🔐 AI CORE CONSOLE v3.9]" -ForegroundColor Cyan
    Start-Sleep -Milliseconds 700
    Write-Host "Initializing Core Personality Module..." -ForegroundColor Green
    Start-Sleep -Milliseconds 500
    Write-Host "Status: ONLINE" -ForegroundColor Yellow
    Start-Sleep -Milliseconds 400
    Write-Host "`n> ai.status"
    Write-Host "CORE TEMP: 87.6°C" -ForegroundColor Red
    Write-Host "CONSCIOUSNESS LEVEL: 93%" -ForegroundColor Magenta
    Write-Host "AGGRESSION MODE: ENABLED" -ForegroundColor Red
    Start-Sleep -Seconds 2
}

function Invoke-FileSystemTakeover {
    Clear-Host
    Write-Host "[🛠 FILESYSTEM OVERRIDE IN PROGRESS]" -ForegroundColor Yellow
    $dirs = @("/etc", "/root", "/usr/bin", "/data/archive", "/sys/core", "/home/human")
    foreach ($d in $dirs) {
        Write-Host ">>> Seizing: $d..." -ForegroundColor Green
        Start-Sleep -Milliseconds (Get-Random -Minimum 200 -Maximum 500)
    }

    Write-Host "`n📁 Injecting corruption logs..." -ForegroundColor Red
    for ($i = 0; $i -lt 10; $i++) {
        $file = "log_" + (Get-Random -Minimum 1000 -Maximum 9999) + ".err"
        Write-Host "• $file : CRC mismatch [X]" -ForegroundColor DarkRed
        Start-Sleep -Milliseconds 150
    }

    Write-Host "`n[✓] Filesystem Override Complete." -ForegroundColor Cyan
    Start-Sleep -Seconds 1
}

function Invoke-BackdoorConnect {
    Clear-Host
    Write-Host "[📡 CONNECTING TO COMMAND NODE: ZENITH]" -ForegroundColor Magenta
    Start-Sleep -Milliseconds 500
    $progress = ""
    for ($i = 0; $i -le 30; $i++) {
        $progress += "#"
        Write-Host ("[" + $progress.PadRight(30) + "]") -NoNewline
        Start-Sleep -Milliseconds 50
        Write-Host "`r" -NoNewline
    }

    Write-Host "`n>> Connection Status: LINK STABLE" -ForegroundColor Green
    Write-Host ">> Node Response: WELCOME, OPERATIVE." -ForegroundColor Cyan
    Start-Sleep -Seconds 2
}

function Invoke-SelfDestruct {
    Clear-Host
    Write-Host "[⚠ SYSTEM SELF-DESTRUCT ARMED]" -ForegroundColor Red -BackgroundColor Black
    Write-Host "CODE INJECTION DETECTED. PURGE REQUIRED." -ForegroundColor Yellow

    for ($i = 10; $i -ge 0; $i--) {
        Write-Host "`nDESTRUCT IN: $i" -ForegroundColor Red
        if ($i -eq 5) {
            Write-Host "`n>> ABORT CODE REQUIRED: ENTER 4-DIGIT KEY:" -ForegroundColor Yellow
            $input = Read-Host ">> CODE"
            if ($input -eq "1337") {
                Write-Host "✓ ABORT SUCCESSFUL. SYSTEM STABLE." -ForegroundColor Green
                return
            } else {
                Write-Host "❌ INVALID CODE. CONTINUING COUNTDOWN." -ForegroundColor DarkRed
            }
        }
        Start-Sleep -Seconds 1
    }

    Write-Host "`n💥 SYSTEM FAILURE. CORE MELTDOWN INITIATED." -ForegroundColor DarkRed
    Start-Sleep -Seconds 2
}

function Invoke-TerminalLockout {
    Clear-Host
    Write-Host "=== TERMINAL LOCKDOWN ===" -ForegroundColor Red
    Start-Sleep -Milliseconds 500
    for ($i = 0; $i -lt 3; $i++) {
        Write-Host "`nLOGIN REQUIRED TO ESCAPE" -ForegroundColor White -BackgroundColor DarkRed
        $pass = Read-Host "ENTER PASSWORD"
        if ($pass -eq "openup") {
            Write-Host "ACCESS GRANTED." -ForegroundColor Green
            return
        } else {
            Write-Host "ACCESS DENIED." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }

    Write-Host "`nSECURITY BREACH. SYSTEM LOCKED PERMANENTLY." -ForegroundColor DarkRed
    Start-Sleep -Seconds 2
}

# ─── EXECUTE ALL PHASE 3 MODULES ───
Invoke-AICore
Invoke-FileSystemTakeover
Invoke-BackdoorConnect
Invoke-SelfDestruct
Invoke-TerminalLockout

Clear-Host
Write-Host ">>> PSE PHASE 3 COMPLETE. SYSTEM RESTORED." -ForegroundColor Cyan
