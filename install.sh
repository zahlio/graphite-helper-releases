#!/usr/bin/env bash
set -euo pipefail

APP_NAME="Graphite Helper"
REPO="zahlio/graphite-helper-releases"
INSTALL_DIR="/Applications"
TMP_ZIP="/tmp/graphite-helper.zip"

echo "Installing ${APP_NAME}..."

# Architecture check — ARM64 only for now
ARCH=$(uname -m)
if [ "$ARCH" != "arm64" ]; then
  echo "Error: Only Apple Silicon (ARM64) is supported. Detected: ${ARCH}"
  exit 1
fi

# Check /Applications is writable
if [ ! -w "$INSTALL_DIR" ]; then
  echo "Error: ${INSTALL_DIR} is not writable. Try: sudo bash install.sh"
  exit 1
fi

# Fetch latest release version from GitHub API (no jq dependency)
echo "Fetching latest release..."
RELEASE_JSON=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest")
VERSION=$(echo "$RELEASE_JSON" | grep '"tag_name"' | sed -E 's/.*"tag_name"[[:space:]]*:[[:space:]]*"v?([^"]+)".*/\1/')

if [ -z "$VERSION" ]; then
  echo "Error: Could not determine latest version."
  exit 1
fi

echo "Latest version: v${VERSION}"

# Download ZIP
ZIP_URL="https://github.com/${REPO}/releases/download/v${VERSION}/Graphite-Helper-${VERSION}-arm64-mac.zip"
echo "Downloading ${ZIP_URL}..."
curl -fSL -o "$TMP_ZIP" "$ZIP_URL"

# Kill running instance if present
if pgrep -x "$APP_NAME" > /dev/null 2>&1; then
  echo "Stopping running instance..."
  pkill -x "$APP_NAME" || true
  sleep 1
fi

# Remove old installation
if [ -d "${INSTALL_DIR}/${APP_NAME}.app" ]; then
  echo "Removing old version..."
  rm -rf "${INSTALL_DIR}/${APP_NAME}.app"
fi

# Extract to /Applications
echo "Installing to ${INSTALL_DIR}..."
unzip -o -q "$TMP_ZIP" -d "$INSTALL_DIR"

# Clear quarantine attribute
xattr -cr "${INSTALL_DIR}/${APP_NAME}.app" 2>/dev/null || true

# Clean up
rm -f "$TMP_ZIP"

echo "Launching ${APP_NAME}..."
open "${INSTALL_DIR}/${APP_NAME}.app"

echo "Done! ${APP_NAME} v${VERSION} installed successfully."
