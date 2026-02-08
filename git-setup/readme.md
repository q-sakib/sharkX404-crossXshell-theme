# Git + Bitbucket Cross-Platform Cheat Sheet

Nice — a **single, no-nonsense cheat-sheet README** is exactly the right move 👍
Below is a **fully self-contained `README.md`** you can drop anywhere and follow on **Linux / macOS / Windows**.

It’s written to be:

* copy-paste friendly
* secure (no secrets in files)
* fast to scan when you forget things later

---

````markdown
# 🧾 Git + Bitbucket Cross-Platform Cheat Sheet  
### (Linux · macOS · Windows)

One-time setup to:
- Clone private Bitbucket repos
- Push & pull without re-entering passwords
- Securely store API tokens
- Enable SSH fallback
- Work the same on every OS

---

## 🧠 How Authentication Works (Read Once)

- Bitbucket uses **App Passwords** (API tokens)
- Tokens are stored securely by your OS:
  - **macOS** → Keychain
  - **Windows** → Credential Manager
  - **Linux** → libsecret / keyring
- You authenticate **once**, Git remembers forever

❌ Never hard-code tokens  
❌ Never commit tokens  

---

## ✅ Prerequisites

### All platforms
- Git ≥ 2.30
- Bitbucket account
- Bitbucket **App Password** with:
  - Repositories → **Read**
  - Repositories → **Write**

### Optional (recommended)
- VS Code (`code` in PATH)
- Git LFS
- SSH client (OpenSSH)

---

## 🔑 Create Bitbucket App Password (API Token)

1. Bitbucket → **Personal settings**
2. **App passwords** → Create
3. Permissions:
   - Repositories → Read
   - Repositories → Write
4. Copy token (shown once)

---

## 👤 Git Identity (All OS)

```bash
git config --global user.name "Sakib SiddiQuie"
git config --global user.email "i.sak1uib@gmail.com"
````

---

## 🧩 Core Git Settings (Cross-Platform)

```bash
git config --global pull.rebase false
git config --global init.defaultBranch master
git config --global core.editor "code --wait"
```

---

## 🪟 Windows Setup

### Credential storage

```powershell
git config --global credential.helper manager
git config --global core.autocrlf true
```

### Optional username preset

```powershell
git config --global credential.username <bitbucket_username>
```

Credentials stored in:

```
Control Panel → Credential Manager
```

---

## 🍎 macOS Setup

### Credential storage

```bash
git config --global credential.helper osxkeychain
git config --global core.autocrlf input
```

### Optional username preset

```bash
git config --global credential.username <bitbucket_username>
```

Credentials stored in:

```
Keychain Access
```

---

## 🐧 Linux Setup

### Install credential helper

```bash
sudo apt install libsecret-1-0 libsecret-1-dev
git config --global credential.helper /usr/lib/git-core/git-credential-libsecret
git config --global core.autocrlf input
```

Credentials stored in:

```
Secret Service / Keyring
```

---

## 🔐 Save Token Once (No More Prompts)

Clone or pull **once**:

```bash
git clone https://bitbucket.org/<workspace>/<repo>.git
```

or

```bash
git pull
```

When prompted:

```
Username → Bitbucket username
Password → App Password (token)
```

✔ Stored securely
✔ No future prompts
✔ Push & pull works

---

## 🔁 Verify

```bash
git pull
git push
```

If no prompt appears → done 🎉

---

## 🔑 SSH Fallback (Recommended)

### Generate SSH key (all OS)

```bash
ssh-keygen -t ed25519 -C "bitbucket"
```

Press Enter for defaults.

### Add key to agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### Add public key to Bitbucket

```bash
cat ~/.ssh/id_ed25519.pub
```

Bitbucket → **Personal settings → SSH keys**

### Test

```bash
ssh -T git@bitbucket.org
```

---

## 🔀 Prefer HTTPS but Allow SSH

```bash
git config --global url."https://bitbucket.org/".insteadOf git@bitbucket.org:
```

---

## 🔄 Token Rotation (Safe Way)

Bitbucket does NOT allow silent rotation.

### Steps

1. Create new App Password
2. Delete old one
3. Remove stored credential
4. Next `git pull` saves new token

### macOS

```
Keychain Access → bitbucket.org → delete
```

### Windows

```
Credential Manager → bitbucket.org → delete
```

### Linux

```
Keyring → bitbucket.org → delete
```

---

## 🧪 Troubleshooting

### Git keeps asking for password

* Old credential cached
* Token missing **Write** permission
* Wrong username (email ≠ username)

### Push denied

* App Password lacks repo write access

### `ls` not working on Windows

Use:

```cmd
dir
```

or use **Git Bash**

---

## 🛡️ Security Rules (Memorize These)

✅ Use App Passwords
✅ Use SSH for long-term dev
✅ Let OS store secrets

❌ Never store tokens in scripts
❌ Never commit `.env` files
❌ Never share tokens

---

## 🏁 End Result

* ✔ One-time auth
* ✔ Secure token storage
* ✔ Push & pull private repos
* ✔ Works on Linux / macOS / Windows
* ✔ SSH fallback
* ✔ CI/CD friendly

---

📌 Save this file. Future you will thank you.

```

---

If you want next:
- convert this into a **printable PDF**
- add **company proxy / SSL configs**
- include **CI/CD examples**
- shorten it into a **1-page ultra-cheat-sheet**

Just say 👍
```
