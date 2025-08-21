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
   self.display:putString(1, midpoint - 3, "Game over!", nil, nil, nil, "center", self.display.width)
   self.display:putString(
      1,
      midpoint - 1,
      "Survived for " .. Game.turns .. " turns",
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "center",
      self.display.width
   )
   self.display:putString(
      1,
      midpoint,
      "Died on depth " .. Game.depth,
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "center",
      self.display.width
   )
   self.display:putString(1, midpoint + 3, "[r] to restart", nil, nil, nil, "center", self.display.width)
   self.display:putString(1, midpoint + 4, "[q] to quit", prism.Color4.DARKGRAY, nil, nil, "center", self.display.width)

   -- run stats
   self.display:putString(
      0,
      midpoint - 4,
      "Number of Kicks: " .. Game.stats.numKicks,
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint - 3,
      "Number of Stomps: " .. Game.stats.numStomps,
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint - 2,
      "Kobolds Killed: " .. Game.stats.koboldsKilled,
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint - 1,
      "Kobolds Pitted: " .. Game.stats.koboldsPitted,
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint,
      "Health Healed: " .. Game.stats.healthHealed,
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint + 1,
      "Chests Opened: " .. Game.stats.chestsOpened,
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint + 2,
      "Damage Done: " .. Game.stats.damageDone,
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "right",
      self.display.width
   )
   self.display:putString(
      0,
      midpoint + 3,
      "Damage Taken: " .. Game.stats.chestsOpened,
      prism.Color4.DARKGRAY,
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
