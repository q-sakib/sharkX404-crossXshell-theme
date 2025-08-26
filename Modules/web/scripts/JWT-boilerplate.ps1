function make-jwt-setup {
    New-Item -ItemType Directory -Path "auth" -Force | Out-Null

    # JWT utility
    @"
const jwt = require('jsonwebtoken');
const secret = process.env.JWT_SECRET || 'changeme';

exports.generateToken = (user) => {
    return jwt.sign({ id: user.id }, secret, { expiresIn: '1d' });
};

exports.verifyToken = (token) => {
    return jwt.verify(token, secret);
};
"@ | Out-File "auth\jwt.js" -Encoding utf8

    # Auth middleware
    @"
const jwt = require('jsonwebtoken');
const secret = process.env.JWT_SECRET || 'changeme';

module.exports = (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'No token' });

    try {
        const decoded = jwt.verify(token, secret);
        req.user = decoded;
        next();
    } catch {
        res.status(401).json({ error: 'Invalid token' });
    }
};
"@ | Out-File "middleware\auth.js" -Encoding utf8

    Write-Host "✅ JWT setup: 'auth/jwt.js' and 'middleware/auth.js' created"
}
