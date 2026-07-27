#!/usr/bin/env bash
set -euo pipefail

API_URL="https://as-api.tdacestudio.com/api/as/conf/dl/v2"
TARGET="${1:-.}"

echo "Fetching ACE Studio installer configuration..."
RESPONSE=$(curl -s \
  -H "platform: win" \
  -H "device: pc" \
  -H "version: 2.0.0" \
  -H "channel: official" \
  "$API_URL" || true)

INSTALLER_URL=""
if command -v jq &>/dev/null; then
    INSTALLER_URL=$(echo "$RESPONSE" | jq -r '.data.resource.win' 2>/dev/null || true)
fi

if [ -z "$INSTALLER_URL" ] || [ "$INSTALLER_URL" = "null" ]; then
    INSTALLER_URL=$(echo "$RESPONSE" | grep -oP '"win":\s*"[^"]+"' | head -n 1 | cut -d'"' -f4 || true)
fi

if [ -z "$INSTALLER_URL" ] || [ "$INSTALLER_URL" = "null" ]; then
    echo "Error: Could not retrieve Windows installer URL for ACE Studio" >&2
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
echo "ACE Studio Windows Installer Downloader"
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
