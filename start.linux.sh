#!/bin/bash

ensure_utf8_locale() {
    local preferred_locales=("en_US.UTF-8" "en_US.utf8" "C.UTF-8" "C.utf8")
    local available_locales
    local selected_locale=""

    available_locales=$(LC_ALL=C locale -a 2>/dev/null)

    for candidate in "${preferred_locales[@]}"; do
        if printf "%s\n" "$available_locales" | grep -qi "^${candidate}$"; then
            selected_locale="$candidate"
            break
        fi
    done

    if [ -z "$selected_locale" ]; then
        local target_locale="en_US.UTF-8"
        echo "Locale $target_locale not found. Attempting to generate it..."

        if command -v locale-gen >/dev/null 2>&1; then
            if sudo locale-gen "$target_locale"; then
                available_locales=$(LC_ALL=C locale -a 2>/dev/null)
                if printf "%s\n" "$available_locales" | grep -qi "^en_US\.utf8$"; then
                    selected_locale="en_US.utf8"
                fi
            else
                echo "Warning: Failed to generate $target_locale using locale-gen."
            fi
        elif command -v localedef >/dev/null 2>&1; then
            if sudo localedef -f UTF-8 -i en_US "$target_locale"; then
                selected_locale="en_US.UTF-8"
            else
                echo "Warning: Failed to generate $target_locale using localedef."
            fi
        else
            echo "Warning: locale-gen and localedef were not found."
        fi
    fi

    if [ -z "$selected_locale" ]; then
        echo "Falling back to C.utf8 locale."
        selected_locale="C.utf8"
    fi

    export LANG="$selected_locale"
    export LC_ALL="$selected_locale"
    export LC_CTYPE="$selected_locale"
    export LC_MESSAGES="$selected_locale"
}

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
                DOWNLOAD_URL="https://github.com/coder/coder/releases/download/${LATEST_VERSION}/coder_${LATEST_VERSION#v}_linux_amd64.tar.gz"
            elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
                DOWNLOAD_URL="https://github.com/coder/coder/releases/download/${LATEST_VERSION}/coder_${LATEST_VERSION#v}_linux_arm64.tar.gz"
            else
                echo "Unsupported architecture: $ARCH"
                DOWNLOAD_URL=""
            fi
            
            if [ -n "$DOWNLOAD_URL" ]; then
                echo "Downloading from: $DOWNLOAD_URL"
                if curl -L -o coder.tar.gz "$DOWNLOAD_URL"; then
                    # Extract the tar.gz file
                    tar -xzf coder.tar.gz
                    # Clean up
                    rm -f coder.tar.gz
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
    
    # Method 2: If Method 1 failed, try package manager (apt)
    if [ ! -f "coder" ]; then
        echo "Attempting Method 2: Package manager installation..."
        if command -v apt &> /dev/null; then
            # Add the repository
            curl -L https://coder.com/apt.gpg | gpg --dearmor > /tmp/coder.gpg
            sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/coder.gpg < /tmp/coder.gpg
            echo "deb https://coder.com/apt stable main" | sudo tee /etc/apt/sources.list.d/coder.list
            sudo apt update
            if sudo apt install coder; then
                # Copy to current directory
                if command -v coder &> /dev/null; then
                    cp "$(command -v coder)" .
                    echo "Coder successfully installed via package manager."
                fi
            else
                echo "Package manager installation failed."
            fi
        else
            echo "apt not found."
        fi
    fi
    
    # Method 3: If both methods failed, manual download instructions
    if [ ! -f "coder" ]; then
        echo "Attempting Method 3: Manual download from GitHub releases..."
        echo "Please manually download coder from: https://github.com/coder/coder/releases/latest"
        echo "Extract the archive and place the coder binary in this directory."
        echo "Then run this script again."
        exit 1
    fi
    
    # Verify that coder was successfully obtained
    if [ ! -f "coder" ]; then
        echo "Failed to obtain coder binary using any method."
        echo "Please manually download coder from: https://github.com/coder/coder/releases/latest"
        echo "Extract the archive and place the coder binary in this directory."
        exit 1
    fi
    
    # Make it executable
    chmod +x coder
fi

echo "Starting Coder Server..."
echo "Navigate to http://127.0.0.1:3000 in your browser after the server starts."
echo "Press Ctrl+C to stop the server."

# Run the Coder server
ensure_utf8_locale
./coder server