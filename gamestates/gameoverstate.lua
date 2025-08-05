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
   self.display:putString(1, midpoint, "Game over!", nil, nil, nil, "center", self.display.width)
   self.display:draw()
end

return GameOverState
