local keybindings = require "keybindingschema"

--- @class GameOverState : GameState
--- @field display Display
--- @overload fun(display: Display): GameOverState
local GameOverState = spectrum.GameState:extend("GameOverState")

function GameOverState:__new(display)
   self.display = display
end

function GameOverState:draw()
   local midpoint = math.floor(self.display.height / 2)
   self.display:clear()
   self.display:putString(1, midpoint - 3, "Game over!", WHITE, nil, nil, "center", self.display.width)
   self.display:putString(
      1,
      midpoint - 1,
      "Survived for " .. Game.turns .. " turns",
      DARKGRAY,
      nil,
      nil,
      "center",
      self.display.width
   )
   self.display:putString(1, midpoint, "Died on depth " .. Game.depth, DARKGRAY, nil, nil, "center", self.display.width)
   self.display:putString(1, midpoint + 3, "[r] to restart", WHITE, nil, nil, "center", self.display.width)
   self.display:putString(1, midpoint + 4, "[q] to quit", DARKGRAY, nil, nil, "center", self.display.width)

   -- run stats
   self.display:putString(
      0,
      midpoint - 4,
      "Number of Kicks: " .. Game.stats.numKicks,
      DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint - 3,
      "Number of Stomps: " .. Game.stats.numStomps,
      DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint - 2,
      "Kobolds Killed: " .. Game.stats.koboldsKilled,
      DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint - 1,
      "Kobolds Pitted: " .. Game.stats.koboldsPitted,
      DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint,
      "Health Healed: " .. Game.stats.healthHealed,
      DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint + 1,
      "Chests Opened: " .. Game.stats.chestsOpened,
      DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint + 2,
      "Damage Done: " .. Game.stats.damageDone,
      DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint + 3,
      "Damage Taken: " .. Game.stats.damageTaken,
      DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint + 4,
      "XP Collected: " .. Game.stats.xpCollected,
      DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:draw()
end

function GameOverState:keypressed(key, scancode, isrepeat)
   local action = keybindings:keypressed(key, "game-over")
   if action == "restart" then
      love.event.restart()
   elseif action == "quit" then
      love.event.quit()
   end
end

return GameOverState
