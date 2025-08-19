local keybindings = require "keybindingschema"

--- @class TitleState : GameState
--- @field display Display
--- @overload fun(display: Display): TitleState
local TitleState = spectrum.GameState:extend "TitleState"

function TitleState:__new(display)
   self.display = display
end

function TitleState:draw()
   local midpoint = math.floor(self.display.height / 2)
   self.display:clear()
   self.display:putString(1, midpoint, "Game over!", nil, nil, nil, "center", self.display.width)
   self.display:putString(1, midpoint + 3, "[r] to restart", nil, nil, nil, "center", self.display.width)
   self.display:putString(1, midpoint + 4, "[q] to quit", nil, nil, nil, "center", self.display.width)
   self.display:draw()
end

function TitleState:keypressed(key, scancode, isrepeat)
   local action = keybindings:keypressed(key, "title")
   if action == "restart" then
      love.event.restart()
   elseif action == "quit" then
      love.event.quit()
   end
end

return TitleState
