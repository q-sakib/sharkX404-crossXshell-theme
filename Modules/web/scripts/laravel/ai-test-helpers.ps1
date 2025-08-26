# 🧠 AI-Inspired Test Stub Generator

function art--ai-generate-test-stub {
    param(
        [string]$name
    )

    if (-not $name) {
        Write-Host "Usage: generate-test-stub <ResourceName>" -ForegroundColor Yellow
        return
    }

    $testName = "${name}Test"
    $file = "tests/Feature/$testName.php"

    php artisan make:test $testName

    @"
public function test_${name.ToLower()}_creation()
{
    \$response = \$this->post('/api/$($name.ToLower())', [
        // TODO: add required fields
    ]);

    \$response->assertStatus(201);
}
"@ | Add-Content -Path $file

    Write-Host "✅ Stub added to tests/Feature/$testName.php" -ForegroundColor Green
}
