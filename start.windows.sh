#!/bin/bash

# Load environment variables from .env file if it exists
if [ -f ".env" ]; then
    export $(cat .env | xargs)
fi

# Set default POSTGRES_DIR if not set
POSTGRES_DIR="${POSTGRES_DIR:-$HOME/AppData/Roaming/coderv2/postgres}"

# Check if coder.exe exists, if not download it
if [ ! -f "coder.exe" ]; then
    echo "coder.exe not found. Downloading Coder..."
    
    # Try to download using curl (recommended method)
    if command -v curl &> /dev/null; then
        echo "Downloading Coder using curl..."
        curl -L https://coder.com/install.sh | sh
        # Move the downloaded coder.exe to the project root
        # The install script typically places it in a subdirectory, so we need to find and move it
        if [ -f "./bin/coder.exe" ]; then
            mv ./bin/coder.exe .
        elif [ -f "./coder/bin/coder.exe" ]; then
            mv ./coder/bin/coder.exe .
        else
            # If we can't find it in common locations, try to find it
            CODER_PATH=$(find . -name "coder.exe" -type f 2>/dev/null | head -n 1)
            if [ -n "$CODER_PATH" ]; then
                mv "$CODER_PATH" .
            fi
        fi
    else
        echo "curl not found. Please install curl or download Coder manually."
        echo "Download from: https://github.com/coder/coder/releases"
        exit 1
    fi
    
    # Verify that coder.exe was successfully downloaded
    if [ ! -f "coder.exe" ]; then
        echo "Failed to download coder.exe. Please download it manually from:"
        echo "https://github.com/coder/coder/releases"
        exit 1
    fi
    
    echo "Coder successfully downloaded."
fi

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