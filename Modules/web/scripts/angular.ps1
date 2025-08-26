# 🚀 Angular new project
function ngnew {
    param([string]$name)
    ng new $name
}

# 🧪 Angular generate component
function ngc {
    param([string]$name)
    ng generate component $name
}

# 🧠 Angular generate service
function ngs {
    param([string]$name)
    ng generate service $name
}

# 📦 Angular generate module
function ngm {
    param([string]$name)
    ng generate module $name
}

# 👨‍🏫 Angular generate class (e.g., model)
function ngmodel {
    param([string]$name)
    ng generate class $name
}

# 🎮 Angular generate directive
function ngd {
    param([string]$name)
    ng generate directive $name
}

# 🎛 Angular generate pipe
function ngp {
    param([string]$name)
    ng generate pipe $name
}

# 🧰 Angular generate guard
function ngg {
    param([string]$name)
    ng generate guard $name
}

# 🛠 Angular generate interface
function ngi {
    param([string]$name)
    ng generate interface $name
}

# 🚀 Angular serve
function ngserve {
    ng serve
}

# 🏗 Angular build
function ngbuild {
    ng build
}
# 📦 Angular deploy
function ngdeploy {
    ng deploy
}   