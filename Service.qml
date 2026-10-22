import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Item {
  id: root

  property var shell: null
  readonly property string pluginDir: Qt.resolvedUrl(".").toString().replace(/^file:\/\//, "")
  readonly property string shaderPath: pluginDir + "/shaders/grayscale.frag"

  property bool stateLoaded: false
  property bool enabled: false
  property bool pendingState: false
  property bool hasPendingState: false

  function refresh() {
    if (!statusProbe.running) statusProbe.running = true
  }

  function setGrayscale(value) {
    applyGrayscale(value === true)
  }

  function toggle() {
    setGrayscale(!enabled)
  }

  function applyGrayscale(enable) {
    root.enabled = enable
    root.stateLoaded = true

    if (applyProcess.running) {
      root.pendingState = enable
      root.hasPendingState = true
      return
    }

    runApply(enable)
  }

  function runApply(enable) {
    var shaderArg = enable ? root.shaderPath : ""
    var luaArg = enable ? "\"" + root.shaderPath.replace(/\\/g, "\\\\").replace(/"/g, "\\\"") + "\"" : "\"\""
    applyProcess.command = ["hyprctl", "eval", "hl.config({ decoration = { screen_shader = " + luaArg + " } })"]
    applyProcess.running = true
  }

  // Restore shader state after Hyprland config reloads
  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (!event || !event.name) return
      var name = String(event.name)
      if (name === "configreloaded" || name === "config.reloaded") {
        if (root.enabled) {
          root.applyGrayscale(true)
        }
      }
    }
  }

  Process {
    id: statusProbe
    command: ["hyprctl", "getoption", "decoration:screen_shader"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var str = text || ""
        var isShaderActive = str.indexOf("grayscale.frag") !== -1
        root.enabled = isShaderActive
        root.stateLoaded = true
      }
    }
  }

  Process {
    id: applyProcess
    onExited: function() {
      if (root.hasPendingState) {
        root.hasPendingState = false
        root.runApply(root.pendingState)
        return
      }
      root.refresh()
      // Broadcast refresh to indicators so UI updates immediately
      broadcastIndicatorsRefresh.running = true
    }
  }

  Process {
    id: broadcastIndicatorsRefresh
    command: ["omarchy-shell", "-q", "omarchy.indicators", "refresh"]
  }

  Component.onCompleted: refresh()

  IpcHandler {
    target: "greyscale"

    function status(): string {
      return JSON.stringify({ enabled: root.enabled })
    }

    function refresh(): void {
      root.refresh()
    }

    function enable(): string {
      root.setGrayscale(true)
      return "enabled"
    }

    function disable(): string {
      root.setGrayscale(false)
      return "disabled"
    }

    function toggle(): string {
      var nextState = !root.enabled
      root.setGrayscale(nextState)
      return nextState ? "enabled" : "disabled"
    }
  }
}
