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
   prism.components.Kicker,
   prism.components.Attacker,
}

function Kick:canPerform(level)
   return true
end

local mask = prism.Collision.createBitmaskFromMovetypes { "fly" }

--- @param level Level
--- @param kicked Actor
function Kick:perform(level, kicked)
   local direction = (kicked:getPosition() - self.owner:getPosition())
   local distance = self.owner:get(prism.components.Kicker).distance
   local knockback
   KnockbackAction = nil
   for _ = 1, distance do
      local nextpos = kicked:getPosition() + direction
      local target = level:query():at(nextpos:decompose()):first()
      knockback = prism.actions.Knockback(kicked, target)
      if not level:getCellPassable(nextpos.x, nextpos.y, mask) then break end
      if not level:hasActor(kicked) then break end
      level:moveActor(kicked, nextpos)
   end

   local damageamount = self.owner:get(prism.components.Attacker).damage
   local damage = prism.actions.Damage(kicked, damageamount)
   if level:canPerform(damage) then
      level:perform(damage)

      local dmgstr = ""
      if damage.dealt then dmgstr = sf("Dealing %i damage.", damage.dealt) end

      local kickName = Name.lower(kicked)
      local ownerName = Name.lower(self.owner)
      Log.addMessage(self.owner, sf("You kick the %s. %s", kickName, dmgstr))
      Log.addMessage(kicked, sf("The %s kicks you! %s", ownerName, dmgstr))
      Log.addMessageSensed(level, self, sf("The %s kicks the %s. %s", ownerName, kickName, dmgstr))
   end

   local openContainer = prism.actions.OpenContainer(self.owner, kicked)
   if level:canPerform(openContainer) then
      local kickName = Name.lower(kicked)
      local ownerName = Name.lower(self.owner)
      Log.addMessage(self.owner, sf("You kick the %s.", kickName))
      Log.addMessage(kicked, sf("The %s kicks you!", ownerName))
      Log.addMessageSensed(level, self, sf("The %s kicks the %s.", ownerName, kickName))
      level:perform(openContainer)
   end

   if level:canPerform(knockback) then level:perform(knockback) end
end

return Kick
