# Graphite Helper

**Your personal inbox for GitHub pull requests.** Stop context-switching between tabs, notifications, and Slack messages — Graphite Helper brings everything into one fast, native app that lives in your menu bar.

## Why Graphite Helper?

GitHub's notification system is noisy. Important review requests get buried. Comments go unread. You miss the PR that's been waiting on you for two days.

Graphite Helper fixes this:

- **Unified PR inbox** — Every pull request you're involved in, organized by what needs your attention
- **Live comment threads** — Read and reply to review comments without leaving the app
- **Smart sections** — Custom filters to group PRs by state, review status, CI, repo, author, and more
- **Menu bar at a glance** — See your PR counts directly in the tray, organized by section
- **Linear integration** — Link issues and track status alongside your PRs
- **Analytics** — Understand your review cadence and response times
- **Keyboard-first** — Navigate, triage, and reply without touching the mouse
- **Works with Graphite & GitHub** — One-click to open any PR in your preferred platform

Built with Electron. Runs natively on macOS, Linux, and Windows. Updates itself automatically.

## Install

### macOS (Apple Silicon)

```bash
curl -fsSL https://raw.githubusercontent.com/zahlio/graphite-helper-releases/main/install.sh | bash
```

Installs to `/Applications` and launches automatically.

### Linux

```bash
curl -fsSL https://raw.githubusercontent.com/zahlio/graphite-helper-releases/main/install.sh | bash
```

Installs the AppImage to `~/.local/bin/graphite-helper`. Make sure `~/.local/bin` is in your `PATH`.

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/zahlio/graphite-helper-releases/main/install.ps1 | iex
```

Downloads and runs the NSIS installer silently.

### Requirements

- **macOS**: Apple Silicon (M1/M2/M3/M4)
- **Linux**: x86_64 with FUSE support (for AppImage)
- **Windows**: Windows 10+
- A GitHub personal access token (the app will guide you through setup)

### Updating

Graphite Helper checks for updates automatically every 30 minutes. You can also check manually from the app menu: **Graphite Helper → Check for Updates...**

Updates are downloaded and applied seamlessly — no re-download, no quarantine warnings.

## Uninstall

**macOS:**
```bash
rm -rf "/Applications/Graphite Helper.app"
```

**Linux:**
```bash
rm ~/.local/bin/graphite-helper
```

**Windows:** Use "Add or Remove Programs" in Settings, or run the uninstaller from the Start Menu.
