# 📂 Open VS Code in current directory
function codehere { code . }

# 🚀 Start Live Server (great for static HTML/JS/CSS)
function live { npx live-server }

# 🧪 Run Node app with auto-reload (default: index.js or specify a file)
function dev {
    param([string]$file = "index.js")
    # param([string]$file = "index.js || main.js || app.js")
    nodemon $file
}

# 📄 Pretty-print JSON strings
function jsonpretty {
    param([string]$json)
    if (-not $json) {
        Write-Host "Usage: jsonpretty '<json-string>'"
        return
    }
    $json | ConvertFrom-Json | ConvertTo-Json -Depth 10
}

# ⚛️ React / Next.js / Vue CLI scaffolding
function create-react { npx create-react-app @args }
function create-next  { npx create-next-app@latest @args }
function create-vue   { npm create vue@latest @args }

# 📦 Angular CLI shortcut
function ngnew {
    param([string]$name)
    if (-not $name) {
        Write-Host "Usage: ngnew MyApp"
        return
    }
    ng new $name
}

# 🎯 Laravel project setup
function laravelnew {
    param([string]$name)
    if (-not $name) {
        Write-Host "Usage: laravelnew my-project"
        return
    }
    laravel new $name
}

# ☁️ Deployment Shortcuts
function deploy-vercel   { vercel --prod }
function deploy-firebase { firebase deploy }
function deploy-heroku {
    param([string]$app = "")
    git push heroku main
    if ($app -ne "") { heroku open --app $app }
}

# 🧹 Laravel Artisan shortcut
function art {
    param([string]$command)
    if (-not $command) {
        php artisan
    } else {
        php artisan $command
    }
}
