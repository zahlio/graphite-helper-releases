#!/usr/bin/env bash
set -euo pipefail

APP_NAME="Graphite Helper"
REPO="zahlio/graphite-helper-releases"

echo "Installing ${APP_NAME}..."

# Detect OS and architecture
OS=$(uname -s)
ARCH=$(uname -m)

# Fetch latest release version from GitHub API (no jq dependency)
echo "Fetching latest release..."
RELEASE_JSON=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest")
VERSION=$(echo "$RELEASE_JSON" | grep '"tag_name"' | sed -E 's/.*"tag_name"[[:space:]]*:[[:space:]]*"v?([^"]+)".*/\1/')

if [ -z "$VERSION" ]; then
  echo "Error: Could not determine latest version."
  exit 1
fi

echo "Latest version: v${VERSION}"

if [ "$OS" = "Darwin" ]; then
  # --- macOS ---
  INSTALL_DIR="/Applications"

  if [ "$ARCH" != "arm64" ]; then
    echo "Error: Only Apple Silicon (ARM64) is supported on macOS. Detected: ${ARCH}"
    exit 1
  fi

  if [ ! -w "$INSTALL_DIR" ]; then
    echo "Error: ${INSTALL_DIR} is not writable. Try: sudo bash install.sh"
    exit 1
  fi

  TMP_ZIP="/tmp/graphite-helper.zip"
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

  echo "Installing to ${INSTALL_DIR}..."
  unzip -o -q "$TMP_ZIP" -d "$INSTALL_DIR"
  xattr -cr "${INSTALL_DIR}/${APP_NAME}.app" 2>/dev/null || true
  rm -f "$TMP_ZIP"

  echo "Launching ${APP_NAME}..."
  open "${INSTALL_DIR}/${APP_NAME}.app"

elif [ "$OS" = "Linux" ]; then
  # --- Linux ---
  INSTALL_DIR="${HOME}/.local/bin"
  mkdir -p "$INSTALL_DIR"

  APPIMAGE_URL="https://github.com/${REPO}/releases/download/v${VERSION}/Graphite-Helper-${VERSION}.AppImage"
  DEST="${INSTALL_DIR}/graphite-helper"

  echo "Downloading ${APPIMAGE_URL}..."
  curl -fSL -o "$DEST" "$APPIMAGE_URL"
  chmod +x "$DEST"

  echo "Installed to ${DEST}"
  echo "Make sure ${INSTALL_DIR} is in your PATH."
  echo "Run with: graphite-helper"

else
  echo "Error: Unsupported OS: ${OS}. Use install.ps1 for Windows."
  exit 1
fi

echo "Done! ${APP_NAME} v${VERSION} installed successfully."
