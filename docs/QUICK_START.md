# Quick Start Guide

## Prerequisites

- Git Bash (Windows only)
- Terminal (macOS/Linux)

## Start Server

1. Open your terminal (Git Bash on Windows, Terminal on macOS/Linux)
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
4. The start script will automatically download and install Coder if needed
5. Open browser to `http://127.0.0.1:3000`

## Stop Server

Press `Ctrl+C` in terminal

## Manual Installation (Alternative)

If you prefer to manually install Coder, you can use one of these methods:

### Option 1: Direct Download
1. Download the appropriate binary from [GitHub releases](https://github.com/coder/coder/releases)
2. Extract `coder`/`coder.exe` to project root

### Option 2: Package Managers
- **Windows**: `winget install Coder.Coder`
- **macOS**: `brew install coder`
- **Linux**: Install via apt (see [Coder documentation](https://coder.com/docs/v2/latest/install))

After installation, move the `coder`/`coder.exe` binary to the project root directory.

## Good/Happy Path Diagram

```
┌─────────────────────────────────────┐
│           User's Machine            │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐    │
│  │   Terminal (Git Bash)       │    │
│  └─────────────▲───────────────┘    │
│                │                    │
│  ┌─────────────┴───────────────┐    │
│  │   Project Directory         │    │
│  │  ┌─────────────────────┐    │    │
│  │  │     coder.exe       │    │    │
│  │  └─────────────────────┘    │    │
│  │  ┌─────────────────────┐    │    │
│  │  │  start.windows.sh   │    │    │
│  │  └─────────────────────┘    │    │
│  └─────────────────────────────┘    │
│                │                    │
│  ┌─────────────▼───────────────┐    │
│  │   Coder Server (localhost)  │    │
│  │   http://127.0.0.1:3000     │    │
│  └─────────────────────────────┘    │
│                │                    │
│  ┌─────────────▼───────────────┐    │
│  │   Web Browser               │    │
│  │                             │    │
│  │   ┌─────────────────────┐   │    │
│  │   │   Coder Dashboard   │   │    │
│  │   └─────────────────────┘   │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```