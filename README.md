# Omarchy Grayscale Mode (`right9code.greyscale`)

An Omarchy shell plugin that adds an auto-hiding top-bar indicator and desktop grayscale focus filter using Hyprland's screen shader.

## Features
- **Auto-Hiding Bar Indicator**: Integrated into the center status indicator cluster. It hides completely when inactive, reveals on cluster hover (`󰈉`), and turns solid (`󰈈`) when active.
- **Eye / Focus Icon Pair**:
  - `󰈈` (Active / Grayscale ON)
  - `󰈉` (Inactive / Color ON)
- **Zero Overhead**: Uses an optimized Rec. 709 luminance shader (`vec3(0.2126, 0.7152, 0.0722)`).
- **Session & Reload Resilient**: Re-applies shader state seamlessly across Hyprland config reloads.
- **Pure Bar Control**: Left-click to toggle on/off. Silent, instant, no forced shortcuts or annoying notifications.

## Requirements
- Omarchy 4+ with Hyprland
- `quickshell` and `hyprctl`

## Installation

### 1. Install via Omarchy CLI
```bash
omarchy plugin add https://github.com/right9code/omarchy-greyscale --enable --yes
```

### 2. Link CLI Command (Optional)
If you want to use the `omarchy-toggle-greyscale` CLI command:
```bash
bash ~/.config/omarchy/plugins/right9code.greyscale/scripts/install.sh
```

### 3. Optional Keybinding
If a user wants to configure their own hotkey, they can add this to `~/.config/hypr/bindings.lua`:
```lua
o.bind("SUPER + ALT + G", "Toggle Grayscale Mode", "/home/USERNAME/.local/bin/omarchy-toggle-greyscale")
```

## CLI Usage
```bash
omarchy-toggle-greyscale          # Toggle mode
omarchy-toggle-greyscale --status # Returns JSON {"enabled": true|false}
```

## License
MIT
