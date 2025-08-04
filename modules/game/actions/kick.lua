local KickTarget = prism.Target():with(prism.components.Collider):range(1):sensed()
local Log = prism.components.Log
local Name = prism.components.Name
local sf = string.format

---@class KickAction : Action
local Kick = prism.Action:extend("KickAction")
Kick.name = "Kick"
Kick.targets = { KickTarget }
Kick.requiredComponents = {
   prism.components.Controller,
}

function Kick:canPerform(level)
   return true
end

local mask = prism.Collision.createBitmaskFromMovetypes { "fly" }

--- @param level Level
--- @param kicked Actor
function Kick:perform(level, kicked)
   local direction = (kicked:getPosition() - self.owner:getPosition())

   for _ = 1, 3 do
      local nextpos = kicked:getPosition() + direction
      if not level:getCellPassable(nextpos.x, nextpos.y, mask) then break end
      if not level:hasActor(kicked) then break end
      level:moveActor(kicked, nextpos)
   end

   local damage = prism.actions.Damage(kicked, 1)
   if level:canPerform(damage) then
      level:perform(damage)
      local kickName = Name.lower(kicked)
      local ownerName = Name.lower(self.owner)
      Log.addMessage(self.owner, sf("You kick the %s.", kickName))
      Log.addMessage(kicked, sf("The %s kicks you!", ownerName))
      Log.addMessageSensed(level, self, sf("The %s kicks the %s.", ownerName, kickName))
   end
end

return Kick
