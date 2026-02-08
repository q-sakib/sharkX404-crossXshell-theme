#!/bin/bash
set -e

# ========================
# CONFIGURATION
# ========================
# MySQL
MYSQL_DATA=/opt/homebrew/var/mysql
MYSQL_BIN=/opt/homebrew/opt/mysql@8.0/bin
ROOT_MYSQL_PASS="SharkX404"
SHARK_MYSQL_PASS="SharkX404___1319#"

# PostgreSQL
PG_DATA=/opt/homebrew/var/postgresql@15
PG_BIN=/opt/homebrew/opt/postgresql@15/bin
ROOT_PG_USER="postgres"
ROOT_PG_PASS="SharkX404"
SHARK_PG_USER="shark"
SHARK_PG_PASS="SharkX404___1319#"

# ========================
# HELPER FUNCTIONS
# ========================
wait_for_mysql() {
    local timeout=60
    local counter=0
    until $MYSQL_BIN/mysqladmin ping &>/dev/null; do
        echo "Waiting for MySQL to start..."
        sleep 2
        counter=$((counter + 2))
        if [ $counter -ge $timeout ]; then
            echo "Error: MySQL did not start within $timeout seconds."
            exit 1
        fi
    done
}

wait_for_pg() {
    local timeout=60
    local counter=0
    until $PG_BIN/pg_isready &>/dev/null; do
        echo "Waiting for PostgreSQL to start..."
        sleep 2
        counter=$((counter + 2))
        if [ $counter -ge $timeout ]; then
            echo "Error: PostgreSQL did not start within $timeout seconds."
            exit 1
        fi
    done
}

# ========================
# INSTALL PACKAGES
# ========================
echo "Installing Homebrew packages..."
brew install mysql@8.0 postgresql@15 || true

# ========================
# FRESH MYSQL INSTALL
# ========================
echo "Setting up MySQL 8.0 (fresh install)..."
brew services stop mysql@8.0 || true
sleep 3

# Remove old data directory
if [ -d "$MYSQL_DATA" ]; then
    echo "Removing old MySQL data directory..."
    rm -rf "$MYSQL_DATA"
fi

echo "Initializing MySQL data directory..."
$MYSQL_BIN/mysqld --initialize-insecure --user=$(whoami) --datadir="$MYSQL_DATA"

brew services start mysql@8.0
wait_for_mysql

# Configure users
echo "Configuring MySQL users..."
$MYSQL_BIN/mysql -uroot <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_MYSQL_PASS';
CREATE USER 'shark'@'localhost' IDENTIFIED BY '$SHARK_MYSQL_PASS';
GRANT ALL PRIVILEGES ON *.* TO 'shark'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
echo "MySQL setup complete!"

# ========================
# FRESH POSTGRES INSTALL
# ========================
echo "Setting up PostgreSQL 15 (fresh install)..."
brew services stop postgresql@15 || true
sleep 3

# Remove old data directory
if [ -d "$PG_DATA" ]; then
    echo "Removing old PostgreSQL data directory..."
    rm -rf "$PG_DATA"
fi

echo "Initializing PostgreSQL data directory..."
$PG_BIN/initdb -D "$PG_DATA" -U "$ROOT_PG_USER" --auth=trust

brew services start postgresql@15
wait_for_pg

# Configure users
echo "Configuring PostgreSQL users..."
$PG_BIN/psql -U "$ROOT_PG_USER" -d postgres <<EOF
ALTER USER $ROOT_PG_USER WITH PASSWORD '$ROOT_PG_PASS';
CREATE USER $SHARK_PG_USER WITH PASSWORD '$SHARK_PG_PASS';
GRANT ALL PRIVILEGES ON DATABASE postgres TO $SHARK_PG_USER;
EOF
echo "PostgreSQL setup complete!"

# ========================
# FINAL STATUS
# ========================
echo "=== DB Auto Setup Complete ==="
echo "MySQL 8.0:"
echo "  Host: 127.0.0.1  Port: 3306"
echo "  Users: root/$ROOT_MYSQL_PASS, shark/$SHARK_MYSQL_PASS"
echo "PostgreSQL 15:"
echo "  Host: 127.0.0.1  Port: 5432"
echo "  Users: $ROOT_PG_USER/$ROOT_PG_PASS, $SHARK_PG_USER/$SHARK_PG_PASS"
echo "You can now connect using TablePlus, DBeaver, or psql/mysql CLI."
