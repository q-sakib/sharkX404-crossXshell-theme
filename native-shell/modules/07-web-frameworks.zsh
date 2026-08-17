# =====================================================================
# 🌐 Fullstack Web Frameworks & ORM Tooling (Zsh)
# 100% Identical command names to PowerShell profile
# =====================================================================

# ⚛️ React, Next.js, Vue CLI Scaffolding
alias create-react="npx create-react-app"
alias create-next="npx create-next-app@latest"
alias create-vue="npm create vue@latest"

alias nextdev="npx next dev"
alias nextbuild="npx next build"
alias nextstart="npx next start"
alias nextexport="npx next build && npx next export"

nextnew() {
    create-next "$@"
}

# 🅰️ Angular CLI
alias ngnew="ng new"
alias ngserve="ng serve"
alias ngs="ng serve"
alias ngbuild="ng build"
alias ngb="ng build"
alias ngt="ng test"
alias ngg="ng generate"

# ☁️ Deployment Shortcuts
alias deploy-vercel="vercel --prod"
alias deploy-firebase="firebase deploy"

deploy-heroku() {
    git push heroku main
    if [[ -n "$1" ]]; then heroku open --app "$1"; fi
}

# 🐘 PHP & Laravel Artisan Shortcuts
alias art="php artisan"
alias art-serve="php artisan serve"
alias art-migrate="php artisan migrate"
alias art-migrate-rollback="php artisan migrate:rollback"
alias art-dbseed="php artisan db:seed"
alias laravelnew="laravel new"

art-make-controller() {
    php artisan make:controller "$1"
}

art-make-model() {
    php artisan make:model "$1" -m
}

art-make-migration() {
    php artisan make:migration "$1"
}

art-make-middleware() {
    php artisan make:middleware "$1"
}

# 🗄️ Database & ORM Helpers (Prisma & Mongoose)
alias prisma-generate="npx prisma generate"
alias prisma-migrate="npx prisma migrate dev"
alias prisma-studio="npx prisma studio"
alias prisma-init="npx prisma init"
alias prisma-pull="npx prisma db pull"

make-mongo-connection() {
    echo "// MongoDB Mongoose Connection Helper"
    echo "const mongoose = require('mongoose');"
    echo "mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true });"
}

make-mongoose-model() {
    local name="${1:-User}"
    echo "const mongoose = require('mongoose');"
    echo "const ${name}Schema = new mongoose.Schema({ name: String, createdAt: { type: Date, default: Date.now } });"
    echo "module.exports = mongoose.model('${name}', ${name}Schema);"
}

make-prisma-model() {
    local name="${1:-User}"
    echo "model $name {"
    echo "  id        Int      @id @default(autoincrement())"
    echo "  createdAt DateTime @default(now())"
    echo "}"
}

make-express-boilerplate() {
    echo "const express = require('express');"
    echo "const app = express();"
    echo "app.use(express.json());"
    echo "app.get('/', (req, res) => res.send('API Running'));"
    echo "app.listen(3000, () => console.log('Server started on port 3000'));"
}

make-jwt-setup() {
    echo "const jwt = require('jsonwebtoken');"
    echo "const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });"
}
