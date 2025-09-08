local json = require "prism.engine.lib.json"
local prefData = love.filesystem.read("preferences.json")
local preferences = json.decode(prefData)

local keys = preferences.keybindings

return spectrum.Keybinding {
   -- numpad
   { key = keys.move_up_2 or "kp8", action = "move up", description = "Moves the character upward." },
   { key = keys.move_left_2, action = "move left", description = "Moves the character left." },
   { key = keys.move_down_2, action = "move down", description = "Moves the character downward." },
   { key = keys.move_right_2, action = "move right", description = "Moves the character right." },
   { key = keys.move_up_left_2, action = "move up-left", description = "Moves the character diagonally up-left." },
   { key = keys.move_up_right_2, action = "move up-right", description = "Moves the character diagonally up-right." },
   {
      key = keys.move_down_left_2,
      action = "move down-left",
      description = "Moves the character diagonally down-left.",
   },
   {
      key = keys.move_down_right_2,
      action = "move down-right",
      description = "Moves the character diagonally down-right.",
   },
   { key = keys.wait_2, action = "wait", description = "Character waits and does nothing." },
   -- arrows
   { key = keys.move_up, action = "move up", description = "Moves the character upward." },
   { key = keys.move_left, action = "move left", description = "Moves the character left." },
   { key = keys.move_down, action = "move down", description = "Moves the character downward." },
   { key = keys.move_right, action = "move right", description = "Moves the character right." },
   {
      key = keys.move_up_left,
      mode = "shift",
      action = "move up-left",
      description = "Moves the character diagonally up-left.",
   },
   {
      key = keys.move_up_right,
      mode = "shift",
      action = "move up-right",
      description = "Moves the character diagonally up-right.",
   },
   {
      key = keys.move_down_left,
      mode = "control",
      action = "move down-left",
      description = "Moves the character diagonally down-left.",
   },
   {
      key = keys.move_down_right,
      mode = "control",
      action = "move down-right",
      description = "Moves the character diagonally down-right.",
   },
   { key = keys.wait, action = "wait", description = "Character waits and does nothing." },
   -- vi keys
   { key = keys.move_up_3, action = "move up", description = "Moves the character upward." },
   { key = keys.move_left_3, action = "move left", description = "Moves the character left." },
   { key = keys.move_down_3, action = "move down", description = "Moves the character downward." },
   { key = keys.move_right_3, action = "move right", description = "Moves the character right." },
   { key = keys.move_up_left_3, action = "move up-left", description = "Moves the character diagonally up-left." },
   { key = keys.move_up_right_3, action = "move up-right", description = "Moves the character diagonally up-right." },
   {
      key = keys.move_down_left_3,
      action = "move down-left",
      description = "Moves the character diagonally down-left.",
   },
   {
      key = keys.move_down_right_3,
      action = "move down-right",
      description = "Moves the character diagonally down-right.",
   },

   { key = keys.restart, mode = "game-over", action = "restart", description = "Restarts the game." },
   { key = keys.quit, mode = "game-over", action = "quit", description = "Quits the game." },
   { key = keys.switch_mode, action = "switch-kickmode", description = "Switches the kick mode." },
   { key = keys.targeting, action = "targeting", description = "Enters targeting mode." },

   -- { key = "tab", action = "inventory", description = "Opens the inventory screen." },
   -- { key = "backspace", action = "return", description = "Moves back up a level in a substate." },
   -- { key = "p", action = "pickup", description = "Picks up an inventory item." },
   -- { key = "space", action = "select", description = "Selects a target." },
   { key = keys.quit_title, mode = "title", action = "quit", description = "Quits the game." },

   { key = keys.pause, action = "pause", description = "Pauses and unpauses the game." },
   { key = keys.pause_2, action = "pause", description = "Pauses and unpauses the game." },
   { key = keys.pause_3, mode = "shift", action = "pause", description = "Pauses and unpauses the game." },

   { key = keys.move_up_2 or "kp8", mode = "paused", action = "move up", description = "Moves the selection upward." },
   { key = keys.move_left_2, mode = "paused", action = "move left", description = "Moves the selection left." },
   { key = keys.move_down_2, mode = "paused", action = "move down", description = "Moves the selection downward." },
   { key = keys.move_right_2, mode = "paused", action = "move right", description = "Moves the selection right." },
   { key = keys.move_up, mode = "paused", action = "move up", description = "Moves the selection upward." },
   { key = keys.move_left, mode = "paused", action = "move left", description = "Moves the selection left." },
   { key = keys.move_down, mode = "paused", action = "move down", description = "Moves the selection downward." },
   { key = keys.move_right, mode = "paused", action = "move right", description = "Moves the selection right." },
   { key = keys.move_up_3, mode = "paused", action = "move up", description = "Moves the selection upward." },
   { key = keys.move_left_3, mode = "paused", action = "move left", description = "Moves the selection left." },
   { key = keys.move_down_3, mode = "paused", action = "move down", description = "Moves the selection downward." },
   { key = keys.move_right_3, mode = "paused", action = "move right", description = "Moves the selection right." },
   { key = keys.restart, mode = "paused", action = "restart", description = "Restarts the game." },
   { key = keys.quit, mode = "paused", action = "quit", description = "Quits the game." },

   { key = keys.exit_targeting, mode = "targeting", action = "return", description = "Exits targeting screen" },
   { key = keys.select_target, mode = "targeting", action = "select", description = "Selects a target." },
   { key = keys.select_target_2, mode = "targeting", action = "select", description = "Selects a target." },
   { key = keys.cycle, mode = "targeting", action = "cycle", description = "Cycles through targets." },
   {
      key = keys.cycle_backward,
      mode = "shift-targeting",
      action = "cycle-backward",
      description = "Cycles through targets backwards.",
   },
}
