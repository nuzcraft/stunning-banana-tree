local AttackTarget = prism.Target():isPrototype(prism.Actor):with(prism.components.Health)

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
   if level:canPerform(damage) then level:perform(damage) end
end

return Attack
