# =====================================================================
# 🐳 Docker shortcuts
# =====================================================================

alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'

dlog() {
    local container=${1:-$(docker ps -q 2>/dev/null | head -1)}
    if [[ -z "$container" ]]; then
        printf "${C_YELLOW}No running containers found.${C_RESET}\n"; return 1
    fi
    docker logs "$container" --follow
}

dclean() {
    printf "${C_YELLOW}🧹 Pruning Docker system and volumes...${C_RESET}\n"
    docker system prune -f
    docker volume prune -f
    printf "${C_GREEN}✅ Docker cleaned.${C_RESET}\n"
}
