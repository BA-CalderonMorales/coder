# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository provides platform-specific startup scripts to quickly spin up a local Coder server instance. The scripts automatically download the Coder binary if not present and handle platform-specific setup requirements.

## Key Scripts

### Platform-Specific Scripts
- `start.windows.sh` - Windows (Git Bash/WSL), handles `.exe` binary and PostgreSQL directory reset
- `start.mac.sh` - macOS, downloads `.zip` archives and supports Homebrew fallback
- `start.linux.sh` - Linux, downloads `.tar.gz` archives and supports apt package manager fallback
- `start.gh.codespaces.sh` - GitHub Codespaces only, isolated binary management in `.bin/`

### Common Usage
```bash
# Start server (auto-downloads Coder if needed)
./start.<platform>.sh

# Access UI at http://127.0.0.1:3000
# Stop with Ctrl+C
```

### GitHub Codespaces Specific
```bash
# Skip server start (download/verify only)
SKIP_CODER_SERVER=1 ./start.gh.codespaces.sh

# Suppress non-critical logs
QUIET=1 ./start.gh.codespaces.sh

# Force redownload latest version
rm -f .bin/coder && ./start.gh.codespaces.sh
```

## Architecture

### Binary Management
- **Critical**: Never commit `coder`, `coder.exe`, or archives to the repository
- Binaries are downloaded on-demand from GitHub releases
- Codespaces script isolates binaries in `.bin/` directory (gitignored)
- Legacy scripts download to project root (also gitignored)

### Download Strategy
All scripts follow a multi-method fallback approach:
1. **Method 1**: Direct download from GitHub releases (primary)
   - Fetches latest version from GitHub API
   - Architecture detection (amd64/arm64)
   - Platform-specific archive formats (tar.gz for Linux, zip for macOS/Windows)
2. **Method 2**: Platform package manager (fallback)
   - Windows: winget
   - macOS: Homebrew
   - Linux: apt
3. **Method 3**: Manual instructions (final fallback)

### Codespaces Script Design
The `start.gh.codespaces.sh` script is purpose-built for ephemeral environments:
- No sudo/privileged operations
- Strict error handling with `set -euo pipefail`
- Robust version detection (API + redirect fallback for rate limits)
- Temp directory extraction with safe binary discovery via `find`
- Environment flags: `SKIP_CODER_SERVER`, `QUIET`

### Windows-Specific Behavior
The Windows script includes PostgreSQL directory management:
- Loads `.env` file if present (for `POSTGRES_DIR` override)
- Defaults to `$HOME/AppData/Roaming/coderv2/postgres`
- Removes and recreates directory on each startup to ensure clean state

## Development Workflow

### Testing Changes to Scripts
```bash
# Clean test in Codespaces
rm -rf .bin && SKIP_CODER_SERVER=1 bash start.gh.codespaces.sh

# Full launch test
bash start.gh.codespaces.sh
```

### Maintenance Tasks
1. Verify `.gitignore` excludes binaries and `.bin/` directory
2. Test download fallback methods (API, redirect, manual)
3. Validate architecture detection on different platforms
4. Never commit script changes that include binary files

### Current Development Focus
The repository prioritizes GitHub Codespaces (`start.gh.codespaces.sh`) for rapid iteration and experimentation. As workflows stabilize, improvements are mirrored back to platform-specific scripts for production-like local testing.

## Configuration

### Environment Variables
Create a `.env` file (see `.env.example`):
- `POSTGRES_DIR` - Override default PostgreSQL data directory (Windows only)

### Future Enhancements (Planned)
- `CODER_VERSION` - Pin specific Coder version instead of always pulling latest
- Checksum verification for downloaded binaries
- Health check endpoint polling after server start

## Important Constraints

1. **Binary Management**: All scripts must maintain the principle of never committing the Coder binary
2. **No Privileged Operations**: Especially in Codespaces, avoid sudo/apt/system-wide installs
3. **Idempotent Scripts**: Running scripts multiple times should be safe and deterministic
4. **User Friction**: Single command should be sufficient to get a working Coder instance

## Documentation Structure

- `README.md` - User-facing quick start and overview
- `docs/QUICK_START.md` - Detailed user guide with installation methods
- `docs/MAINTAINER.md` - Maintainer guide for binary management, troubleshooting, and release processes
