# =====================================================================
# 🗄  Database — PostgreSQL and MySQL shortcuts
# Start/stop/login/create/dump/restore — macOS Homebrew services
# =====================================================================

# Shared confirmation (db.zsh loads before git.zsh alphabetically)
_confirm_db_action() {
    printf "\n${C_RED}⚠️  %s${C_RESET}\n" "$1"
    printf "   Proceed? [y/N] "
    read -r _db_answer
    [[ "$_db_answer" =~ ^[Yy]$ ]]
}

# ── PostgreSQL service name (supports versioned pg install) ───────────
_pg_service() {
    # Prefer versioned service if present, fall back to plain 'postgresql'
    local svc
    svc=$(brew services list 2>/dev/null | awk '/postgresql/ {print $1; exit}')
    echo "${svc:-postgresql@16}"
}

# ── PostgreSQL ────────────────────────────────────────────────────────
pgstart()   { brew services start  "$(_pg_service)"; }
pgstop()    { brew services stop   "$(_pg_service)"; }
pgrestart() { brew services restart "$(_pg_service)"; }
pgstatus()  { brew services info   "$(_pg_service)"; }

pglogin() {
    local db=${1:-postgres}
    local user=${2:-$(whoami)}
    printf "${C_CYAN}Connecting: psql -U %s -d %s${C_RESET}\n" "$user" "$db"
    psql -U "$user" -d "$db"
}

pglist() {
    psql -U "$(whoami)" -c "\l+" 2>/dev/null || psql -c "\l"
}

pgcreate() {
    local db=${1:-}
    if [[ -z "$db" ]]; then printf "${C_YELLOW}Usage: pgcreate <dbname> [owner]${C_RESET}\n"; return 1; fi
    local owner=${2:-$(whoami)}
    createdb -O "$owner" "$db" && printf "${C_GREEN}✅ Created database: %s (owner: %s)${C_RESET}\n" "$db" "$owner"
}

pgdrop() {
    local db=${1:-}
    if [[ -z "$db" ]]; then printf "${C_YELLOW}Usage: pgdrop <dbname>${C_RESET}\n"; return 1; fi
    _confirm_db_action "Drop PostgreSQL database '$db'? All data will be permanently lost." || {
        printf "${C_GRAY}  Cancelled.${C_RESET}\n"; return
    }
    dropdb "$db" && printf "${C_GREEN}✅ Dropped database: %s${C_RESET}\n" "$db"
}

pgdump() {
    local db=${1:-}
    if [[ -z "$db" ]]; then printf "${C_YELLOW}Usage: pgdump <dbname> [output.sql]${C_RESET}\n"; return 1; fi
    local file="${2:-${db}_$(date +%Y%m%d_%H%M%S).sql}"
    pg_dump "$db" > "$file" && printf "${C_GREEN}✅ Dumped: %s → %s${C_RESET}\n" "$db" "$file"
}

pgrestore() {
    local file=${1:-} db=${2:-}
    if [[ -z "$file" || -z "$db" ]]; then
        printf "${C_YELLOW}Usage: pgrestore <file.sql> <dbname>${C_RESET}\n"; return 1
    fi
    [[ ! -f "$file" ]] && { printf "${C_RED}File not found: %s${C_RESET}\n" "$file"; return 1; }
    psql -d "$db" < "$file" && printf "${C_GREEN}✅ Restored: %s → %s${C_RESET}\n" "$file" "$db"
}

# Quick connect shorthand
alias pg='pglogin'

# ── MySQL ─────────────────────────────────────────────────────────────
mystart()   { brew services start   mysql; }
mystop()    { brew services stop    mysql; }
myrestart() { brew services restart mysql; }
mystatus()  { brew services info    mysql; }

mylogin() {
    local user=${1:-root}
    local db=${2:-}
    printf "${C_CYAN}Connecting: mysql -u %s${C_RESET}\n" "$user"
    if [[ -n "$db" ]]; then
        mysql -u "$user" -p "$db"
    else
        mysql -u "$user" -p
    fi
}

mylist() {
    mysql -u root -p -e "SHOW DATABASES;" 2>/dev/null
}

mycreate() {
    local db=${1:-}
    if [[ -z "$db" ]]; then printf "${C_YELLOW}Usage: mycreate <dbname> [charset]${C_RESET}\n"; return 1; fi
    local charset=${2:-utf8mb4}
    mysql -u root -p -e "CREATE DATABASE \`$db\` CHARACTER SET $charset COLLATE ${charset}_unicode_ci;" 2>/dev/null && \
        printf "${C_GREEN}✅ Created MySQL database: %s (charset: %s)${C_RESET}\n" "$db" "$charset"
}

