#!/usr/bin/env bash
set -euo pipefail

PAGE_URL="https://www.native-instruments.com/pages/native-access"
TARGET="${1:-.}"

echo "Fetching Native Access download page..."
PAGE_HTML=$(curl -sL "$PAGE_URL" || true)

# Extract Windows installer URL (.exe) or fallback to official download URL
INSTALLER_PATH=$(echo "$PAGE_HTML" | grep -oE '(https?://|/)[^"&<>\\]*Native-Access[^"&<>\\]*\.exe' | head -n 1 || true)

if [ -n "$INSTALLER_PATH" ]; then
    if [[ "$INSTALLER_PATH" =~ ^https?:// ]]; then
        INSTALLER_URL="$INSTALLER_PATH"
    else
        INSTALLER_URL="https://www.native-instruments.com/${INSTALLER_PATH#/}"
    fi
else
    INSTALLER_URL="https://storage.googleapis.com/ni-assets/downloads/Native-Access_2.exe"
fi

DEFAULT_FILENAME=$(basename "$INSTALLER_URL")

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
echo "Native Access 2 Windows Installer Downloader"
echo "=========================================="
echo "Installer URL: $INSTALLER_URL"
echo "Target Path:   $DEST_PATH"
echo "------------------------------------------"

# Download using curl if available, otherwise fallback to wget
if command -v curl &> /dev/null; then
    echo "Downloading with curl (resumable)..."
    curl -L -C - --progress-bar -o "$DEST_PATH" "$INSTALLER_URL"
elif command -v wget &> /dev/null; then
    echo "Downloading with wget (resumable)..."
    wget -c --show-progress -O "$DEST_PATH" "$INSTALLER_URL"
else
    echo "Error: Neither 'curl' nor 'wget' was found in PATH." >&2
    exit 1
fi

echo "------------------------------------------"
echo "Download completed successfully: $DEST_PATH"
