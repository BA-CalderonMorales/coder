#!/bin/bash

# Check if coder binary exists, if not download it
if [ ! -f "coder" ]; then
    echo "coder binary not found. Downloading Coder..."
    
    # Try to download using curl
    if command -v curl &> /dev/null; then
        echo "Downloading Coder using curl..."
        curl -L https://coder.com/install.sh | sh
        # Move the downloaded coder binary to the project root
        if [ -f "./bin/coder" ]; then
            mv ./bin/coder .
        elif [ -f "./coder/bin/coder" ]; then
            mv ./coder/bin/coder .
        else
            # If we can't find it in common locations, try to find it
            CODER_PATH=$(find . -name "coder" -type f 2>/dev/null | head -n 1)
            if [ -n "$CODER_PATH" ]; then
                mv "$CODER_PATH" .
            fi
        fi
    else
        echo "curl not found. Please install curl or download Coder manually."
        echo "Download from: https://github.com/coder/coder/releases"
        exit 1
    fi
    
    # Verify that coder was successfully downloaded
    if [ ! -f "coder" ]; then
        echo "Failed to download coder binary. Please download it manually from:"
        echo "https://github.com/coder/coder/releases"
        exit 1
    fi
    
    # Make it executable
    chmod +x coder
    
    echo "Coder successfully downloaded."
fi

echo "Starting Coder Server..."
echo "Navigate to http://127.0.0.1:3000 in your browser after the server starts."
echo "Press Ctrl+C to stop the server."

# Run the Coder server
./coder server