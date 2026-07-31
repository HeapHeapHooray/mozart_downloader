#!/usr/bin/env bash
set -euo pipefail

PAGE_URL="https://www.synful.com/download"
TARGET="${1:-.}"

echo "Fetching Synful Orchestra download page..."
PAGE_HTML=$(curl -sL "$PAGE_URL" || true)

# Extract Windows installer URL from Synful website or fallback
INSTALLER_URL=$(echo "$PAGE_HTML" | grep -oE 'https://[^"'\''<>]*SynfulOrchestraSetup[^"'\''<>]*' | head -n 1 || true)

if [ -z "$INSTALLER_URL" ]; then
    INSTALLER_URL="https://www.synful.com/_files/archives/fcb387_3500a2198b7a4d5ba70c4d44267dd91a.zip?dn=SynfulOrchestraSetup-271.zip"
fi

DEFAULT_FILENAME=$(echo "$INSTALLER_URL" | grep -oE 'dn=[^&]+' | cut -d'=' -f2 || true)
if [ -z "$DEFAULT_FILENAME" ]; then
    DEFAULT_FILENAME="SynfulOrchestraSetup-271.zip"
fi

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
echo "Synful Orchestra Windows Installer Downloader"
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
