--- @class KoboldController
--- @overload fun(): KoboldController
local KoboldController = prism.components.Controller:extend("KoboldController")
KoboldController.name = "KoboldController"

function KoboldController:act(level, actor)
   local destination = actor:getPosition() + prism.Vector2.RIGHT
   local move = prism.actions.Move(actor, destination)
   if level:canPerform(move) then return move end
   return prism.actions.Wait(actor)
end

return KoboldController
