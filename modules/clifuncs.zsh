# =====================================================================
# 📋 clifuncs — List all loaded custom functions
# =====================================================================

get-dev-functions() {
    printf "\n${C_CYAN}🛠  All Loaded Functions:${C_RESET}\n"
    printf "  ${C_GRAY}─────────────────────────────────────────────────────────────${C_RESET}\n"

    local -a categories=(
        "Git:gs ga gaa gc gundo gp gpu gpf gpl gplr gf gll glog gco gcb gb gba gbd gbD gprune gd gds gst gstp gstl gcp grev greset grremote grc gclean ghelp"
        "File/ls:ls ll la lla"
        "Docker:dc dcu dcd dlog dclean"
        "Tools:ff myip load-env edit-env edit-config preview open-url"
        "System:sysinfo mac-arch bench try-run reload cls"
        "History:hgrep hclear deletehistory hdup"
        "Dev/HTTP:psg pk portcheck portopen ports jget jpost jput jdel httpstatus headers jpp jwt-decode serve ssl-check watch-cmd envcheck alive localip"
        "Scaffolding:create-react create-next create-vue create-nuxt create-svelte create-astro create-remix create-t3 create-vite create-vite-react create-vite-vue"
        "Next.js/Vite:nxdev nxbuild nxstart nxlint vb vp"
        "Angular:ngnew ngnewsc ngs ngso ngb ngbp ngt ngte ngl ngg ngc ngsvc ngm ngmr ngp ngd nggrd ngr ngi nge ngcl ngint nglib ngadd ngupdate ngv ng-add-material nghelp"
        "Laravel:art tinker laravelnew arts artsd artm artmf artmfs artmr artmst artmre artseed artcc artvc artrc artoc artclear artrl artk artsl artq artqf artsc"
        "Artisan make:mkc mkcr mkcra mkm mkmm mkall mkmmfs mkmig mks mkf mkr mkres mkmw mke mklst mkj mknot mkp mko mkcmd mktest mkex mkenum mkpro"
        "Composer/PHP:ci cu cr crdev crm cdump cv coutd phpdev phplint pest pestcov phpunit phpcs phpcbf arthelp"
        "npm:ni nid nig nu nug nr ns nt nb nd nci nls nlsg nout nup nfix nclean npkg"
        "yarn:ya yad yr ys yt yb yd yi yls yout yup yclean"
        "pnpm:pi pa pad prm prd pb pt pls pout pup pclean"
        "bun:bi ba bad brm brd bb bt bx bclean"
        "Smart pkg:run scripts reinstall pkgmgr"
        "nvm:nvmls nvmi nvmu nvmd nvmlts nvmalias"
        "Deploy:deploy-vercel deploy-firebase deploy-heroku deploy-netlify"
        "Prisma:prisma-init prisma-gen prisma-push prisma-pull prisma-migrate prisma-studio prisma-seed prisma-reset"
        "Boilerplate:make-express make-mongoose-model make-prisma-model make-jwt make-env"
        "AI:copilot-auth hf-login"
        "API:api api-get api-post"
        "PostgreSQL:pgstart pgstop pgrestart pgstatus pglogin pg pglist pgcreate pgdrop pgdump pgrestore"
        "MySQL:mystart mystop myrestart mystatus mylogin my mylist mycreate mydrop mydump myrestore dbhelp"
        "Simulation:run-startup-welcome shark-swim show-name-banner matrix-rain chaos-rain chaos-pattern chaos-text"
    )

    for cat in "${categories[@]}"; do
        local label="${cat%%:*}"
        local funcs="${cat#*:}"
        printf "\n  ${C_YELLOW}%-16s${C_RESET}" "$label"
        printf "${C_WHITE}%s${C_RESET}\n" "$funcs"
    done
    printf "\n"
    printf "  ${C_GRAY}Help: ghelp = git  |  nghelp = angular  |  arthelp = laravel  |  dbhelp = database${C_RESET}\n\n"
}
alias clifuncs='get-dev-functions'
