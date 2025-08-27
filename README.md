# Coder Local Development Setup

Repository for running a local Coder server instance.

[Official Coder Repository](https://github.com/coder/coder)

## Quick Start

See [Quick Start Guide](./docs/QUICK_START.md)

## Contents

- Platform-specific start scripts (`start.windows.sh`, `start.mac.sh`, `start.linux.sh`)
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