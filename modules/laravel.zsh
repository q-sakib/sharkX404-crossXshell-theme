# =====================================================================
# 🎯 Laravel — Artisan + Composer + PHP + testing shortcuts
# =====================================================================

# ── Base ──────────────────────────────────────────────────────────────
art()    { php artisan "$@"; }
tinker() { php artisan tinker; }

# ── New project ───────────────────────────────────────────────────────
laravelnew() {
    local name=${1:-my-app}
    if command -v laravel &>/dev/null; then
        laravel new "$name"
    else
        composer create-project laravel/laravel "$name"
    fi
}

# ── Serve ─────────────────────────────────────────────────────────────
arts()  { php artisan serve; }
artsd() { php artisan serve --host=0.0.0.0 --port="${1:-8000}"; }

# ── Migrations ────────────────────────────────────────────────────────
artm()   { php artisan migrate; }
artmf()  { php artisan migrate:fresh; }
artmfs() { php artisan migrate:fresh --seed; }
artms()  { php artisan migrate --seed; }
artmr()  { php artisan migrate:rollback; }
artmst() { php artisan migrate:status; }
artmre() { php artisan migrate:refresh; }
artmres(){ php artisan migrate:refresh --seed; }

# ── Seeding ───────────────────────────────────────────────────────────
artseed()  { php artisan db:seed; }
artseeds() { php artisan db:seed --class="$1"; }

# ── Cache & Optimize ──────────────────────────────────────────────────
artcc()    { php artisan cache:clear; }
artvc()    { php artisan view:clear; }
artrc()    { php artisan route:clear; }
artoc()    { php artisan optimize:clear; }
arto()     { php artisan optimize; }
artcfg()   { php artisan config:cache; }
artcache() { php artisan config:cache && php artisan route:cache && php artisan view:cache; }
artclear() { php artisan cache:clear && php artisan config:clear && php artisan route:clear && php artisan view:clear; }

# ── Routes ────────────────────────────────────────────────────────────
artrl()  { php artisan route:list; }
artrlf() { php artisan route:list --path="${1}"; }
artrls() { php artisan route:list | grep "${1}"; }

# ── Key & Storage ─────────────────────────────────────────────────────
artk()  { php artisan key:generate; }
artsl() { php artisan storage:link; }

# ── Queue ─────────────────────────────────────────────────────────────
artq()      { php artisan queue:work; }
artql()     { php artisan queue:listen; }
artqf()     { php artisan queue:failed; }
artqr()     { php artisan queue:retry all; }
artqflush() { php artisan queue:flush; }
artqtable() { php artisan queue:table; }

# ── Schedule ──────────────────────────────────────────────────────────
artsc()  { php artisan schedule:run; }
artsrv() { php artisan schedule:work; }

# ── Make — Controllers ────────────────────────────────────────────────
mkc()    { php artisan make:controller "$@"; }
mkcr()   { php artisan make:controller "$1" --resource; }
mkcra()  { php artisan make:controller "$1" --api; }
mkcri()  { php artisan make:controller "$1" --resource --model="$2"; }

# ── Make — Models ─────────────────────────────────────────────────────
mkm()    { php artisan make:model "$@"; }
mkmm()   { php artisan make:model "$1" -m; }          # model + migration
mkmmf()  { php artisan make:model "$1" -mf; }         # model + migration + factory
mkmmfs() { php artisan make:model "$1" -mfs; }        # model + migration + factory + seed
mkmcr()  { php artisan make:model "$1" -mcr; }        # model + migration + controller (resource)
mkall()  { php artisan make:model "$1" -a; }          # model + all (migration/factory/seeder/controller)

# ── Make — Database ───────────────────────────────────────────────────
mkmig()   { php artisan make:migration "$@"; }
mks()     { php artisan make:seeder "$@"; }
mkf()     { php artisan make:factory "$@"; }

# ── Make — HTTP ───────────────────────────────────────────────────────
mkr()    { php artisan make:request "$@"; }
mkres()  { php artisan make:resource "$@"; }
mkresc() { php artisan make:resource "$1" --collection; }
mkmw()   { php artisan make:middleware "$@"; }
mkrule() { php artisan make:rule "$@"; }

# ── Make — Events & Jobs ──────────────────────────────────────────────
mke()    { php artisan make:event "$@"; }
mklst()  { php artisan make:listener "$@"; }
mkj()    { php artisan make:job "$@"; }
mknot()  { php artisan make:notification "$@"; }
mkch()   { php artisan make:channel "$@"; }
mkmail() { php artisan make:mail "$@"; }