mydrop() {
    local db=${1:-}
    if [[ -z "$db" ]]; then printf "${C_YELLOW}Usage: mydrop <dbname>${C_RESET}\n"; return 1; fi
    _confirm_db_action "Drop MySQL database '$db'? All data will be permanently lost." || {
        printf "${C_GRAY}  Cancelled.${C_RESET}\n"; return
    }
    mysql -u root -p -e "DROP DATABASE \`$db\`;" 2>/dev/null && \
        printf "${C_GREEN}✅ Dropped MySQL database: %s${C_RESET}\n" "$db"
}

mydump() {
    local db=${1:-}
    if [[ -z "$db" ]]; then printf "${C_YELLOW}Usage: mydump <dbname> [output.sql]${C_RESET}\n"; return 1; fi
    local file="${2:-${db}_$(date +%Y%m%d_%H%M%S).sql}"
    mysqldump -u root -p "$db" > "$file" && printf "${C_GREEN}✅ Dumped: %s → %s${C_RESET}\n" "$db" "$file"
}

myrestore() {
    local file=${1:-} db=${2:-}
    if [[ -z "$file" || -z "$db" ]]; then
        printf "${C_YELLOW}Usage: myrestore <file.sql> <dbname>${C_RESET}\n"; return 1
    fi
    [[ ! -f "$file" ]] && { printf "${C_RED}File not found: %s${C_RESET}\n" "$file"; return 1; }
    mysql -u root -p "$db" < "$file" && printf "${C_GREEN}✅ Restored: %s → %s${C_RESET}\n" "$file" "$db"
}

# Quick connect shorthand
alias my='mylogin'

# ── DB help viewer ────────────────────────────────────────────────────
dbhelp() {
    printf "\n${C_CYAN}🗄  Database Shortcuts:${C_RESET}\n"
    printf "  ${C_GRAY}──────────────────────────────────────────────────────────${C_RESET}\n"

    local -a rows=(
        "pgstart|brew services start postgresql|Start PostgreSQL"
        "pgstop|brew services stop postgresql|Stop PostgreSQL"
        "pgrestart|brew services restart postgresql|Restart PostgreSQL"
        "pgstatus|brew services info postgresql|PostgreSQL service status"
        "pglogin [db] [user]|psql -U user -d db|Connect to PostgreSQL"
        "pglist|psql \\l+|List all PostgreSQL databases"
        "pgcreate <db> [owner]|createdb|Create PostgreSQL database"
        "pgdrop <db>  [y/N]|dropdb|Drop PostgreSQL database"
        "pgdump <db> [file]|pg_dump|Dump PostgreSQL database to SQL"
        "pgrestore <file> <db>|psql -d db < file|Restore from SQL dump"
        "---|||"
        "mystart|brew services start mysql|Start MySQL"
        "mystop|brew services stop mysql|Stop MySQL"
        "myrestart|brew services restart mysql|Restart MySQL"
        "mystatus|brew services info mysql|MySQL service status"
        "mylogin [user] [db]|mysql -u user -p|Connect to MySQL"
        "mylist|SHOW DATABASES|List all MySQL databases"
        "mycreate <db> [charset]|CREATE DATABASE|Create MySQL database"
        "mydrop <db>  [y/N]|DROP DATABASE|Drop MySQL database"
        "mydump <db> [file]|mysqldump|Dump MySQL database to SQL"
        "myrestore <file> <db>|mysql db < file|Restore from SQL dump"
    )

    for row in "${rows[@]}"; do
        [[ "$row" == "---|||" ]] && { printf "  ${C_GRAY}──────────────────────────────────────────────────────────${C_RESET}\n"; continue; }
        local alias_name="${row%%|*}"
        local rest="${row#*|}"
        local cmd="${rest%%|*}"
        local desc="${rest#*|}"
        printf "  ${C_GREEN}→ ${C_YELLOW}%-28s${C_WHITE}%-24s${C_GRAY}# %s${C_RESET}\n" "$alias_name" "$cmd" "$desc"
    done

    printf "  ${C_GRAY}──────────────────────────────────────────────────────────${C_RESET}\n"
    printf "  ${C_YELLOW}⚠️  [y/N] = prompts before dropping a database.${C_RESET}\n"
    printf "  ${C_GRAY}💡 Aliases: pg = pglogin  |  my = mylogin${C_RESET}\n\n"
}
