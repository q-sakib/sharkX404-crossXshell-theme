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
        "System:sysinfo mac-arch bench try-run reload cls"
        "History:hgrep hclear deletehistory hdup"
        "Dev/HTTP:psg pk portcheck portopen ports jget jpost jput jdel httpstatus headers jpp jwt-decode serve ssl-check watch-cmd alive localip envcheck"
        "PostgreSQL:pgstart pgstop pgrestart pgstatus pglogin pg pglist pgcreate pgdrop pgdump pgrestore"
        "MySQL:mystart mystop myrestart mystatus mylogin my mylist mycreate mydrop mydump myrestore"
        "DB Help:dbhelp"
        "Simulation:run-startup-welcome shark-swim show-name-banner matrix-rain chaos-rain chaos-pattern chaos-text"
    )

    for cat in "${categories[@]}"; do
        local label="${cat%%:*}"
        local funcs="${cat#*:}"
        printf "\n  ${C_YELLOW}%-12s${C_RESET}" "$label"
        printf "${C_WHITE}%s${C_RESET}\n" "$funcs"
    done
    printf "\n"
    printf "  ${C_GRAY}💡 ghelp = git reference  |  dbhelp = database reference${C_RESET}\n\n"
}
alias clifuncs='get-dev-functions'
