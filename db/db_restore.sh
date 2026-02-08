#!/bin/zsh
set -e

# ========================
# CONFIG
# ========================
MYSQL_USER="root"
MYSQL_PASS="SharkX404"
MYSQL_BIN="/opt/homebrew/opt/mysql@8.0/bin"

PG_USER="postgres"
PG_PASS="SharkX404"
PG_BIN="/opt/homebrew/opt/postgresql@15/bin"

# ========================
# ARGUMENTS
# ========================
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "Usage: $0 path/to/dump.sql [mysql|postgres]"
    exit 1
fi

DUMP_FILE=$1
DB_TYPE=$2

if [ ! -f "$DUMP_FILE" ]; then
    echo "Error: Dump file $DUMP_FILE not found!"
    exit 1
fi

# Auto-detect DB type if not provided
if [ -z "$DB_TYPE" ]; then
    case "$DUMP_FILE" in
        *.psql|*.pgsql)
            DB_TYPE="postgres"
            ;;
        *.sql)
            DB_TYPE="mysql"
            ;;
        *)
            echo "Error: Could not detect DB type. Please provide [mysql|postgres] explicitly."
            exit 1
            ;;
    esac
fi

echo "Restoring $DUMP_FILE to $DB_TYPE..."

# ========================
# MYSQL RESTORE
# ========================
if [ "$DB_TYPE" = "mysql" ]; then
    export MYSQL_PWD=$MYSQL_PASS
    # Use big packet and disable timeout
    $MYSQL_BIN/mysql -u $MYSQL_USER --max_allowed_packet=1G --connect_timeout=3600 < "$DUMP_FILE"
    unset MYSQL_PWD

# ========================
# POSTGRES RESTORE
# ========================
elif [ "$DB_TYPE" = "postgres" ]; then
    export PGPASSWORD=$PG_PASS
    # Increase statement timeout for large files (1 hour)
    $PG_BIN/psql -U $PG_USER -v ON_ERROR_STOP=1 -d postgres -c "SET statement_timeout = 3600000;"
    $PG_BIN/psql -U $PG_USER -v ON_ERROR_STOP=1 -d postgres -f "$DUMP_FILE"
    unset PGPASSWORD

else
    echo "Error: Unknown DB type $DB_TYPE"
    exit 1
fi

echo "Restore complete!"
