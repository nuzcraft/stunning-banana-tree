--- @class FallSystem : System
local FallSystem = prism.System:extend "FallSystem"

--- @param level Level
--- @param actor Actor
function FallSystem:onMove(level, actor)
   local fall = prism.actions.Fall(actor)
   if level:canPerform(fall) then level:perform(fall) end
end

return FallSystem
