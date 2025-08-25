#!/bin/bash

# Load environment variables from .env file if it exists
if [ -f ".env" ]; then
    export $(cat .env | xargs)
fi

# Set default POSTGRES_DIR if not set
POSTGRES_DIR="${POSTGRES_DIR:-$HOME/AppData/Roaming/coderv2/postgres}"

# Start the Coder server
echo "Starting Coder Server..."
echo "Navigate to http://127.0.0.1:3000 in your browser after the server starts."
echo "Press Ctrl+C to stop the server."

# Ensure the PostgreSQL directory exists with proper permissions
if [ -d "$POSTGRES_DIR" ]; then
    echo "Removing existing PostgreSQL directory..."
    rm -rf "$POSTGRES_DIR"
fi

echo "Creating PostgreSQL directory at $POSTGRES_DIR..."
mkdir -p "$POSTGRES_DIR"

# Run the Coder server
./coder.exe server