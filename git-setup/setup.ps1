$BB_USER = "YOUR_BITBUCKET_USERNAME"
$NAME = "Sakib SiddiQuie"
$EMAIL = "i.sak1uib@gmail.com"

Write-Host "🔧 Configuring Git (Windows)"

git config --global user.name "$NAME"
git config --global user.email "$EMAIL"
git config --global pull.rebase false
git config --global init.defaultBranch master
git config --global core.autocrlf true
git config --global core.editor "code --wait"

# Credential manager
git config --global credential.helper manager
git config --global credential.username "$BB_USER"

# Prefer HTTPS, fallback to SSH
git config --global url."https://bitbucket.org/".insteadOf git@bitbucket.org:

Write-Host "✅ Git configured"
Write-Host "➡️ Run ssh-setup.ps1 to enable SSH fallback"
