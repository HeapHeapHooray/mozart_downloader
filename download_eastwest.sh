#!/usr/bin/env bash
set -euo pipefail

URL="http://software.soundsonline.com/Products/IC/IC_latest_Win.zip"
DEFAULT_FILENAME="IC_latest_Win.zip"
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
echo "EastWest Installation Center Downloader"
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
