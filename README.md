# Omarchy Grayscale Mode (`right9code.greyscale`)

An Omarchy shell plugin that adds an auto-hiding top-bar indicator and desktop grayscale focus filter using Hyprland's screen shader.

## Features
- **Auto-Hiding Bar Indicator**: Integrated into the center status indicator cluster. It hides completely when inactive, reveals on cluster hover (`󰈉`), and turns solid (`󰈈`) when active.
- **Eye / Focus Icon Pair**:
  - `󰈈` (Active / Grayscale ON)
  - `󰈉` (Inactive / Color ON)
- **Zero Overhead**: Uses an optimized Rec. 709 luminance shader (`vec3(0.2126, 0.7152, 0.0722)`).
- **Session & Reload Resilient**: Re-applies shader state seamlessly across Hyprland config reloads.
- **Global Keybinding**: `SUPER + ALT + G` toggles mode with native desktop notifications.

## Requirements
- Omarchy 4+ with Hyprland
- `quickshell` and `hyprctl`

## Installation

Using Omarchy plugin manager:
```bash
omarchy plugin add https://github.com/right9code/omarchy-greyscale --enable --yes
```

Or for local development:
```bash
git clone https://github.com/right9code/omarchy-greyscale.git ~/.config/omarchy/plugins/right9code.greyscale
omarchy plugin enable right9code.greyscale
omarchy-shell shell rescanPlugins
```

## Keybinding Setup
Add to `~/.config/hypr/bindings.lua`:
```lua
o.bind("SUPER + ALT + G", "Toggle Grayscale Mode", "/home/right9zzz/.local/bin/omarchy-toggle-greyscale")
```

## CLI Usage
```bash
omarchy-toggle-greyscale          # Toggle mode
omarchy-toggle-greyscale --status # Returns JSON {"enabled": true|false}
```

## License
MIT
