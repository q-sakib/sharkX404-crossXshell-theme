function make-express-boilerplate {
    param(
        [string]$orm = "mongoose"  # or "prisma"
    )

    # 1. Create project structure
    mkdir auth, config, middleware, models, routes -Force | Out-Null

    # 2. index.js
    @"
require('dotenv').config();
const express = require('express');
const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(express.json());

// DB Connect
require('./config/${orm}.js')();

// Routes
app.use('/api/auth', require('./routes/auth.routes'));

app.listen(PORT, () => console.log(\`Server running on port \${PORT}\`));
"@ | Out-File "index.js" -Encoding utf8

    # 3. .env
    @"
PORT=5000
JWT_SECRET=supersecret
MONGO_URI=mongodb://localhost:27017/yourdb
DATABASE_URL="file:./dev.db"
"@ | Out-File ".env" -Encoding utf8

    # 4. JWT utilities
    @"
const jwt = require('jsonwebtoken');
const secret = process.env.JWT_SECRET;

exports.generateToken = (payload) => {
    return jwt.sign(payload, secret, { expiresIn: '1d' });
};

exports.verifyToken = (token) => {
    return jwt.verify(token, secret);
};
"@ | Out-File "auth\jwt.js" -Encoding utf8

    # 5. Auth middleware
    @"
const jwt = require('jsonwebtoken');
const secret = process.env.JWT_SECRET;

module.exports = (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'No token' });

    try {
        req.user = jwt.verify(token, secret);
        next();
    } catch {
        res.status(401).json({ error: 'Invalid token' });
    }
};
"@ | Out-File "middleware\auth.js" -Encoding utf8

    # 6. Auth route
    @"
const express = require('express');
const router = express.Router();
const { generateToken } = require('../auth/jwt');

// Sample login route
router.post('/login', (req, res) => {
    const { username } = req.body;
    if (!username) return res.status(400).json({ error: 'Username required' });

    const token = generateToken({ username });
    res.json({ token });
});

module.exports = router;
"@ | Out-File "routes\auth.routes.js" -Encoding utf8

    # 7. Mongo or Prisma config
    if ($orm -eq "mongoose") {
        mkdir prisma -Force | Out-Null
        @"
const mongoose = require('mongoose');

module.exports = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
        });
        console.log('✅ MongoDB connected');
    } catch (err) {
        console.error('❌ MongoDB connection failed', err.message);
        process.exit(1);
    }
};
"@ | Out-File "config\mongoose.js" -Encoding utf8
    } elseif ($orm -eq "prisma") {
        mkdir prisma -Force | Out-Null
        @"
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

module.exports = () => {
    prisma.\$connect()
        .then(() => console.log('✅ Prisma DB connected'))
        .catch((err) => {
            console.error('❌ Prisma connection error', err.message);
            process.exit(1);
        });
};

global.prisma = prisma;
"@ | Out-File "config\prisma.js" -Encoding utf8

        # Add initial Prisma schema
        @"
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlite"
  url      = env("DATABASE_URL")
}

model User {
  id    Int     @id @default(autoincrement())
  name  String
  email String  @unique
}
"@ | Out-File "prisma\schema.prisma" -Encoding utf8
    }

    Write-Host "✅ Express boilerplate created with $orm integration"
}
