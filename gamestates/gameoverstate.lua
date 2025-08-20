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
