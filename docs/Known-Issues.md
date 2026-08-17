# Known Issues & Workarounds

## 1. Icon Glyphs Displaying as Box/Question Mark (``)
- **Cause**: Terminal font does not support Nerd Font glyphs, or `Terminal-Icons` failed to render.
- **Solution**: The environment now includes `Modules/icons.ps1`, which automatically detects font/terminal capabilities and falls back to clean Unicode/ASCII icons if Nerd Fonts are unavailable.

## 2. Hardcoded Path Resolution on Symlinked Profiles
- **Cause**: On macOS, `$PSScriptRoot` evaluates to `~/.config/powershell` when the profile is copied or symlinked without target resolution.
- **Solution**: `Microsoft.PowerShell_profile.ps1` resolves the symlink target via `(Get-Item $PSCommandPath).Target` to dynamically locate the repository root.

## 3. Winget Failure on macOS / Homebrew Failure on Windows
- **Cause**: Platform package managers vary across OS.
- **Solution**: `starter-installer.ps1` detects `$IsMacOS` vs `$IsWindows` and uses `brew` or `winget` accordingly.
