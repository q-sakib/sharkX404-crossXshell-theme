# 🚀 Angular new project
function ngnew {
    param([string]$name)
    ng new $name
}

# 🧪 Angular generate component
function ngc {
    param([string]$name)
    ng generate component $name
}

# 🧠 Angular generate service
function ngs {
    param([string]$name)
    ng generate service $name
}

# 📦 Angular generate module
function ngm {
    param([string]$name)
    ng generate module $name
}

# 👨‍🏫 Angular generate class (e.g., model)
function ngmodel {
    param([string]$name)
    ng generate class $name
}

# 🎮 Angular generate directive
function ngd {
    param([string]$name)
    ng generate directive $name
}

# 🎛 Angular generate pipe
function ngp {
    param([string]$name)
    ng generate pipe $name
}

# 🧰 Angular generate guard
function ngg {
    param([string]$name)
    ng generate guard $name
}

# 🛠 Angular generate interface
function ngi {
    param([string]$name)
    ng generate interface $name
}

# 🚀 Angular serve
function ngserve {
    ng serve
}

function ngs-mem {
    param(
        [int]$Memory = 8192
    )

    node --max_old_space_size=$Memory ./node_modules/@angular/cli/bin/ng serve
}

function ngmserve {
    param(
        [switch]$e,                       # Efficient mode: always 4GB
        [switch]$ep,                      # Efficient Power: half of system RAM
        [Alias("p")] [int]$Port,          # Port shortcut
        [Alias("h")] [string]$HostName,  # Host shortcut (renamed to avoid conflict)
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$NgArgs                 # Extra ng serve args
    )

    # -----------------------------
    # Step 1: Determine memory
    # -----------------------------
    if ($e) {
        $Memory = 4096
    }
    elseif ($ep) {
        $totalMB = [math]::Floor((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1MB)
        $Memory = [math]::Floor($totalMB / 2)
        if ($Memory -lt 4096) { $Memory = 4096 }
    }
    else {
        $Memory = 8192
    }

    # -----------------------------
    # Step 2: Build ng serve command
    # -----------------------------
    $cmd = @(
        "node",
        "--max_old_space_size=$Memory",
        "./node_modules/@angular/cli/bin/ng",
        "serve"
    )

    if ($Port) { $cmd += "--port $Port" }
    if ($HostName) { $cmd += "--host $HostName" }
    if ($NgArgs) { $cmd += $NgArgs }

    # -----------------------------
    # Step 3: Execute
    # -----------------------------
    Write-Host "Running: $($cmd -join ' ')" -ForegroundColor Cyan
    & $cmd
}


# 🏗 Angular build
function ngbuild {
    ng build
}
# 📦 Angular deploy
function ngdeploy {
    ng deploy
}   