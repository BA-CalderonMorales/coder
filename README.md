# Coder Local Development Setup

This repository contains the necessary files to run a local instance of the Coder server for development and testing purposes.

For comprehensive documentation, please refer to the official Coder repository: [https://github.com/coder/coder](https://github.com/coder/coder)

## Quick Start (Git Bash)

To get started quickly with Coder in Git Bash, please refer to our [Quick Start Guide](./docs/QUICK_START.md).

## Contents

- `coder.exe`: The Coder server executable (ignored by Git).
- `start.sh`: A script to start the Coder server locally.
- `docs/QUICK_START.md`: Instructions for starting the Coder server in Git Bash.

## Prerequisites

- Git Bash (for Windows users).
- The `coder.exe` file must be present in this directory.

## Starting the Server

1. Open Git Bash.
2. Navigate to this directory.
3. Run the start script:
   ```bash
   ./start.sh
   ```
4. Once the server is running, open your browser and go to `http://127.0.0.1:3000`.

## Stopping the Server

To stop the server, press `Ctrl+C` in the terminal where the server is running.

## Environment Variables

You can configure the server using a `.env` file. An example `.env.example` file is provided.