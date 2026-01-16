#!/usr/bin/env bash
set -euo pipefail

# Run relative to this script's directory
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

DOWNLOADER_EXE="hytale-downloader/hytale-downloader-linux-amd64"
DOWNLOADER_URL="https://downloader.hytale.com/hytale-downloader.zip"
TMP_DIR="tmp"
DOWNLOADER_ZIP="$TMP_DIR/hytale-downloader.zip"

HYTALE_ZIP="libs/hytale.zip"
CREDENTIALS="hytale-downloader/credentials.json"

fail() {
  echo "Script failed."
  exit 1
}

# Requirements
command -v curl >/dev/null 2>&1 || { echo "ERROR: curl is required but not installed."; fail; }
command -v tar  >/dev/null 2>&1 || { echo "ERROR: tar is required but not installed."; fail; }
command -v unzip >/dev/null 2>&1 || { echo "ERROR: unzip is required but not installed."; fail; }

mkdir -p "libs"

# 1) Ensure Hytale Downloader CLI exists
if [[ ! -f "$DOWNLOADER_EXE" ]]; then
  echo "Downloading Hytale Downloader CLI..."
  mkdir -p "$TMP_DIR"

  curl -L --fail -o "$DOWNLOADER_ZIP" "$DOWNLOADER_URL"

  echo "Extracting Hytale Downloader..."
  mkdir -p "hytale-downloader"

  # Zip extraction
  unzip -o "$DOWNLOADER_ZIP" -d "hytale-downloader" >/dev/null

  # Cleanup tmp
  rm -rf "$TMP_DIR"
fi

# Ensure executable bit (zip sometimes preserves, sometimes doesn't)
chmod +x "$DOWNLOADER_EXE" 2>/dev/null || true

# 2) Download Hytale
echo "Downloading Hytale..."
"$DOWNLOADER_EXE" -download-path "$HYTALE_ZIP" -credentials-path "$CREDENTIALS"

# 3) Extract the contents of libs/hytale.zip to libs
echo "Extracting Hytale..."
unzip -o "$HYTALE_ZIP" -d "libs" >/dev/null

# 4) Delete hytale-downloader/hytale.zip (and also libs/hytale.zip since that's where we downloaded it)
rm -f "$HYTALE_ZIP"
rm -f "hytale-downloader/hytale.zip" 2>/dev/null || true

echo "Done."
