local KnockbackTarget = prism.Target():with(prism.components.Collider):range(1)
local Log = prism.components.Log
local Name = prism.components.Name
local sf = string.format

---@class KnockbackAction : Action
local Knockback = prism.Action:extend "KnockbackAction"
Knockback.name = "Knockback"
Knockback.targets = { KnockbackTarget }

function Knockback:canPerform(level)
   return true
end

local mask = prism.Collision.createBitmaskFromMovetypes { "fly" }

--- @param level Level
--- @param knockedback Actor
function Knockback:perform(level, knockedback)
   local direction = (knockedback:getPosition() - self.owner:getPosition())
   local knockback
   KnockbackAction = nil
   local kbstr = sf("You knock back the %s.", Name.lower(knockedback))
   local kbstr2 = sf("The %s knocks you back!", Name.lower(self.owner))
   local kbstr3 = sf("The %s knocks back the %s.", Name.lower(self.owner), Name.lower(knockedback))
   local dmgstr = ""
   local deadstr = ""
   local fallstr = ""
   for _ = 1, 2 do
      local nextpos = knockedback:getPosition() + direction
      local target = level:query():at(nextpos:decompose()):first()
      knockback = prism.actions.Knockback(knockedback, target)
      if not level:getCellPassable(nextpos.x, nextpos.y, mask) then break end
      if not level:hasActor(knockedback) then break end
      level:moveActor(knockedback, nextpos)
      if not level:hasActor(knockedback) then fallstr = " It falls into the pit." end
   end

   local damage = prism.actions.Damage(knockedback, 1)
   if level:canPerform(damage) then
      level:perform(damage)
      if damage.dealt then dmgstr = sf(" Dealing %i damage.", damage.dealt) end
      if damage.fatal then deadstr = " It died." end
   end

   Log.addMessage(self.owner, kbstr .. dmgstr .. deadstr .. fallstr)
   Log.addMessage(knockedback, kbstr2 .. dmgstr .. deadstr .. fallstr)
   Log.addMessageSensed(level, self, kbstr3 .. dmgstr .. deadstr .. fallstr)

   -- handle more knockbacks at the end
   if level:canPerform(knockback) then level:perform(knockback) end
end

return Knockback
