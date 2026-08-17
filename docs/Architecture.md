# Architecture Overview

## Overview
This repository provides a modular, cross-platform developer environment for PowerShell 7+ on macOS and Windows, alongside native shell configurations.

## Core Architectural Principles
1. **Zero-Hardcoding Path Resolution**: Dynamic path resolution (`$PSScriptRoot`, `$PSCommandPath` symlink target detection, and cross-platform slashes).
2. **Defensive Loading**: Non-blocking module execution; if a module fails or a command is missing, the environment continues initializing gracefully.
3. **Cross-Platform Compatibility**: Single codebase supporting macOS, Windows 11+, and Linux without platform lock-in.
4. **Adaptive UI & Icon Resilience**: Dynamic icon provider checking for Nerd Fonts, Eza, and Unicode fallback to prevent broken terminal glyphs (``).
5. **Modular Functionality**: Decoupled modules for Core, Git, History, Web Dev, API Testing, Docker, and AI Tools.

## High-Level Module Flow

```
[ PowerShell Startup / Profile Loading ]
                   │
                   ▼
     [ Symlink / Path Target Resolution ]
                   │
                   ▼
     [ Platform Capabilities Detection ] (OS, Nerd Fonts, Eza, Oh My Posh)
                   │
                   ▼
      ┌────────────┴────────────┐
      ▼                         ▼
[ Core Modules ]        [ Feature Modules ]
 - Core                 - Git Aliases & Helpers
 - History (Ctrl+R/Fzf) - Web & Frameworks
 - Icons & Fallbacks    - Docker & Tools
                        - AI & API Testers
```

## Platform Abstraction Layer
- **macOS**: Configured at `~/.config/powershell/Microsoft.PowerShell_profile.ps1`, Homebrew (`brew`) package manager integration.
- **Windows**: Configured at `$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`, Winget package manager integration.
