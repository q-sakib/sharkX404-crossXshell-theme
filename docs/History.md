# Fuzzy History & History Deletion Guide

## Overview
The history module (`Modules/fzf-history.ps1`) provides persistent, cross-platform command history with fuzzy search and safe history management.

## Features
- **Ctrl+R Fuzzy Search**: Instant, searchable history menu powered by `fzf`.
- **Persistent Storage**: History file path is resolved dynamically via `[Microsoft.PowerShell.PSConsoleReadLine]::GetHistorySavePath()`.
- **Cross-Platform**: Works identically on macOS (`~/.local/share/powershell/...`) and Windows (`%APPDATA%\...`).
- **Interactive History Deletion**: Delete unwanted or sensitive commands safely.

## Usage

### 1. Searching History (Ctrl+R)
Press `Ctrl+R` in your terminal to open the fuzzy finder:
- Type keywords to filter commands.
- Use `Up` / `Down` arrows to navigate.
- Press `Enter` to load and execute the command.
- Press `Esc` to cancel.

### 2. Deleting History (`deletehistory`)
Run:
```powershell
deletehistory
```
1. An interactive `fzf` list opens.
2. Select one or multiple items using `Tab`.
3. Press `Enter` to confirm selection.
4. Type `DELETE` when prompted for confirmation.

### 3. Cleaning Duplicate History (`clean-history`)
Run:
```powershell
clean-history
```
Deduplicates history lines while preserving command order and reducing file clutter.
