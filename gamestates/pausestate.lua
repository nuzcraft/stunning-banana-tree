local utf8 = require "utf8"
local keybindings = require "keybindingschema"

--- @class PauseState : GameState
--- @overload fun(display: Display, decision: ActionDecision, level: Level)
local PauseState = spectrum.GameState:extend "PauseState"

--- @param display Display
--- @param decision ActionDecision
--- @param level Level
function PauseState:__new(display, decision, level)
   self.display = display
   self.decision = decision
   self.level = level
end

function PauseState:load(previous)
   self.previousState = previous
end

function PauseState:draw()
   -- self.previousState:draw()
   local midpoint = math.floor(self.display.height / 2)
   self.display:clear()
   self.display:putString(1, midpoint - 4, "Options", nil, nil, 2, "center")
   self.display:putString(
      1,
      midpoint + 3,
      "[r] to restart",
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "center",
      self.display.width
   )
   self.display:putString(1, midpoint + 4, "[q] to quit", prism.Color4.DARKGRAY, nil, nil, "center", self.display.width)

   self.display:draw()
end

function PauseState:keypressed(key)
   local binding = keybindings:keypressed(key)
   if binding == "pause" then self.manager:pop() end
   local action = keybindings:keypressed(key, "paused")
   if action == "restart" then
      love.event.restart()
   elseif action == "quit" then
      love.event.quit()
   end
end

return PauseState
