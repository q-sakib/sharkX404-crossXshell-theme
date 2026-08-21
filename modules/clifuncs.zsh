# =====================================================================
# 📋 clifuncs — List all loaded custom functions (like Get-DevFunctions)
# =====================================================================

get-dev-functions() {
    printf "\n${C_CYAN}🛠  All Loaded Functions:${C_RESET}\n"
    printf "  ${C_GRAY}─────────────────────────────────────────────────────────────${C_RESET}\n"

    local -a categories=(
        "Git:gs ga gaa gc gundo gp gpu gpf gpl gplr gf gll glog gco gcb gb gba gbd gbD gprune gd gds gst gstp gstl gcp grev greset grremote grc gclean ghelp"
        "File/ls:ls ll la lla"
        "Docker:dc dcu dcd dlog dclean"
        "Tools:ff myip load-env edit-env edit-config preview open-url"
        "Web Dev:create-react create-next create-vue ngnew laravelnew live dev"
        "API:api api-get api-post"
        "Deploy:deploy-vercel deploy-firebase deploy-heroku"
        "AI:copilot-auth hf-login"
        "System:sysinfo mac-arch bench try-run deletehistory reload"
        "Simulation:run-startup-welcome shark-swim show-name-banner matrix-rain chaos-rain chaos-pattern"
    )

    for cat in "${categories[@]}"; do
        local label="${cat%%:*}"
        local funcs="${cat#*:}"
        printf "\n  ${C_YELLOW}%-12s${C_RESET}" "$label"
        printf "${C_WHITE}%s${C_RESET}\n" "$funcs"
    done
    printf "\n"
}
alias clifuncs='get-dev-functions'
