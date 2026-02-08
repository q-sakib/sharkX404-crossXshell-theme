# -----------------------------
# AI & Copilot CLI Helpers
# -----------------------------

# Guard: GitHub Copilot CLI
if (Get-Command copilot -ErrorAction SilentlyContinue) {

    function copilot-auth {
        copilot auth login
    }

} else {
    # Do NOT spam on module import — only warn when function is requested
    function copilot-auth {
        Write-Host "⚠️ Copilot CLI not found. Run: npm install -g @githubnext/copilot-cli" -ForegroundColor Yellow
    }
}

# Guard: Hugging Face CLI
if (Get-Command huggingface-cli -ErrorAction SilentlyContinue) {

    function hf-login {
        huggingface-cli login
    }

} else {
    function hf-login {
        Write-Host "⚠️ Hugging Face CLI not found. Run: pip install huggingface_hub" -ForegroundColor Yellow
    }
}
