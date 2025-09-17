#!/bin/bash

# Check if coder binary exists, if not download it
if [ ! -f "coder" ]; then
    echo "coder binary not found. Attempting to download Coder..."
    
    # Method 1: Try to download the binary directly using curl
    echo "Attempting Method 1: Direct binary download..."
    if command -v curl &> /dev/null; then
        # Get the latest release version
        LATEST_VERSION=$(curl -s https://api.github.com/repos/coder/coder/releases/latest | grep "tag_name" | cut -d '"' -f 4)
        if [ -n "$LATEST_VERSION" ]; then
            ARCH=$(uname -m)
            if [ "$ARCH" = "x86_64" ]; then
                DOWNLOAD_URL="https://github.com/coder/coder/releases/download/${LATEST_VERSION}/coder_${LATEST_VERSION#v}_darwin_amd64.zip"
            elif [ "$ARCH" = "arm64" ]; then
                DOWNLOAD_URL="https://github.com/coder/coder/releases/download/${LATEST_VERSION}/coder_${LATEST_VERSION#v}_darwin_arm64.zip"
            else
                echo "Unsupported architecture: $ARCH"
                DOWNLOAD_URL=""
            fi
            
            if [ -n "$DOWNLOAD_URL" ]; then
                echo "Downloading from: $DOWNLOAD_URL"
                if curl -L -o coder.zip "$DOWNLOAD_URL"; then
                    # Extract the zip file
                    unzip -o coder.zip coder
                    # Clean up
                    rm -f coder.zip
                    # Make it executable
                    chmod +x coder
                    echo "Coder successfully downloaded via direct binary download."
                else
                    echo "Failed to download via direct binary download."
                fi
            fi
        else
            echo "Failed to determine latest version for direct binary download."
        fi
    else
        echo "curl not found for direct binary download."
    fi
    
    # Method 2: If Method 1 failed, try brew
    if [ ! -f "coder" ]; then
        echo "Attempting Method 2: Brew installation..."
        if command -v brew &> /dev/null; then
            if brew install coder; then
                # Copy to current directory
                if command -v coder &> /dev/null; then
                    cp $(which coder) .
                    echo "Coder successfully installed via brew."
                fi
            else
                echo "Brew installation failed."
            fi
        else
            echo "brew not found."
        fi
    fi
    
    # Method 3: If both methods failed, manual download instructions
    if [ ! -f "coder" ]; then
        echo "Attempting Method 3: Manual download from GitHub releases..."
        echo "Please manually download coder from: https://github.com/coder/coder/releases/latest"
        echo "Extract the zip file and place the coder binary in this directory."
        echo "Then run this script again."
        exit 1
    fi
    
    # Verify that coder was successfully obtained
    if [ ! -f "coder" ]; then
        echo "Failed to obtain coder binary using any method."
        echo "Please manually download coder from: https://github.com/coder/coder/releases/latest"
        echo "Extract the zip file and place the coder binary in this directory."
        exit 1
    fi
    
    # Make it executable
    chmod +x coder
fi

echo "Starting Coder Server..."
echo "Navigate to http://127.0.0.1:3000 in your browser after the server starts."
echo "Press Ctrl+C to stop the server."

# Run the Coder server
./coder server