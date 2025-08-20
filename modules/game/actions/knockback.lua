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
   for _ = 1, 2 do
      local nextpos = knockedback:getPosition() + direction
      local target = level:query():at(nextpos:decompose()):first()
      local knockback = prism.actions.Knockback(knockedback, target)
      if level:canPerform(knockback) then
         level:perform(knockback)
         level:moveActor(knockedback, nextpos)
         break
      end
      if not level:getCellPassable(nextpos.x, nextpos.y, mask) then break end
      if not level:hasActor(knockedback) then break end
      level:moveActor(knockedback, nextpos)
   end

   local damage = prism.actions.Damage(knockedback, 1)
   if level:canPerform(damage) then
      level:perform(damage)

      local dmgstr = ""
      if damage.dealt then dmgstr = sf("Dealing %i damage.", damage.dealt) end

      local knockedbackName = Name.lower(knockedback)
      local ownerName = Name.lower(self.owner)
      Log.addMessage(self.owner, sf("You knockback the %s. %s", knockedbackName, dmgstr))
      Log.addMessage(knockedback, sf("The %s knocks you back! %s", ownerName, dmgstr))
      Log.addMessageSensed(level, self, sf("The %s knocks back the %s. %s", ownerName, knockedbackName, dmgstr))
   end
end

return Knockback
