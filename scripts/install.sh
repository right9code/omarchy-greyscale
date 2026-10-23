#!/usr/bin/env bash
set -e

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$BIN_DIR"
ln -sf "$PLUGIN_DIR/bin/omarchy-toggle-greyscale" "$BIN_DIR/omarchy-toggle-greyscale"
chmod +x "$BIN_DIR/omarchy-toggle-greyscale"

echo "✓ Installed omarchy-toggle-greyscale to $BIN_DIR"
