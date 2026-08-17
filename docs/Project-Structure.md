# Project Structure

```
sharkX404-crossXshell-theme/
├── Microsoft.PowerShell_profile.ps1 # Primary profile entry point
├── starter-installer.ps1            # Cross-platform environment bootstrapper (Brew/Winget)
├── setup-profile.ps1                # Automated profile symlinker & module installer
├── git-setup-mac.sh                 # macOS Git credential & user setup
├── powershell.config.json           # Execution policy configuration
├── readme.md                        # Primary developer README
├── starter-context.md               # Context & project goals
│
├── Modules/                         # Modular PowerShell scripts
│   ├── core.ps1                     # Keybindings, PSReadLine, navigation & core helpers
│   ├── git.ps1                      # Complete Git alias library & helper functions
│   ├── fzf-history.ps1              # Fuzzy history search (Ctrl+R) & safe delete
│   ├── icons.ps1                    # Resilience layer for icons & fallback rendering
│   ├── tools.ps1                    # System utilities, IP info, .env loader
│   ├── ai-tools.ps1                 # GitHub Copilot & HuggingFace CLI integrations
│   ├── api-testing.ps1              # HTTPie & REST API helper functions
│   ├── docker.ps1                   # Docker & Docker Compose aliases
│   ├── error-handling.ps1           # Global error handling helpers
│   │
│   ├── web/                         # Web Development Modules
│   │   ├── webdev.ps1               # Node, React, Next, Angular, Laravel, Vercel CLI
│   │   ├── dev-checklist/           # Interactive developer checklists
│   │   └── scripts/                 # Framework & DB generators (Laravel, Mongoose, Prisma)
│   │
│   └── simulation/                  # Terminal animations & sessions
│       ├── shark/                   # Shark animations
│       └── chaos/                   # Chaos text generators
│
├── git-setup/                       # Git initialization scripts
│   ├── setup.ps1                    # Windows Git setup
│   ├── setup.sh                     # macOS/Linux Git setup
│   └── environment.ts               # Shared config
│
├── docs/                            # Developer Documentation
│   ├── Architecture.md              # System design & component flow
│   ├── Project-Structure.md         # Directory map & description
│   ├── Windows.md                   # Windows installation & PowerShell 7 setup
│   ├── MacOS.md                     # macOS setup, Homebrew & font config
│   ├── PowerShell.md                # PowerShell configuration guide
│   ├── Known-Issues.md              # Known bugs & workarounds
│   ├── Git-Aliases.md               # Git commands & shortcuts reference
│   ├── History.md                   # Fuzzy history & deletion manual
│   └── Roadmap.md                   # Future enhancements & Linux plans
└── python/                          # Python graphics & Lorenz attractor generators
```
