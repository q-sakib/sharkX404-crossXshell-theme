function make-mongoose-model {
    param([string]$name)
    $path = "models\$name.model.js"
    $className = $name.Substring(0,1).ToUpper() + $name.Substring(1)

    @"
const mongoose = require('mongoose');

const ${className}Schema = new mongoose.Schema({
    // Add your fields here
}, { timestamps: true });

module.exports = mongoose.model('$className', ${className}Schema);
"@ | Out-File $path -Encoding utf8

    Write-Host "✅ Mongoose model created: $path"
}
