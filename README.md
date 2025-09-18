# Coder Local Development Setup

Repository for running a local Coder server instance.

[Official Coder Repository](https://github.com/coder/coder)

## Quick Start

See [Quick Start Guide](./docs/QUICK_START.md)

## Contents

- Platform-specific start scripts (`start.windows.sh`, `start.mac.sh`, `start.linux.sh`)
- GitHub Codespaces bootstrap script (`start.gh.codespaces.sh`)
- Documentation in `docs/` directory

## Prerequisites

- Git Bash (Windows), Terminal (macOS/Linux)
- Internet connection (for automatic Coder download)

## Start Server

1. Open your terminal (Git Bash on Windows)
2. Navigate to project directory
3. Run the appropriate start script for your platform:
   ```bash
   # Windows
   ./start.windows.sh
   
   # macOS
   ./start.mac.sh
   
   # Linux
   ./start.linux.sh
   
   # GitHub Codespaces (inside a Codespace terminal)
   ./start.gh.codespaces.sh
   ```
4. Open browser to `http://127.0.0.1:3000`

## Stop Server

Press `Ctrl+C` in terminal

## Environment Variables

Configure with `.env` file (see `.env.example`)

## Automatic Coder Installation

The start scripts will automatically download and install Coder if it's not found in the project directory:
1. Direct download from GitHub releases (primary method)
2. Platform-specific package managers (fallback)
3. Manual download instructions (final fallback)

## GitHub Codespaces Usage

We currently lean on `./start.gh.codespaces.sh` to rapidly spin up and tear down an isolated learning / experimentation environment without polluting local machines. This script is optimized for:

- Ephemeral environments (open Codespace, explore, discard)
- Fast bootstrap (auto‑download if Coder binary missing)
- Consistent baseline across contributors

### Typical Flow

1. Create / open a GitHub Codespace for this repo
2. Run `./start.gh.codespaces.sh`
3. Wait for the Coder server to report it is listening on port 3000
4. Use the forwarded port (Codespaces will usually auto-detect) to open the UI
5. When finished, simply stop or delete the Codespace (environment torn down automatically)

### Why Codespaces First?

While we're still solidifying core workflows and fundamentals (auth, workspace templates, storage, update cadence), the ephemeral Codespaces path lets us iterate quickly. Once those fundamentals are stable, we'll rely more heavily on the platform-specific scripts (`start.windows.sh`, `start.mac.sh`, `start.linux.sh`) for long‑lived local installs and deeper performance / networking validation.

### Transition Plan

- Short term: Prefer `start.gh.codespaces.sh` for exploration & docs validation
- Mid term: Mirror any improvements back into local start scripts
- Longer term: Treat Codespaces script as a convenience path; primary guidance shifts to native OS scripts for production‑like local testing

If you notice divergence between the Codespaces script and the others, open an issue or PR so we can keep behavior aligned.