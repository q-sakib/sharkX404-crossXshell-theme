# Load .env
Get-Content .env | ForEach-Object {
    if ($_ -match "^\s*([^#][^=]+)=(.+)$") {
        [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
    }
}

Write-Host "🔧 Configuring Git (Windows)"

git config --global user.name "$env:NAME"
git config --global user.email "$env:EMAIL"
git config --global pull.rebase false
git config --global init.defaultBranch master
git config --global core.autocrlf true
git config --global core.editor "code --wait"

# Credential manager
git config --global credential.helper manager
git config --global credential.username "$env:BB_USER"

# Prefer HTTPS, fallback to SSH
git config --global url."https://bitbucket.org/".insteadOf git@bitbucket.org:

Write-Host "✅ Git configured"
Write-Host "➡️ Run ssh-setup.ps1 to enable SSH fallback"

# Optional: first clone using token (saves token in Credential Manager)
# git clone https://$env:BB_USER:$env:BB_TOKEN@bitbucket.org/<workspace>/<repo>.git
