import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarIndicator {
  id: root

  readonly property string homeDir: Quickshell.env("HOME") || ""
  readonly property string stateDir: homeDir + "/.local/state/omarchy/indicators"
  readonly property string stateFile: stateDir + "/greyscale"

  active: false
  activeText: "󰈈"
  inactiveText: "󰈉"
  activeTooltipText: "Disable Grayscale Mode"
  inactiveTooltipText: "Enable Grayscale Mode"

  function syncState() {
    probeProc.running = true
  }

  function toggle() {
    toggleProc.running = true
  }

  Process {
    id: probeProc
    command: ["bash", "-c", "[[ -f '" + root.stateFile + "' ]] && echo yes || echo no"]
    stdout: SplitParser {
      onRead: function(line) {
        root.active = (String(line).trim() === "yes")
      }
    }
  }

  FileView {
    path: root.stateDir
    watchChanges: true
    printErrors: false
    onFileChanged: root.syncState()
  }

  Connections {
    target: indicatorHost
    function onRefreshRequested() {
      root.syncState()
    }
  }

  Process {
    id: toggleProc
    command: [root.homeDir + "/.local/bin/omarchy-toggle-greyscale"]
    onExited: {
      root.syncState()
    }
  }

  Component.onCompleted: syncState()
  onPressed: function() { root.toggle() }
}
