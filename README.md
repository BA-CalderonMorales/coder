# Coder Local Development Setup

Repository for running a local Coder server instance.

[Official Coder Repository](https://github.com/coder/coder)

## Quick Start

See [Quick Start Guide](./docs/QUICK_START.md)

## Contents

- `coder.exe`: Coder server executable (Git ignored)
- `start.windows.sh`: Start script for Coder server
- `docs/`: Documentation guides

## Prerequisites

- Git Bash
- `coder.exe` in project root

## Start Server

1. Open Git Bash
2. Navigate to project directory
3. Run start script:
   ```bash
   ./start.windows.sh
   ```
4. Open browser to `http://127.0.0.1:3000`

## Stop Server

Press `Ctrl+C` in terminal

## Environment Variables

Configure with `.env` file (see `.env.example`)