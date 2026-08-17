# Cross-Platform Developer Environment Refactor & Expansion

You are joining an existing repository that contains a PowerShell (pwsh) developer environment with aliases, helper functions, startup scripts, icons, and developer tooling.

Your task is **NOT** to rewrite everything from scratch. Instead, perform a complete engineering review, identify issues, improve the architecture, and gradually evolve the project into a modular, scalable, cross-platform developer toolkit.

---

# Overall Goals

The project should become:

* Modular
* Cross-platform
* Maintainable
* Safe
* Backward compatible
* Well documented
* Developer friendly
* Easy to extend
* Production quality

The existing aliases should continue working unless there is a severe bug.

---

# Phase 1 — Repository Audit

Before changing anything:

Perform a complete repository analysis.

Understand:

* folder structure
* aliases
* helper functions
* startup scripts
* profile loading
* workflows
* modules
* configuration files
* icons
* dependencies
* READMEs
* architecture
* developer experience

Then produce documentation explaining everything you discovered.

Create additional documentation where missing.

Examples:

```
docs/

Architecture.md

Project-Structure.md

Windows.md

MacOS.md

PowerShell.md

Contributing.md

Developer-Guide.md

Roadmap.md

Known-Issues.md

Future-Ideas.md

Alias-Reference.md

Git-Aliases.md

History.md
```

Improve every README.

Improve comments.

Document why things exist.

---

# Phase 2 — Windows Master Branch

Create a dedicated branch:

```
dev-os/windows-master
```

Important:

The current environment is **not Windows**, therefore Windows behavior cannot be tested directly.

Because of that:

* make Windows logic defensive
* avoid assumptions
* use safe fallbacks
* avoid breaking startup
* gracefully handle missing commands
* detect Windows capabilities
* avoid hardcoded paths
* improve compatibility

Focus on making Windows the primary PowerShell implementation.

---

# Phase 3 — macOS PowerShell

Create:

```
dev-os/mac-master
```

Do **NOT** simply copy Windows files.

macOS PowerShell is significantly different.

Review and adjust:

* paths
* binaries
* shell behavior
* profile loading
* fonts
* terminal detection
* Homebrew
* permissions
* file locations
* startup

Anything Windows-specific should become abstracted.

Extract shared code into reusable modules whenever possible.

Platform-specific behavior should live in isolated modules.

---

# Phase 4 — Native macOS Shell

Create another branch:

```
dev-native-os/mac-main
```

The purpose is to recreate the developer experience using native shell tooling instead of PowerShell.

Use:

* zsh
* bash (when appropriate)

Replicate the philosophy of the PowerShell setup while respecting native shell conventions.

Do not attempt a one-to-one translation.

Instead, design the best native implementation.

---

# Phase 5 — Linux (Future)

Do **NOT** implement Linux now.

Prepare the architecture so Linux Bash can be added later without major refactoring.

Everything should be designed with future portability in mind.

---

# Existing Aliases

Do NOT remove existing aliases.

Do NOT rename aliases unnecessarily.

Do NOT introduce breaking changes.

Instead:

* fix bugs
* improve implementations
* add missing safeguards
* improve performance
* improve readability
* improve consistency

Backward compatibility is important.

---

# Add New Aliases

Expand the developer toolkit.

Especially around Git.

Look for useful aliases developers commonly use.

Examples include:

* status
* branch management
* fetch
* pull
* push
* stash
* worktree
* rebase
* squash
* cleanup
* undo helpers
* restore helpers
* conflict helpers
* branch pruning
* log shortcuts
* diff helpers
* blame helpers
* cherry-pick helpers
* bisect helpers
* tag helpers
* release helpers

Avoid alias spam.

Only include aliases that genuinely improve productivity.

---

# Developer Quality-of-Life Improvements

Add useful features such as:

* fuzzy history search
* command history improvements
* duplicate history cleanup
* history deletion
* persistent history
* startup diagnostics
* environment validation
* command existence detection
* optional dependency detection
* developer onboarding
* first-run setup
* update checker
* profile health checks
* automatic repair suggestions
* shell capability reporting
* optional telemetry disabled by default
* configuration validation

Everything should fail gracefully.

---

# Startup Improvements

Improve startup reliability.

The startup script should:

* detect environment
* detect OS
* detect terminal
* detect fonts
* detect missing dependencies
* detect unsupported features
* load modules safely
* continue loading even if one module fails
* provide helpful diagnostics

Avoid hard failures whenever possible.

---

# Modular Architecture

Refactor into clear modules.

Example:

```
modules/

Core/

Git/

History/

Prompt/

Icons/

Utilities/

Diagnostics/

Platform/

Windows/

Mac/

Shared/
```

Each module should have a single responsibility.

Avoid giant monolithic scripts.

---

# Icons

Current icons occasionally break.

Improve the icon system.

Requirements:

* lightweight
* scalable
* minimal
* Unicode-safe
* Nerd Font aware
* graceful fallback
* plain ASCII fallback
* no broken glyphs
* no dependency on unsupported fonts

Detect whether Nerd Fonts are available.

If unavailable:

Automatically switch to safe Unicode or ASCII icons.

Never display broken replacement characters.

---

# Safety

Prefer defensive programming.

Always:

* validate inputs
* check command existence
* check permissions
* use safe defaults
* provide fallbacks
* avoid destructive behavior
* handle exceptions
* produce meaningful error messages

---

# Code Quality

Improve:

* naming
* organization
* consistency
* comments
* formatting
* readability
* maintainability

Remove duplicated logic.

Extract reusable functions.

---

# Documentation

Every major module should include documentation.

Document:

* purpose
* responsibilities
* dependencies
* examples
* usage
* extension points

Keep documentation synchronized with the implementation.

---

# Branch Strategy

The work should be organized as:

```
main

dev-os/windows-master

dev-os/mac-master

dev-native-os/mac-main
```

Each branch should be independently usable.

---

# Do Not

* Do not remove working aliases.
* Do not introduce unnecessary breaking changes.
* Do not over-engineer.
* Do not duplicate code across platforms.
* Do not hardcode platform-specific behavior.
* Do not assume Nerd Fonts exist.
* Do not assume Windows or macOS paths.
* Do not silently fail.
* Do not reduce performance.

---

# Deliverables

By the end of the work, provide:

* Repository audit report
* Architecture review
* Bug report
* Suggested improvements
* Refactored modular structure
* Improved PowerShell implementation
* Windows-compatible implementation
* macOS PowerShell implementation
* Native macOS shell implementation
* Expanded Git alias library
* Improved startup scripts
* Improved icon system with fallbacks
* Comprehensive documentation
* README updates
* Developer onboarding guide
* Future Linux migration plan
* Changelog summarizing every modification

Throughout the process, prioritize reliability, maintainability, portability, developer experience, and backward compatibility over adding unnecessary complexity.
