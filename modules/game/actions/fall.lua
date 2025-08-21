local Name = prism.components.Name

--- @class Fall : Action
--- @overload fun(owner: Actor): Fall
local Fall = prism.Action:extend "Fall"

function Fall:perform(level)
   if Name.get(self.owner) == "Kobold" then Game.stats.koboldsPitted = Game.stats.koboldsPitted + 1 end
   level:perform(prism.actions.Die(self.owner))
end

--- @param level Level
function Fall:canPerform(level)
   local x, y = self.owner:getPosition():decompose()
   local cell = level:getCell(x, y)

   if not cell:has(prism.components.Void) then return false end

   local cellMask = cell:getCollisionMask()
   local mover = self.owner:get(prism.components.Mover)
   local mask = mover and mover.mask or 0

   return not prism.Collision.checkBitmaskOverlap(cellMask, mask)
end

return Fall
