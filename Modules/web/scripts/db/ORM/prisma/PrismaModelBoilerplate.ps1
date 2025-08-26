function make-prisma-model {
    param([string]$name)
    $model = @"
model $name {
  id        Int      @id @default(autoincrement())
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  // Add your fields here
}
"@
    Add-Content prisma\schema.prisma $model
    Write-Host "✅ Added Prisma model '$name' to schema.prisma"
}
