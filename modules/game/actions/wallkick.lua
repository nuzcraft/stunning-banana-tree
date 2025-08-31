local WallKickTarget = prism.Target():isPrototype(prism.Vector2):range(1)
local Log = prism.components.Log
local Name = prism.components.Name
local sf = string.format

--- @class WallKick : Action
--- @overload fun(owner: Actor, targetVec: Vector2): WallKick
local WallKick = prism.Action:extend("WallKick")
WallKick.name = "WallKick"
WallKick.targets = { WallKickTarget }
WallKick.requiredComponents = { prism.components.WallKicker }

--- @param level Level
--- @param targetVec Vector2
function WallKick:canPerform(level, targetVec)
   local x, y = targetVec:decompose()
   if level:inBounds(x, y) then
      local targetCell = level:getCell(targetVec:decompose())
      if
         targetCell:has(prism.components.Collider)
         and targetCell:has(prism.components.Opaque)
         and not targetCell:has(prism.components.Unbreakable)
      then
         return true
      end
   end
   return false
end

--- @param level Level
--- @param targetVec Vector2
function WallKick:perform(level, targetVec)
   -- local WallKicker = self.owner:expect(prism.components.WallKicker)
   local x, y = targetVec:decompose()
   level:setCell(x, y, prism.cells.Floor())

   -- local damage = prism.actions.Damage(attacked, attacker.damage)
   -- if level:canPerform(damage) then
   --    level:perform(damage)
   --    local dmgstr = ""
   --    if damage.dealt then dmgstr = sf("Dealing %i damage.", damage.dealt) end
   --    local attackName = Name.lower(attacked)
   --    local ownerName = Name.lower(self.owner)
   --    Log.addMessage(self.owner, sf("You attack the %s. %s", attackName, dmgstr))
   --    Log.addMessage(attacked, sf("The %s attacks you! %s", ownerName, dmgstr))
   --    Log.addMessageSensed(level, self, sf("The %s attacks the %s. %s", ownerName, attackName, dmgstr))
   -- end
end

return WallKick
