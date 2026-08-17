# =====================================================================
# 🎨 Eza File Icons & Display Resilience (Zsh)
# =====================================================================

if command -v eza >/dev/null 2>&1; then
    alias ls="eza --icons --git --color=auto"
    alias ll="eza --icons --git --color=auto -l"
    alias la="eza --icons --git --color=auto -a"
else
    alias ls="ls -G"
    alias ll="ls -laG"
    alias la="ls -aG"
fi
