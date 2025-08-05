local AttackTarget = prism.Target():isPrototype(prism.Actor):with(prism.components.Health)
local Log = prism.components.Log
local Name = prism.components.Name
local sf = string.format

--- @class Attack : Action
--- @overload fun(owner: Actor, attacked: Actor): Attack
local Attack = prism.Action:extend("Attack")
Attack.name = "Attack"
Attack.targets = { AttackTarget }
Attack.requiredComponents = { prism.components.Attacker }

--- @param level Level
--- @param attacked Actor
function Attack:perform(level, attacked)
   local attacker = self.owner:expect(prism.components.Attacker)

   local damage = prism.actions.Damage(attacked, attacker.damage)
   if level:canPerform(damage) then
      level:perform(damage)
      local dmgstr = ""
      if damage.dealt then dmgstr = sf("Dealing %i damage.", damage.dealt) end
      local attackName = Name.lower(attacked)
      local ownerName = Name.lower(self.owner)
      Log.addMessage(self.owner, sf("You attack the %s. %s", attackName, dmgstr))
      Log.addMessage(attacked, sf("The %s attacks you! %s", ownerName, dmgstr))
      Log.addMessageSensed(level, self, sf("The %s attacks the %s. %s", ownerName, attackName, dmgstr))
   end
end

return Attack
