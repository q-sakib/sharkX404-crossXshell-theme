# =====================================================================
# 🤖 AI Tools — GitHub Copilot CLI, HuggingFace
# =====================================================================

copilot-auth() {
    if command -v gh &>/dev/null; then
        gh auth login
    else
        printf "${C_YELLOW}⚠️  gh CLI not found. Install with: brew install gh${C_RESET}\n"
    fi
}

hf-login() {
    if command -v huggingface-cli &>/dev/null; then
        huggingface-cli login
    else
        printf "${C_YELLOW}⚠️  huggingface-cli not found. Install with: pip install huggingface_hub${C_RESET}\n"
    fi
}
