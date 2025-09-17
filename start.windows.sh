#!/bin/bash

# Load environment variables from .env file if it exists
if [ -f ".env" ]; then
    export $(cat .env | xargs)
fi

# Set default POSTGRES_DIR if not set
POSTGRES_DIR="${POSTGRES_DIR:-$HOME/AppData/Roaming/coderv2/postgres}"

# Check if coder.exe exists, if not download it
if [ ! -f "coder.exe" ]; then
    echo "coder.exe not found. Attempting to download Coder..."
    
    # Method 1: Try to download the binary directly using curl
    echo "Attempting Method 1: Direct binary download..."
    if command -v curl &> /dev/null; then
        # Get the latest release version
        LATEST_VERSION=$(curl -s https://api.github.com/repos/coder/coder/releases/latest | grep "tag_name" | cut -d '"' -f 4)
        if [ -n "$LATEST_VERSION" ]; then
            DOWNLOAD_URL="https://github.com/coder/coder/releases/download/${LATEST_VERSION}/coder_${LATEST_VERSION#v}_windows_amd64.zip"
            echo "Downloading from: $DOWNLOAD_URL"
            if curl -L -o coder.zip "$DOWNLOAD_URL"; then
                # Extract the zip file
                unzip -o coder.zip coder.exe
                # Clean up
                rm -f coder.zip
                echo "Coder successfully downloaded via direct binary download."
            else
                echo "Failed to download via direct binary download."
            fi
        else
            echo "Failed to determine latest version for direct binary download."
        fi
    else
        echo "curl not found for direct binary download."
    fi
    
    # Method 2: If Method 1 failed, try winget
    if [ ! -f "coder.exe" ]; then
        echo "Attempting Method 2: Winget installation..."
        if command -v winget &> /dev/null; then
            if winget install Coder.Coder; then
                # Try to locate the installed coder.exe
                # Winget typically installs to %LOCALAPPDATA%\Programs\Coder\
                WINGET_INSTALL_PATH="$LOCALAPPDATA/Programs/Coder/coder.exe"
                if [ -f "$WINGET_INSTALL_PATH" ]; then
                    cp "$WINGET_INSTALL_PATH" .
                    echo "Coder successfully installed via winget."
                else
                    # Try another common location
                    WINGET_INSTALL_PATH="/c/Program Files/Coder/coder.exe"
                    if [ -f "$WINGET_INSTALL_PATH" ]; then
                        cp "$WINGET_INSTALL_PATH" .
                        echo "Coder successfully installed via winget."
                    else
                        echo "Winget installation succeeded but coder.exe not found in expected locations."
                    fi
                fi
            else
                echo "Winget installation failed."
            fi
        else
            echo "winget not found."
        fi
    fi
    
    # Method 3: If both methods failed, manual download instructions
    if [ ! -f "coder.exe" ]; then
        echo "Attempting Method 3: Manual download from GitHub releases..."
        echo "Please manually download coder.exe from: https://github.com/coder/coder/releases/latest"
        echo "Extract the zip file and place coder.exe in this directory."
        echo "Then run this script again."
        exit 1
    fi
    
    # Verify that coder.exe was successfully obtained
    if [ ! -f "coder.exe" ]; then
        echo "Failed to obtain coder.exe using any method."
        echo "Please manually download coder.exe from: https://github.com/coder/coder/releases/latest"
        echo "Extract the zip file and place coder.exe in this directory."
        exit 1
    fi
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