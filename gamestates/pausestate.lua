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
   self.display:clear()
   self.display:putString(0, 4, "Paused", nil, nil, 2, "center")

   self.display:draw()
end

function PauseState:keypressed(key)
   local binding = keybindings:keypressed(key)
   if binding == "pause" then self.manager:pop() end
end

return PauseState
