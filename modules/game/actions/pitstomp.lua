local PitStompTarget = prism.Target():isPrototype(prism.Vector2):range(1)
local Log = prism.components.Log
local Name = prism.components.Name
local sf = string.format

--- @class PitStomp : Action
--- @overload fun(owner: Actor, targetVec: Vector2): WallKick
local PitStomp = prism.Action:extend("PitStomp")
PitStomp.name = "PitStomp"
PitStomp.targets = { PitStompTarget }
PitStomp.requiredComponents = { prism.components.PitStomper }

local mask = prism.Collision.createBitmaskFromMovetypes { "walk" }

--- @param level Level
--- @param targetVec Vector2
function PitStomp:canPerform(level, targetVec)
   local x, y = targetVec:decompose()
   if level:inBounds(x, y) then
      local targetCell = level:getCell(targetVec:decompose())
      if
         targetCell:has(prism.components.Collider)
         and targetCell:has(prism.components.Destructible)
         and level:getCellPassable(x, y, mask)
      then
         return true
      end
   end
   return false
end

--- @param level Level
--- @param targetVec Vector2
function PitStomp:perform(level, targetVec)
   local x, y = targetVec:decompose()
   level:setCell(x, y, prism.cells.Pit())
   Log.addMessage(self.owner, "You stomp the floor. It crumbles.")
   Log.addMessageSensed(level, self, sf("The %s stomps the floor. It crumbles.", Name.lower(self.owner)))
end

return PitStomp
