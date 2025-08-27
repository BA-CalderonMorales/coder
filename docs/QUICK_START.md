# Quick Start Guide

## Prerequisites

- Git Bash (Windows)

## Install Coder

### Option 1: Curl (Recommended)
```bash
curl -L https://coder.com/install.sh | sh
```
After installation, move `coder.exe` to the project root directory.

### Option 2: Winget (Fallback)
```bash
winget install Coder.Coder
```
After installation, locate `coder.exe` and move it to the project root directory.

### Option 3: Manual Install (Fallback)
1. Download from [GitHub releases](https://github.com/coder/coder/releases)
2. Extract `coder.exe` to project root

## Start Server

1. Open Git Bash
2. Navigate to project directory
3. Ensure `coder.exe` is in the project root directory (required for start script)
4. Run start script:
   ```bash
   ./start.windows.sh
   ```
5. Open browser to `http://127.0.0.1:3000`

## Stop Server

Press `Ctrl+C` in terminal

## Good/Happy Path Diagram

```
┌─────────────────────────────────────┐
│           User's Machine            │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐    │
│  │   Git Bash (Terminal)       │    │
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