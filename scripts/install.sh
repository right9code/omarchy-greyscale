#!/usr/bin/env bash
set -e

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="$HOME/.local/bin"
INDICATOR_PLUGIN_ID="right9zzz.indicators"
INDICATOR_SOURCE="$PLUGIN_DIR/Greyscale.qml"

mkdir -p "$BIN_DIR"
ln -sf "$PLUGIN_DIR/bin/omarchy-toggle-greyscale" "$BIN_DIR/omarchy-toggle-greyscale"
chmod +x "$BIN_DIR/omarchy-toggle-greyscale"

# Install the indicator into a user-owned clone of Omarchy's indicator widget.
# This avoids editing first-party files and survives plugin updates.
if [ ! -d "$HOME/.config/omarchy/plugins/$INDICATOR_PLUGIN_ID" ]; then
  omarchy plugin clone omarchy.indicators
fi

INDICATOR_DIR="$HOME/.config/omarchy/plugins/$INDICATOR_PLUGIN_ID/indicators"
mkdir -p "$INDICATOR_DIR"
cp "$INDICATOR_SOURCE" "$INDICATOR_DIR/Greyscale.qml"

# Add Greyscale to the indicator list without removing existing entries.
python3 - "$HOME/.config/omarchy/shell.json" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path) as f:
    data = json.load(f)

defaults = [
    "PasswordlessSudo",
    "ScreenRecording",
    "RemoteSession",
    "Reminder",
    "NightLight",
    "Dnd",
    "StayAwake",
]

for section, items in data.get("bar", {}).get("layout", {}).items():
    for item in items:
        if item.get("id") != "right9zzz.indicators":
            continue

        current = item.get("items") or []
        merged = list(defaults)
        for entry in current:
            if entry not in merged:
                merged.append(entry)
        if "Greyscale" not in merged:
            merged.append("Greyscale")
        item["items"] = merged

with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY

if command -v omarchy-shell >/dev/null 2>&1; then
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
fi
if command -v omarchy-restart-shell >/dev/null 2>&1; then
  omarchy-restart-shell >/dev/null 2>&1 || true
fi

echo "✓ Installed omarchy-toggle-greyscale to $BIN_DIR"
echo "✓ Installed Greyscale indicator into $INDICATOR_PLUGIN_ID"
