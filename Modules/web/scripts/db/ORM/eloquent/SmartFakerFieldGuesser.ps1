function art--guess-faker {
    param([string[]]$fields)

    if (-not $fields) {
        Write-Host "Usage: guess-faker <field1> <field2> ..." -ForegroundColor Yellow
        return
    }

    foreach ($field in $fields) {
        $value = switch -Wildcard ($field.ToLower()) {
            '*name*'     { "`'name' => \$faker->name," }
            '*email*'    { "`'email' => \$faker->unique()->safeEmail," }
            '*phone*'    { "`'phone' => \$faker->phoneNumber," }
            '*password*' { "`'password' => bcrypt('password')," }
            '*title*'    { "`'title' => \$faker->sentence," }
            '*desc*'     { "`'description' => \$faker->paragraph," }
            '*body*'     { "`'body' => \$faker->text(200)," }
            '*price*'    { "`'price' => \$faker->randomFloat(2, 10, 500)," }
            '*created*'  { "`'created_at' => now()," }
            '*updated*'  { "`'updated_at' => now()," }
            default      { "`'$field' => \$faker->word," }
        }

        Write-Host $value -ForegroundColor Green
    }
}
function art--seed {
    param([string]$seeder)

    if ($seeder) {
        php artisan db:seed --class=$seeder
    } else {
        php artisan db:seed
    }
}

function art--refresh-db {
    php artisan migrate:fresh --seed
}
