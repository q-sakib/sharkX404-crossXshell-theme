# =====================================================================
# 🅰️  Angular CLI — full ng shortcut library
# =====================================================================

# ── New project ───────────────────────────────────────────────────────
ngnew()    { ng new "$@"; }
ngnewsc()  { ng new "$1" --standalone --style=scss --routing; }
ngnewts()  { ng new "$1" --style=scss --routing --strict; }

# ── Serve ─────────────────────────────────────────────────────────────
ngs()   { ng serve; }
ngso()  { ng serve --open; }
ngsssl(){ ng serve --ssl; }
ngshost(){ ng serve --host 0.0.0.0 --disable-host-check; }
ngsport(){ ng serve --port "${1:-4200}"; }

# ── Build ─────────────────────────────────────────────────────────────
ngb()   { ng build; }
ngbp()  { ng build --configuration production; }
ngbw()  { ng build --watch; }
ngbstat(){ ng build --stats-json; }

# ── Test ──────────────────────────────────────────────────────────────
ngt()   { ng test; }
ngte()  { ng e2e; }
ngtw()  { ng test --watch; }
ngtcov(){ ng test --code-coverage; }
ngl()   { ng lint; }
nglfix(){ ng lint --fix; }

# ── Generate — Components ─────────────────────────────────────────────
ngc()   { ng generate component "$@"; }
ngci()  { ng generate component "$1" --inline-template --inline-style; }
ngcs()  { ng generate component "$1" --style=scss; }
ngcst() { ng generate component "$1" --standalone; }

# ── Generate — Services & Modules ────────────────────────────────────
ngsvc() { ng generate service "$@"; }
ngm()   { ng generate module "$@"; }
ngmr()  { ng generate module "$1" --routing; }

# ── Generate — Routing ────────────────────────────────────────────────
ngp()   { ng generate pipe "$@"; }
ngd()   { ng generate directive "$@"; }
nggrd() { ng generate guard "$@"; }
ngr()   { ng generate resolver "$@"; }
ngi()   { ng generate interface "$@"; }
nge()   { ng generate enum "$@"; }
ngcl()  { ng generate class "$@"; }
ngint() { ng generate interceptor "$@"; }
ngenv() { ng generate environments; }

# ── Generic generate ─────────────────────────────────────────────────
ngg()   { ng generate "$@"; }

# ── Libraries & schematics ───────────────────────────────────────────
nglib()    { ng generate library "$@"; }
ngapp()    { ng generate application "$@"; }
ngadd()    { ng add "$@"; }
ngrun()    { ng run "$@"; }

# ── Update ────────────────────────────────────────────────────────────
ngupdate()     { ng update "@angular/core" "@angular/cli"; }
ngupdateall()  { ng update; }

# ── Info ──────────────────────────────────────────────────────────────
ngv()   { ng version; }
ngdoc() { ng doc "$@"; }
ngconf(){ ng config "$@"; }
ngana() { ng analytics "$@"; }

# ── Material ──────────────────────────────────────────────────────────
ng-add-material()  { ng add @angular/material; }
ng-add-pwa()       { ng add @angular/pwa; }
ng-add-eslint()    { ng add @angular-eslint/schematics; }

# ── Angular help viewer ───────────────────────────────────────────────
nghelp() {
    printf "\n${C_CYAN}🅰️  Angular CLI Shortcuts:${C_RESET}\n"
    printf "  ${C_GRAY}──────────────────────────────────────────────────────────────${C_RESET}\n"
    local -a rows=(
        "ngnew <name>|ng new|New project"
        "ngnewsc <name>|ng new --standalone --scss|Standalone + SCSS"
        "ngs / ngso|ng serve / --open|Dev server"
        "ngshost / ngsport|serve --host / --port|Custom host/port"
        "ngb / ngbp / ngbw|build / prod / watch|Build variants"
        "ngt / ngte / ngtcov|test / e2e / coverage|Testing"
        "ngl / nglfix|lint / --fix|Lint"
        "---|||"
        "ngc <name>|generate component|Component"
        "ngcst <name>|generate component --standalone|Standalone component"
        "ngsvc <name>|generate service|Service"
        "ngm <name>|generate module|Module"
        "ngmr <name>|generate module --routing|Module with routing"
        "ngp / ngd / ngg|pipe / directive / guard|Routing layer"
        "ngr / ngi / nge / ngcl|resolver/interface/enum/class|Misc"
        "ngint <name>|generate interceptor|HTTP interceptor"
        "---|||"
        "ngadd <pkg>|ng add|Add schematic package"
        "ngupdate|ng update @angular/core @angular/cli|Update Angular"
        "ngv|ng version|Angular version info"
        "ng-add-material|ng add @angular/material|Add Angular Material"
        "ng-add-pwa|ng add @angular/pwa|Add PWA support"
    )
    for row in "${rows[@]}"; do
        [[ "$row" == "---|||" ]] && { printf "  ${C_GRAY}──────────────────────────────────────────────────────────────${C_RESET}\n"; continue; }
        local alias_name="${row%%|*}"
        local rest="${row#*|}"
        local cmd="${rest%%|*}"
        local desc="${rest#*|}"
        printf "  ${C_GREEN}→ ${C_YELLOW}%-22s${C_WHITE}%-30s${C_GRAY}# %s${C_RESET}\n" "$alias_name" "$cmd" "$desc"
    done
    printf "\n"
}
