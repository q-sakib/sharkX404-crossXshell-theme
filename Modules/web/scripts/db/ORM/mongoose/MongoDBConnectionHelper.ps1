function make-mongo-connection {
    @"
const mongoose = require('mongoose');

const connectDB = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
        });
        console.log('MongoDB Connected');
    } catch (err) {
        console.error(err.message);
        process.exit(1);
    }
};

module.exports = connectDB;
"@ | Out-File "config\mongo.js" -Encoding utf8

    Write-Host "✅ MongoDB connection helper created: config/mongo.js"
}
