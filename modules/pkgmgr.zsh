# =====================================================================
# 📦 Package Managers — npm / yarn / pnpm / bun + smart detection
# =====================================================================

# ── npm ───────────────────────────────────────────────────────────────
ni()    { npm install "$@"; }
nid()   { npm install --save-dev "$@"; }
nig()   { npm install -g "$@"; }
nu()    { npm uninstall "$@"; }
nug()   { npm uninstall -g "$@"; }
nr()    { npm run "$@"; }
ns()    { npm start; }
nt()    { npm test; }
nb()    { npm run build; }
nd()    { npm run dev; }
nci()   { npm ci; }
nls()   { npm list --depth=0; }
nlsg()  { npm list -g --depth=0; }
nout()  { npm outdated; }
nup()   { npm update; }
nfix()  { npm audit fix; }
nfixf() { npm audit fix --force; }
nclean(){ rm -rf node_modules && npm install; }
npkg()  {
    if [[ -f package.json ]]; then
        command -v jq &>/dev/null && jq '.scripts' package.json || node -p "JSON.parse(require('fs').readFileSync('package.json','utf8')).scripts"
    else
        printf "${C_YELLOW}No package.json found.${C_RESET}\n"
    fi
}

# ── yarn ──────────────────────────────────────────────────────────────
ya()    { yarn add "$@"; }
yad()   { yarn add --dev "$@"; }
yr()    { yarn remove "$@"; }
ys()    { yarn start; }
yt()    { yarn test; }
yb()    { yarn build; }
yd()    { yarn dev; }
yi()    { yarn install; }
yls()   { yarn list --depth=0; }
yout()  { yarn outdated; }
yup()   { yarn upgrade; }
yclean(){ rm -rf node_modules && yarn install; }

# ── pnpm ──────────────────────────────────────────────────────────────
pi()    { pnpm install "$@"; }
pa()    { pnpm add "$@"; }
pad()   { pnpm add --save-dev "$@"; }
prm()   { pnpm remove "$@"; }
prd()   { pnpm dev; }
pb()    { pnpm build; }
pt()    { pnpm test; }
pls()   { pnpm list; }
pout()  { pnpm outdated; }
pup()   { pnpm update; }
pclean(){ rm -rf node_modules && pnpm install; }

# ── bun ───────────────────────────────────────────────────────────────
bi()    { bun install "$@"; }
ba()    { bun add "$@"; }
bad()   { bun add --dev "$@"; }
brm()   { bun remove "$@"; }
brd()   { bun dev; }
bb()    { bun build "$@"; }
bt()    { bun test; }
bx()    { bunx "$@"; }
bclean(){ rm -rf node_modules && bun install; }

# ── Smart project helpers ─────────────────────────────────────────────
# Detect which package manager this project uses
pkgmgr() {
    if   [[ -f bun.lockb ]];          then echo "bun"
    elif [[ -f pnpm-lock.yaml ]];     then echo "pnpm"
    elif [[ -f yarn.lock ]];          then echo "yarn"
    elif [[ -f package-lock.json ]];  then echo "npm"
    elif [[ -f package.json ]];       then echo "npm (no lockfile)"
    else echo "none"
    fi
}

# Smart run — picks the right package manager automatically
run() {
    local mgr
    mgr=$(pkgmgr)
    case "$mgr" in
        bun)  bun run "$@" ;;
        pnpm) pnpm run "$@" ;;
        yarn) yarn run "$@" ;;
        npm*) npm run "$@" ;;
        *)    printf "${C_YELLOW}No package.json found.${C_RESET}\n" ;;
    esac
}

# List scripts from package.json (works without jq)
scripts() {
    if [[ ! -f package.json ]]; then printf "${C_YELLOW}No package.json found.${C_RESET}\n"; return 1; fi
    if command -v jq &>/dev/null; then
        jq -r '.scripts | to_entries[] | "  \(.key)\t\(.value)"' package.json 2>/dev/null | column -t
    else
        node -e "const s=require('./package.json').scripts; Object.keys(s).forEach(k=>console.log('  '+k+'\t'+s[k]))"
    fi
}

# Reinstall cleanly using detected package manager
reinstall() {
    local mgr
    mgr=$(pkgmgr | cut -d' ' -f1)
    rm -rf node_modules
    printf "${C_CYAN}Clean install via %s...${C_RESET}\n" "$mgr"
    case "$mgr" in
        bun)  bun install ;;
        pnpm) pnpm install ;;
        yarn) yarn install ;;
        *)    npm install ;;
    esac
}

# nvm helpers (if nvm is available)
if command -v nvm &>/dev/null || [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    [[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
    nvmls()   { nvm list; }
    nvmi()    { nvm install "$@"; }
    nvmu()    { nvm use "$@"; }
    nvmd()    { nvm use default; }
    nvmlts()  { nvm install --lts && nvm use --lts; }
    nvmalias(){ nvm alias default "$(node -v)"; }
fi
