# macOS PowerShell Development Setup

## Overview
PowerShell Core (pwsh 7+) on macOS runs as a native cross-platform CLI shell.

## Profile Location
On macOS, PowerShell loads its profile from:
`~/.config/powershell/Microsoft.PowerShell_profile.ps1`

## Quick Setup
Run the automated profile setup script:
```powershell
pwsh ./setup-profile.ps1
```

Or execute the installer script to install Homebrew dependencies:
```powershell
pwsh ./starter-installer.ps1
```

## Recommended Terminal & Fonts
- **Terminal**: iTerm2, macOS Terminal, or Ghostty
- **Nerd Fonts**: Install `font-caskaydia-cove-nerd-font` or `font-meslo-lg-nerd-font` via Homebrew:
  ```bash
  brew tap homebrew/cask-fonts
  brew install --cask font-caskaydia-cove-nerd-font
  ```
