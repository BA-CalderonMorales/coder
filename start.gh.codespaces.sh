#!/bin/bash

# Dedicated script for GitHub Codespaces
# Safe: no sudo/apt, robust extraction, optional skip of server start

set -euo pipefail
IFS=$'\n\t'

# Detect if running in Codespaces
if [ -z "$CODESPACES" ]; then
    echo "This script is intended for GitHub Codespaces only."
    exit 1
fi

QUIET=${QUIET:-0}
SKIP_CODER_SERVER=${SKIP_CODER_SERVER:-0}
BIN_DIR=".bin"
mkdir -p "$BIN_DIR"
CODER_BIN="coder"
CODER_PATH="$BIN_DIR/$CODER_BIN"

log(){
    if [ "$QUIET" -ne 1 ]; then
        echo "$@"
    fi
}

# Resolve architecture mapping
detect_arch(){
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64|amd64) echo "linux_amd64" ;;
        aarch64|arm64) echo "linux_arm64" ;;
        *) echo "unsupported" ;;
    esac
}

download_coder(){
    command -v curl >/dev/null 2>&1 || { echo "curl is required"; return 1; }

    local api_resp latest arch mapped platform url tmpdir tarfile extracted_bin
    api_resp=$(curl -fsSL https://api.github.com/repos/coder/coder/releases/latest || true)
    latest=$(echo "$api_resp" | grep -m1 '"tag_name"' | cut -d '"' -f4)

    # Fallback: try headers redirect if API failed (e.g., rate limited)
    if [ -z "$latest" ]; then
        latest=$(curl -I -s https://github.com/coder/coder/releases/latest | grep -i '^location:' | sed -E 's#.*/tag/([^[:space:]]+)#\1#I' | tr -d '\r')
    fi

    if [ -z "$latest" ]; then
        echo "Could not determine latest version of coder." >&2
        return 1
    fi

    arch=$(detect_arch)
    if [ "$arch" = "unsupported" ]; then
        echo "Unsupported architecture $(uname -m)" >&2
        return 1
    fi

    platform="$arch" # already includes linux_ prefix
    # Strip leading v for asset naming
    local version_no_v="${latest#v}"
    url="https://github.com/coder/coder/releases/download/${latest}/coder_${version_no_v}_${platform}.tar.gz"
    log "Latest coder version: $latest"
    log "Downloading: $url"

    tmpdir=$(mktemp -d)
    tarfile="$tmpdir/coder.tgz"
    if ! curl -fL "$url" -o "$tarfile"; then
        echo "Download failed." >&2
        rm -rf "$tmpdir"
        return 1
    fi

    # List archive contents for debug (non-fatal)
    if [ "$QUIET" -ne 1 ]; then
        tar -tzf "$tarfile" 2>/dev/null | head -n 20
    fi

    # Extract to temp dir
    if ! tar -xzf "$tarfile" -C "$tmpdir"; then
        echo "Extraction failed." >&2
        rm -rf "$tmpdir"
        return 1
    fi

    # Find coder binary
    extracted_bin=$(find "$tmpdir" -maxdepth 3 -type f -name coder -perm -u+x | head -n1)
    if [ -z "$extracted_bin" ]; then
        # Maybe not marked executable yet
        extracted_bin=$(find "$tmpdir" -maxdepth 3 -type f -name coder | head -n1)
    fi
    if [ -z "$extracted_bin" ]; then
        echo "coder binary not found after extraction." >&2
        rm -rf "$tmpdir"
        return 1
    fi

        mv "$extracted_bin" "$CODER_PATH"
        chmod +x "$CODER_PATH"
        log "Coder downloaded to $CODER_PATH"
    rm -rf "$tmpdir"
}

if [ ! -x "$CODER_PATH" ]; then
    log "coder binary not found in $BIN_DIR. Downloading..."
    download_coder || { echo "Failed to obtain coder."; exit 1; }
fi

if [ "$SKIP_CODER_SERVER" -eq 1 ]; then
    log "SKIP_CODER_SERVER=1 set; skipping server start."
        if [ -x "$CODER_PATH" ]; then
            "$CODER_PATH" version || true
    else
        echo "Expected ./$CODER_BIN binary not found or not executable." >&2
    fi
    exit 0
fi

echo "Starting Coder Server..."
echo "Navigate to http://127.0.0.1:3000 in your browser after the server starts."
echo "Press Ctrl+C to stop the server."

# Run the Coder server
"$CODER_PATH" server
