# 🚀 Create new Next.js app
function nextnew {
    param([string]$name)
    if (-not $name) {
        Write-Host "Usage: nextnew <project-name>"
        return
    }
    npx create-next-app@latest $name
}

# 🏁 Start development server
function nextdev { npm run dev }

# 🏗 Build for production
function nextbuild { npm run build }

# ⚡️ Start production server
function nextstart { npm start }

# 🔁 Export static version (if using `next export`)
function nextexport { npm run export }

# 📁 Generate pages (just creates file structure)
function make-page {
    param([string]$name)
    $path = "pages\$name.tsx"
    New-Item -ItemType File -Path $path -Force | Out-Null
    Write-Host "Created page: $path"
}

# 🧩 Create API route file
function make-api {
    param([string]$name)
    $path = "pages\api\$name.ts"
    New-Item -ItemType File -Path $path -Force | Out-Null
    Write-Host "Created API route: $path"
}
# function myfuncs {
#     Write-Host "Available functions:"
#     Get-ChildItem function: | Where-Object { $_.Name -like 'myfuncs*' } | ForEach-Object { Write-Host $_.Name }
# }