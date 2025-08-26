# AI and Copilot CLI
if (Get-Command copilot -ErrorAction SilentlyContinue) {
    function copilot-auth { copilot auth login }
} else {
    Write-Host "⚠️ Copilot CLI not found. Run: npm install -g @githubnext/copilot-cli" -ForegroundColor Yellow
}
function hf-login { huggingface-cli login }
