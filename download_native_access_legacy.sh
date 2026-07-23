#!/usr/bin/env bash
set -euo pipefail

# Fast mirror URL
URL="https://archive.ph/o/Um1lZ/https://www.native-instruments.com/fileadmin/downloads/Native_Access_Installer_211108.zip"
DEFAULT_FILENAME="Native_Access_Installer_211108.zip"

# Target location from first argument (optional)
TARGET="${1:-.}"

# Determine target file path
if [ -d "$TARGET" ] || [[ "$TARGET" == */ ]]; then
    mkdir -p "$TARGET"
    DEST_PATH="${TARGET%/}/$DEFAULT_FILENAME"
else
    TARGET_DIR=$(dirname "$TARGET")
    if [ -n "$TARGET_DIR" ] && [ "$TARGET_DIR" != "." ]; then
        mkdir -p "$TARGET_DIR"
    fi
    DEST_PATH="$TARGET"
fi

echo "=========================================="
echo "Native Access Legacy Installer Downloader"
echo "=========================================="
echo "Source: $URL"
echo "Target: $DEST_PATH"
echo "------------------------------------------"

# Download using curl if available, otherwise fallback to wget
if command -v curl &> /dev/null; then
    echo "Downloading with curl (resumable)..."
    curl -L -C - --progress-bar -o "$DEST_PATH" "$URL"
elif command -v wget &> /dev/null; then
    echo "Downloading with wget (resumable)..."
    wget -c --show-progress -O "$DEST_PATH" "$URL"
else
    echo "Error: Neither 'curl' nor 'wget' was found in PATH." >&2
    exit 1
fi

echo "------------------------------------------"
echo "Download completed successfully: $DEST_PATH"
