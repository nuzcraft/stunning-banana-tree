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
   local kickstr = sf("You kick the %s.", Name.lower(kicked))
   local kickstr2 = sf("The %s kicks you!", Name.lower(self.owner))
   local kickstr3 = sf("The %s kicks the %s.", Name.lower(self.owner), Name.lower(kicked))
   local dmgstr = ""
   local deadstr = ""
   local fallstr = ""
   for _ = 1, distance do
      local nextpos = kicked:getPosition() + direction
      local target = level:query():at(nextpos:decompose()):first()
      knockback = prism.actions.Knockback(kicked, target)
      if not level:getCellPassable(nextpos.x, nextpos.y, mask) then break end
      if not level:hasActor(kicked) then break end
      level:moveActor(kicked, nextpos)
      if not level:hasActor(kicked) then fallstr = " It falls into the pit." end
   end

   local damageamount = self.owner:get(prism.components.Attacker).damage
   local damage = prism.actions.Damage(kicked, damageamount)
   if level:canPerform(damage) then
      level:perform(damage)
      if damage.dealt then dmgstr = sf(" Dealing %i damage.", damage.dealt) end
      if damage.fatal then deadstr = " It died." end
   end

   Log.addMessage(self.owner, kickstr .. dmgstr .. deadstr .. fallstr)
   Log.addMessage(kicked, kickstr2 .. dmgstr .. deadstr .. fallstr)
   Log.addMessageSensed(level, self, kickstr3 .. dmgstr .. deadstr .. fallstr)

   local openContainer = prism.actions.OpenContainer(self.owner, kicked)
   if level:canPerform(openContainer) then level:perform(openContainer) end

   -- handle knockbacks at the end
   if level:canPerform(knockback) then level:perform(knockback) end
end

return Kick
