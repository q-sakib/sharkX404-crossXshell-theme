# 🚀 Create a new Node.js app (manual setup)
function nodenew {
    param([string]$name)
    if (-not $name) {
        Write-Host "Usage: nodenew <project-name>"
        return
    }
    mkdir $name
    cd $name
    npm init -y
    npm install express dotenv
    echo "const express = require('express');`nconst app = express();`nconst PORT = process.env.PORT || 3000;`n`napp.get('/', (req, res) => res.send('Hello World'));`n`napp.listen(PORT, () => console.log(\`Server running on port \${PORT}\`));" > index.js
    code .
}

# 🔁 Run Node.js with nodemon (watch mode)
function node--dev {
    param([string]$file = "index.js")
    nodemon $file
}

# 🛠 Create a basic controller file
function node--make-controller {
    param([string]$name)
    $path = "controllers\$name.controller.js"
    New-Item -ItemType File -Path $path -Force | Out-Null
    Write-Host "Created controller: $path"
}

# 🧠 Create a model file (for Mongoose or plain JS)
function node--make-model {
    param([string]$name)
    $path = "models\$name.model.js"
    New-Item -ItemType File -Path $path -Force | Out-Null
    Write-Host "Created model: $path"
}

# 🛣 Create a route file
function node--make-route {
    param([string]$name)
    $path = "routes\$name.routes.js"
    New-Item -ItemType File -Path $path -Force | Out-Null
    Write-Host "Created route: $path"
}

# ⚙️ Create a middleware file
function node--make-middleware {
    param([string]$name)
    $path = "middleware\$name.js"
    New-Item -ItemType File -Path $path -Force | Out-Null
    Write-Host "Created middleware: $path"
}
