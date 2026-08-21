# =====================================================================
# 🌐 Web Dev — Scaffolding, frameworks, Prisma, deploy, boilerplates
# =====================================================================

# ── Project scaffolding ───────────────────────────────────────────────
create-react()      { npx create-react-app "${1:-my-app}"; }
create-next()       { npx create-next-app@latest "${1:-my-app}"; }
create-vue()        { npm create vue@latest "${1:-my-app}"; }
create-nuxt()       { npx nuxi@latest init "${1:-my-app}"; }
create-svelte()     { npm create svelte@latest "${1:-my-app}"; }
create-astro()      { npm create astro@latest "${1:-my-app}"; }
create-remix()      { npx create-remix@latest "${1:-my-app}"; }
create-t3()         { npm create t3-app@latest "${1:-my-app}"; }
create-vite()       { npm create vite@latest "${1:-my-app}"; }
create-vite-react() { npm create vite@latest "${1:-my-app}" -- --template react-ts; }
create-vite-vue()   { npm create vite@latest "${1:-my-app}" -- --template vue-ts; }
create-vite-svelte(){ npm create vite@latest "${1:-my-app}" -- --template svelte-ts; }

# ── Next.js shortcuts ─────────────────────────────────────────────────
alias nxdev='next dev'
alias nxbuild='next build'
alias nxstart='next start'
alias nxlint='next lint'

# ── Vite shortcuts ────────────────────────────────────────────────────
alias vb='vite build'
alias vp='vite preview'

# ── Dev server shortcuts ───────────────────────────────────────────────
live() { live-server "${@:-.}"; }
dev()  { npm run dev; }
alias codehere='code .'

# ── Code quality ──────────────────────────────────────────────────────
alias eslint-fix='eslint --fix .'
alias prettier-fix='prettier --write .'
lint() {
    if [[ -f package.json ]] && node -e "require('./package.json').scripts.lint" &>/dev/null 2>&1; then
        npm run lint
    elif command -v eslint &>/dev/null; then
        eslint .
    else
        printf "${C_YELLOW}No lint script found.${C_RESET}\n"
    fi
}

# ── Prisma (ORM) ──────────────────────────────────────────────────────
alias prisma-init='npx prisma init'
alias prisma-gen='npx prisma generate'
alias prisma-push='npx prisma db push'
alias prisma-pull='npx prisma db pull'
alias prisma-migrate='npx prisma migrate dev'
alias prisma-migrate-prod='npx prisma migrate deploy'
alias prisma-studio='npx prisma studio'
alias prisma-seed='npx prisma db seed'
alias prisma-reset='npx prisma migrate reset'
alias prisma-format='npx prisma format'

# ── Deploy ────────────────────────────────────────────────────────────
alias deploy-vercel='vercel --prod'
alias deploy-firebase='firebase deploy'
deploy-heroku() {
    git push heroku main
    [[ -n "$1" ]] && heroku open --app "$1"
}
alias deploy-netlify='netlify deploy --prod'

# ── API testing (httpie) ──────────────────────────────────────────────
api()      { http "$@"; }
api-get()  { http GET "$@"; }
api-post() { http POST "$@"; }

# ── Boilerplate generators (pipe to a file) ───────────────────────────
make-express() {
    cat <<'TMPL'
const express = require('express');
const app = express();
app.use(express.json());

app.get('/', (req, res) => res.json({ message: 'API running' }));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server on port ${PORT}`));
TMPL
}

make-mongoose-model() {
    local name=${1:-User}
    cat <<TMPL
const mongoose = require('mongoose');

const ${name}Schema = new mongoose.Schema({
  name:      { type: String, required: true },
  email:     { type: String, required: true, unique: true },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('${name}', ${name}Schema);
TMPL
}

make-prisma-model() {
    local name=${1:-User}
    cat <<TMPL
model ${name} {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  name      String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
TMPL
}

make-jwt() {
    cat <<'TMPL'
const jwt = require('jsonwebtoken');

const sign   = (payload) => jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1d' });
const verify = (token)   => jwt.verify(token, process.env.JWT_SECRET);

module.exports = { sign, verify };
TMPL
}

make-env() {
    cat <<'TMPL'
# App
APP_NAME=myapp
APP_ENV=development
APP_PORT=3000

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/mydb

# Auth
JWT_SECRET=changeme

# External APIs
# API_KEY=
TMPL
}
