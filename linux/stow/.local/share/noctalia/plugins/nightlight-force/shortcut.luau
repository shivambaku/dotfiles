local active = false

local function render()
  shortcut.setLabel(if active then "Night Light On" else "Night Light Off")
  shortcut.setIcon("nightlight-forced", "nightlight-off")
  shortcut.setActive(active)
  shortcut.setEnabled(true)
end

local function syncState()
  noctalia.runAsync("toggle-noctalia-nightlight status", function(result)
    if result.exitCode == 0 and not result.timedOut then
      active = string.find(result.stdout, "on", 1, true) ~= nil
      render()
    end
  end)
end

render()
syncState()

function onClick()
  noctalia.runAsync("toggle-noctalia-nightlight toggle", function(result)
    if result.exitCode == 0 and not result.timedOut then
      syncState()
    end
  end)
end

function onRightClick()
  onClick()
end
