--- @class TickSystem : System
local TickSystem = prism.System:extend "TickSystem"

--- @param level Level
--- @param actor Actor
function TickSystem:onTurn(level, actor)
   local tick = prism.actions.Tick(actor)
   if level:canPerform(tick) then level:perform(tick) end
end

return TickSystem
