#!/usr/bin/env bash
set -euo pipefail

FILE_ID="1x5gnelKSljXLl_sDurlaAYBUBEov8rJr"
URL="https://drive.usercontent.google.com/download?id=${FILE_ID}&export=download&confirm=t"
DEFAULT_FILENAME="edirol_orchestral.rar"
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
echo "EDIROL Orchestral VST Downloader"
echo "=========================================="
echo "Source: Google Drive (ID: $FILE_ID)"
echo "Target: $DEST_PATH"
echo "------------------------------------------"

# Download using curl if available, gdown, or wget
if command -v curl &> /dev/null; then
    echo "Downloading with curl (resumable)..."
    curl -L -C - --progress-bar -o "$DEST_PATH" "$URL"
elif command -v gdown &> /dev/null; then
    echo "Downloading with gdown..."
    gdown "https://drive.google.com/file/d/${FILE_ID}/view" -O "$DEST_PATH"
elif command -v wget &> /dev/null; then
    echo "Downloading with wget..."
    wget -c --show-progress -O "$DEST_PATH" "$URL"
else
    echo "Error: Neither 'curl', 'gdown', nor 'wget' was found in PATH." >&2
    exit 1
fi

echo "------------------------------------------"
echo "Download completed successfully: $DEST_PATH"
