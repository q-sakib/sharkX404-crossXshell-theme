function prisma-init {
    npm install prisma --save-dev
    npx prisma init
}

function prisma-generate {
    npx prisma generate
}

function prisma-migrate {
    param([string]$name = "init")
    npx prisma migrate dev --name $name
}

function prisma-studio {
    npx prisma studio
}
function prisma-pull {
    npx prisma db pull
}