# 🚀 Laravel Eloquent Helper Functions

function elq--make-model {
    param(
        [string]$name,
        [switch]$migration,
        [switch]$controller,
        [switch]$factory,
        [switch]$seeder
    )

    $cmd = "php artisan make:model $name"
    if ($migration) { $cmd += " -m" }
    if ($controller) { $cmd += " -c" }
    if ($factory) { $cmd += " -f" }
    if ($seeder) { $cmd += " -s" }

    Invoke-Expression $cmd
}

function elq--make-eloquent {
    param(
        [string]$name
    )

    if (-not $name) {
        Write-Host "Usage: make-eloquent <ModelName>" -ForegroundColor Yellow
        return
    }

    make-model -name $name -migration -controller -factory -seeder
}

function elq--make-relationship {
    param(
        [ValidateSet("hasOne", "hasMany", "belongsTo", "belongsToMany", "morphOne", "morphMany", "morphTo", "morphToMany")]
        [string]$type,
        [string]$relatedModel
    )

    if (-not $relatedModel) {
        Write-Host "Usage: make-relationship <type> <RelatedModel>" -ForegroundColor Yellow
        return
    }

    $code = switch ($type) {
        "hasOne"         { "return \$this->hasOne($relatedModel::class);" }
        "hasMany"        { "return \$this->hasMany($relatedModel::class);" }
        "belongsTo"      { "return \$this->belongsTo($relatedModel::class);" }
        "belongsToMany"  { "return \$this->belongsToMany($relatedModel::class);" }
        "morphOne"       { "return \$this->morphOne($relatedModel::class, 'morphable');" }
        "morphMany"      { "return \$this->morphMany($relatedModel::class, 'morphable');" }
        "morphTo"        { "return \$this->morphTo();" }
        "morphToMany"    { "return \$this->morphToMany($relatedModel::class, 'taggable');" }
    }

    Write-Host "`n📌 Paste this into your model:" -ForegroundColor Cyan
    Write-Host "`npublic function $($relatedModel.ToLower())() {`n    $code`n}" -ForegroundColor Green
}

function art--run-tinker {
    php artisan tinker
}

function art--find-model {
    param([string]$model, [string]$id)

    if (-not $model -or -not $id) {
        Write-Host "Usage: find-model <ModelName> <ID>" -ForegroundColor Yellow
        return
    }

    $query = "$model::find($id);"
    php artisan tinker --execute "$query"
}
