# Coder Starter Scripts

Platform-specific startup scripts for running local Coder server instances. Automates binary acquisition and environment setup for development and evaluation purposes.

## Status

This repository is in active development. The scripts are stable for local development and testing workflows. GitHub Codespaces support is the primary development focus, with improvements regularly backported to platform-specific scripts.

**Intended Use**: Local development, evaluation, and experimentation with Coder
**Not Intended For**: Production deployments or enterprise installations

## Quick Start

Choose the script for your platform and execute:

```bash
# Windows (Git Bash or WSL)
./start.windows.sh

# macOS
./start.mac.sh

# Linux
./start.linux.sh

# GitHub Codespaces
./start.gh.codespaces.sh
```

The script will automatically download the Coder binary if not present, then start the server at `http://127.0.0.1:3000`. Stop with `Ctrl+C`.

### GitHub Codespaces Options

```bash
# Download and verify only (skip server start)
SKIP_CODER_SERVER=1 ./start.gh.codespaces.sh

# Suppress non-critical logs
QUIET=1 ./start.gh.codespaces.sh

# Force redownload latest version
rm -f .bin/coder && ./start.gh.codespaces.sh
```

## Architecture

### Binary Management

Scripts follow a strict policy of never committing the Coder binary to version control:

- Binaries are downloaded on-demand from GitHub releases
- Codespaces script isolates downloads in `.bin/` directory (gitignored)
- Legacy platform scripts download to project root (also gitignored)
- All binaries and archives are excluded via `.gitignore`

### Download Strategy

Each script implements a multi-method fallback approach:

1. **Primary**: Direct download from GitHub releases
   - Fetches latest version via GitHub API
   - Automatic architecture detection (amd64/arm64)
   - Platform-specific archive formats (tar.gz for Linux, zip for macOS/Windows)

2. **Fallback**: Platform package manager
   - Windows: winget
   - macOS: Homebrew
   - Linux: apt

3. **Final Fallback**: Manual installation instructions

### Codespaces-Specific Design

The `start.gh.codespaces.sh` script is purpose-built for ephemeral environments:

- No privileged operations (no sudo/apt)
- Strict error handling (`set -euo pipefail`)
- Robust version detection with API rate limit fallback
- Temporary directory extraction with safe binary discovery
- Environment-based configuration flags

### Windows-Specific Behavior

The Windows script includes PostgreSQL directory management:

- Loads `.env` file if present (for `POSTGRES_DIR` override)
- Defaults to `$HOME/AppData/Roaming/coderv2/postgres`
- Removes and recreates directory on each startup for clean state

## Platform Support

| Platform | Script | Status | Notes |
|----------|--------|--------|-------|
| Linux | `start.linux.sh` | Stable | Tested on Ubuntu, supports apt fallback |
| macOS | `start.mac.sh` | Stable | Supports both Intel and Apple Silicon |
| Windows | `start.windows.sh` | Stable | Requires Git Bash or WSL |
| GitHub Codespaces | `start.gh.codespaces.sh` | Active Development | Primary development target |

## Configuration

### Environment Variables

Create a `.env` file (see `.env.example` for template):

```bash
# Windows only: Override PostgreSQL data directory
POSTGRES_DIR=/path/to/your/postgres/data
```

### Planned Environment Variables

The following variables are planned for future releases:

- `CODER_VERSION`: Pin specific Coder version instead of always fetching latest
- `CODER_FORCE_ARCH`: Override automatic architecture detection

## Limitations

This project is explicitly scoped for local development and evaluation:

1. **Not for Production**: No high-availability, backup, or monitoring features
2. **Ephemeral Data**: Windows script resets PostgreSQL data on each run
3. **No Security Hardening**: Uses default configurations and embedded databases
4. **Single-User Focus**: Designed for individual developer workflows
5. **No Update Management**: Always pulls latest release (no version pinning yet)
6. **Limited Network Options**: Binds to localhost only

## Documentation

- [Quick Start Guide](docs/QUICK_START.md): Detailed installation and usage instructions
- [Maintainer Guide](docs/MAINTAINER.md): Binary management, troubleshooting, and release processes
- [Project Instructions](CLAUDE.md): Development guidelines for AI-assisted coding

## Development Workflow

### Testing Changes

```bash
# Clean test in Codespaces
rm -rf .bin && SKIP_CODER_SERVER=1 bash start.gh.codespaces.sh

# Full launch test
bash start.gh.codespaces.sh
```

### Maintenance Tasks

1. Verify `.gitignore` excludes binaries and `.bin/` directory
2. Test download fallback methods (API, redirect, package manager)
3. Validate architecture detection across platforms
4. Never commit binary files or archives

## License

This repository is licensed under the MIT License. See [LICENSE](LICENSE) for details.

The Coder binary downloaded by these scripts is separately licensed. Refer to the [Coder project](https://github.com/coder/coder) for upstream licensing information.

## Related Projects

- [Coder](https://github.com/coder/coder): Self-hosted cloud development environments
- [Coder Documentation](https://coder.com/docs): Official Coder documentation

---
*Last synced: 2026-03-30 via [workspace ecosystem](https://github.com/BA-CalderonMorales)*
