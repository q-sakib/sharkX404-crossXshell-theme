# 🔐 Laravel API Auth Helpers (Sanctum + JWT)

function art--install-sanctum-auth {
    php artisan require laravel/sanctum
    php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
    php artisan migrate

    Write-Host "`n✅ Sanctum installed. Add 'HasApiTokens' to your User model." -ForegroundColor Cyan
}

function art--install-jwt-auth {
    composer require tymon/jwt-auth
    php artisan vendor:publish --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider"
    php artisan jwt:secret

    Write-Host "`n✅ JWT Auth installed. Add 'JWTSubject' implementation to your User model." -ForegroundColor Cyan
}

function art--auth-route-snippet {
    param([ValidateSet("sanctum", "jwt")][string]$type)

Write-Host "`n📌 Suggested routes for ${type}:" -ForegroundColor Cyan

    if ($type -eq "sanctum") {
        @"
Route::middleware('auth:sanctum')->get('/user', function (Request \$request) {
    return \$request->user();
});
"@ | Write-Host -ForegroundColor Green
    } elseif ($type -eq "jwt") {
        @"
Route::post('login', 'AuthController@login');
Route::middleware('auth:api')->group(function () {
    Route::get('me', 'AuthController@me');
    Route::post('logout', 'AuthController@logout');
});
"@ | Write-Host -ForegroundColor Green
    }
}
