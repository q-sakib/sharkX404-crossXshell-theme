# Save this in your PowerShell profile ($PROFILE)
# Example: notepad $PROFILE
# Then paste this function and save

function DevChecklist-Database {
    param (
        [switch]$Full   # Show full details if needed
    )

    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "                 DATABASE CHEAT SHEET" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan

    # ----------------- MySQL -----------------
    Write-Host "`n[MySQL Commands]" -ForegroundColor Yellow
    Write-Host @"
# Connect to MySQL
mysql -u username -p

# Show databases
SHOW DATABASES;

# Select a database
USE mydatabase;

# Show tables
SHOW TABLES;

# Show table structure
DESCRIBE mytable;
SHOW COLUMNS FROM mytable;

# View first 10 rows
SELECT * FROM mytable LIMIT 10;

# Show indexes
SHOW INDEX FROM mytable;

# Exit MySQL
exit;
"@

    # ----------------- PostgreSQL -----------------
    Write-Host "`n[PostgreSQL Commands]" -ForegroundColor Yellow
    Write-Host @"
# Connect to PostgreSQL
psql -U username -d mydatabase

# List databases
\l

# Connect to database
\c mydatabase

# List tables
\dt

# Show table structure
\d mytable

# Query first 10 rows
SELECT * FROM mytable LIMIT 10;

# List indexes
\di

# Exit PostgreSQL
\q
"@

    # ----------------- SQLite -----------------
    Write-Host "`n[SQLite Commands]" -ForegroundColor Yellow
    Write-Host @"
# Connect to SQLite
sqlite3 mydatabase.db

# List tables
.tables

# Show table schema
.schema mytable

# Query first 10 rows
SELECT * FROM mytable LIMIT 10;

# Exit SQLite
.quit
"@

    # ----------------- Optional Full Details -----------------
    if ($Full) {
        Write-Host "`n[Advanced / Power Queries]" -ForegroundColor Yellow
        Write-Host @"
# MySQL
SHOW TABLE STATUS;
EXPLAIN SELECT * FROM mytable;

# PostgreSQL
\d+ mytable
EXPLAIN ANALYZE SELECT * FROM mytable;

# SQLite
PRAGMA table_info(mytable);
PRAGMA index_list(mytable);
"@
    }

    Write-Host "`n=============================================" -ForegroundColor Cyan
    Write-Host "                 END OF DATABASE CHEAT SHEET" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan
}