# ── Make — Auth & Policy ──────────────────────────────────────────────
mkp()    { php artisan make:policy "$@"; }
mkpwm()  { php artisan make:policy "$1" --model="$2"; }
mko()    { php artisan make:observer "$@"; }
mkscop() { php artisan make:scope "$@"; }

# ── Make — Other ──────────────────────────────────────────────────────
mkcmd()  { php artisan make:command "$@"; }
mktest() { php artisan make:test "$@"; }
mktstu() { php artisan make:test "$1" --unit; }
mkex()   { php artisan make:exception "$@"; }
mkcas()  { php artisan make:cast "$@"; }
mkenum() { php artisan make:enum "$@"; }
mkpro()  { php artisan make:provider "$@"; }
mkfac()  { php artisan make:facade "$@"; }

# ── Composer ──────────────────────────────────────────────────────────
ci()     { composer install; }
cu()     { composer update; }
cr()     { composer require "$@"; }
crdev()  { composer require --dev "$@"; }
crm()    { composer remove "$@"; }
cdump()  { composer dump-autoload; }
cdumpo() { composer dump-autoload --optimize; }
cv()     { composer validate; }
coutd()  { composer outdated; }
cscripts(){ composer run-script --list; }
crun()   { composer run-script "$@"; }

# ── PHP utilities ─────────────────────────────────────────────────────
phpdev()  { php -S "localhost:${1:-8000}"; }
phplint() { php -l "$@"; }

# ── PHP testing ───────────────────────────────────────────────────────
pest()    { ./vendor/bin/pest "$@"; }
pestcov() { ./vendor/bin/pest --coverage; }
pestpar() { ./vendor/bin/pest --parallel; }
phpunit() { ./vendor/bin/phpunit "$@"; }
phpcs()   { ./vendor/bin/phpcs "$@"; }
phpcbf()  { ./vendor/bin/phpcbf "$@"; }

# ── artisan help viewer ───────────────────────────────────────────────
arthelp() {
    printf "\n${C_CYAN}🎯 Laravel Artisan & Composer Shortcuts:${C_RESET}\n"
    printf "  ${C_GRAY}──────────────────────────────────────────────────────────────${C_RESET}\n"
    local -a rows=(
        "art <cmd>|php artisan <cmd>|Universal artisan shortcut"
        "tinker|php artisan tinker|Interactive REPL"
        "arts / artsd|artisan serve|Start dev server"
        "artm / artmf / artmfs|migrate / fresh / fresh+seed|Run migrations"
        "artmr / artms / artmst|rollback / seed / status|Migration variants"
        "artseed|db:seed|Run database seeder"
        "artcc / artvc / artrc|cache/view/route:clear|Clear caches"
        "artoc / artclear|optimize:clear / all clears|Nuclear cache clear"
        "artrl / artrlf / artrls|route:list|List routes (+ filter)"
        "artk / artsl|key:generate / storage:link|Key & storage"
        "artq / artql|queue:work / queue:listen|Queue workers"
        "artqf / artqr / artqflush|failed/retry/flush|Queue management"
        "artsc / artsrv|schedule:run / work|Scheduler"
        "---|||"
        "mkc / mkcr / mkcra|make:controller|Controller (plain/resource/api)"
        "mkm / mkmm / mkall|make:model|Model (plain/+migration/all)"
        "mkmmfs|make:model -mfs|Model+migration+factory+seeder"
        "mkmig / mks / mkf|make:migration/seeder/factory|Database classes"
        "mkr / mkres / mkmw|make:request/resource/middleware|HTTP classes"
        "mke / mklst / mkj|make:event/listener/job|Async classes"
        "mkp / mkpwm / mko|make:policy/observer|Auth classes"
        "mkcmd / mktest / mkex|make:command/test/exception|Other classes"
        "---|||"
        "ci / cu / cr / crdev|composer install/update/require|Composer"
        "crm / cdump / coutd|remove/dump-autoload/outdated|Composer extras"
        "pest / pestcov / phpunit|testing|PHP test runners"
        "phpdev [port]|php -S localhost:port|PHP built-in server"
    )
    for row in "${rows[@]}"; do
        [[ "$row" == "---|||" ]] && { printf "  ${C_GRAY}──────────────────────────────────────────────────────────────${C_RESET}\n"; continue; }
        local alias_name="${row%%|*}"
        local rest="${row#*|}"
        local cmd="${rest%%|*}"
        local desc="${rest#*|}"
        printf "  ${C_GREEN}→ ${C_YELLOW}%-28s${C_WHITE}%-22s${C_GRAY}# %s${C_RESET}\n" "$alias_name" "$cmd" "$desc"
    done
    printf "\n"
}
