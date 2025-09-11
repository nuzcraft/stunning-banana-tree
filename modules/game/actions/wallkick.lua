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

local mask = prism.Collision.createBitmaskFromMovetypes { "walk" }

--- @param level Level
--- @param targetVec Vector2
function WallKick:canPerform(level, targetVec)
   local x, y = targetVec:decompose()
   if level:inBounds(x, y) then
      local targetCell = level:getCell(targetVec:decompose())
      if
         targetCell:has(prism.components.Collider)
         and targetCell:has(prism.components.Destructible)
         and not level:getCellPassable(x, y, mask)
         and not level:query():at(targetVec:decompose()):first() -- no actor at pos
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
   Log.addMessage(self.owner, "You kick the wall. It crumbles.")
   Log.addMessageSensed(level, self, sf("The %s kicks the wall. It crumbles.", Name.lower(self.owner)))
end

return WallKick
