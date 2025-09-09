local json = require "prism.engine.lib.json"
local prefData
if love.filesystem.getInfo("preferences.json") then
   prefData = love.filesystem.read("preferences.json")
else
   local file = io.open("preferences.json", "r")
   if file then
      prefData = file:read("*a")
      file:close()
   end
end
local preferences = json.decode(prefData)

local keys = preferences.keybindings

return spectrum.Keybinding {
   -- numpad
   { key = keys.move_up_2 or "kp8", action = "move up", description = "Moves the character upward." },
   { key = keys.move_left_2 or "kp4", action = "move left", description = "Moves the character left." },
   { key = keys.move_down_2 or "kp2", action = "move down", description = "Moves the character downward." },
   { key = keys.move_right_2 or "kp6", action = "move right", description = "Moves the character right." },
   {
      key = keys.move_up_left_2 or "kp7",
      action = "move up-left",
      description = "Moves the character diagonally up-left.",
   },
   {
      key = keys.move_up_right_2 or "kp9",
      action = "move up-right",
      description = "Moves the character diagonally up-right.",
   },
   {
      key = keys.move_down_left_2 or "kp1",
      action = "move down-left",
      description = "Moves the character diagonally down-left.",
   },
   {
      key = keys.move_down_right_2 or "kp3",
      action = "move down-right",
      description = "Moves the character diagonally down-right.",
   },
   { key = keys.wait_2 or "kp5", action = "wait", description = "Character waits and does nothing." },
   -- arrows
   { key = keys.move_up or "up", action = "move up", description = "Moves the character upward." },
   { key = keys.move_left or "left", action = "move left", description = "Moves the character left." },
   { key = keys.move_down or "down", action = "move down", description = "Moves the character downward." },
   { key = keys.move_right or "right", action = "move right", description = "Moves the character right." },
   {
      key = keys.move_up_left or "left",
      mode = "shift",
      action = "move up-left",
      description = "Moves the character diagonally up-left.",
   },
   {
      key = keys.move_up_right or "right",
      mode = "shift",
      action = "move up-right",
      description = "Moves the character diagonally up-right.",
   },
   {
      key = keys.move_down_left or "left",
      mode = "control",
      action = "move down-left",
      description = "Moves the character diagonally down-left.",
   },
   {
      key = keys.move_down_right or "right",
      mode = "control",
      action = "move down-right",
      description = "Moves the character diagonally down-right.",
   },
   { key = keys.wait or ".", action = "wait", description = "Character waits and does nothing." },
   -- vi keys
   { key = keys.move_up_3 or "k", action = "move up", description = "Moves the character upward." },
   { key = keys.move_left_3 or "h", action = "move left", description = "Moves the character left." },
   { key = keys.move_down_3 or "j", action = "move down", description = "Moves the character downward." },
   { key = keys.move_right_3 or "l", action = "move right", description = "Moves the character right." },
   {
      key = keys.move_up_left_3 or "y",
      action = "move up-left",
      description = "Moves the character diagonally up-left.",
   },
   {
      key = keys.move_up_right_3 or "u",
      action = "move up-right",
      description = "Moves the character diagonally up-right.",
   },
   {
      key = keys.move_down_left_3 or "b",
      action = "move down-left",
      description = "Moves the character diagonally down-left.",
   },
   {
      key = keys.move_down_right_3 or "n",
      action = "move down-right",
      description = "Moves the character diagonally down-right.",
   },

   { key = keys.restart or "r", mode = "game-over", action = "restart", description = "Restarts the game." },
   { key = keys.quit or "q", mode = "game-over", action = "quit", description = "Quits the game." },
   { key = keys.switch_mode or "space", action = "switch-kickmode", description = "Switches the kick mode." },
   { key = keys.targeting or "f", action = "targeting", description = "Enters targeting mode." },

   -- { key = "tab", action = "inventory", description = "Opens the inventory screen." },
   -- { key = "backspace", action = "return", description = "Moves back up a level in a substate." },
   -- { key = "p", action = "pickup", description = "Picks up an inventory item." },
   -- { key = "space", action = "select", description = "Selects a target." },
   { key = keys.quit_title or "escape", mode = "title", action = "quit", description = "Quits the game." },

   { key = keys.pause or "escape", action = "pause", description = "Pauses and unpauses the game." },
   { key = keys.pause_2 or "f1", action = "pause", description = "Pauses and unpauses the game." },
   { key = keys.pause_3 or "/", mode = "shift", action = "pause", description = "Pauses and unpauses the game." },

   { key = keys.move_up_2 or "kp8", mode = "paused", action = "move up", description = "Moves the selection upward." },
   {
      key = keys.move_left_2 or "kp4",
      mode = "paused",
      action = "move left",
      description = "Moves the selection left.",
   },
   {
      key = keys.move_down_2 or "kp2",
      mode = "paused",
      action = "move down",
      description = "Moves the selection downward.",
   },
   {
      key = keys.move_right_2 or "kp6",
      mode = "paused",
      action = "move right",
      description = "Moves the selection right.",
   },
   { key = keys.move_up or "up", mode = "paused", action = "move up", description = "Moves the selection upward." },
   { key = keys.move_left or "left", mode = "paused", action = "move left", description = "Moves the selection left." },
   {
      key = keys.move_down or "down",
      mode = "paused",
      action = "move down",
      description = "Moves the selection downward.",
   },
   {
      key = keys.move_right or "right",
      mode = "paused",
      action = "move right",
      description = "Moves the selection right.",
   },
   { key = keys.move_up_3 or "k", mode = "paused", action = "move up", description = "Moves the selection upward." },
   { key = keys.move_left_3 or "h", mode = "paused", action = "move left", description = "Moves the selection left." },
   {
      key = keys.move_down_3 or "k",
      mode = "paused",
      action = "move down",
      description = "Moves the selection downward.",
   },
   {
      key = keys.move_right_3 or "l",
      mode = "paused",
      action = "move right",
      description = "Moves the selection right.",
   },
   { key = keys.restart or "r", mode = "paused", action = "restart", description = "Restarts the game." },
   { key = keys.quit or "q", mode = "paused", action = "quit", description = "Quits the game." },

   {
      key = keys.exit_targeting or "escape",
      mode = "targeting",
      action = "return",
      description = "Exits targeting screen",
   },
   { key = keys.select_target or "f", mode = "targeting", action = "select", description = "Selects a target." },
   { key = keys.select_target_2 or "spacd", mode = "targeting", action = "select", description = "Selects a target." },
   { key = keys.cycle or "tab", mode = "targeting", action = "cycle", description = "Cycles through targets." },
   {
      key = keys.cycle_backward or "tab",
      mode = "shift-targeting",
      action = "cycle-backward",
      description = "Cycles through targets backwards.",
   },
}
