#!/usr/bin/env bash
set -euo pipefail

PAGE_URL="https://librewave.com/rhapsody/"
TARGET="${1:-.}"

echo "Fetching LibreWave Rhapsody download page..."
PAGE_HTML=$(curl -sL "$PAGE_URL")

# Extract Windows installer URL (.exe) from LibreWave site or GitHub API fallback
INSTALLER_URL=$(echo "$PAGE_HTML" | grep -oE 'https://[^"]+Rhapsody[^"]+\.exe' | head -n 1)

if [ -z "$INSTALLER_URL" ]; then
    echo "Falling back to GitHub API for latest release..."
    INSTALLER_URL=$(curl -sL "https://api.github.com/repos/LibreWaveAudio/Rhapsody/releases/latest" | grep -oE 'https://github.com/LibreWaveAudio/Rhapsody/releases/download/[^"]+\.exe' | head -n 1)
fi

if [ -z "$INSTALLER_URL" ]; then
    echo "Error: Could not extract Windows installer link for LibreWave Rhapsody" >&2
    exit 1
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
echo "LibreWave Rhapsody Windows Installer Downloader"
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
