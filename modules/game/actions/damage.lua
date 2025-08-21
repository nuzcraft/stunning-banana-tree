local DamageTarget = prism.Target():isType("number")
local Name = prism.components.Name

--- @class Damage : Action
--- @overload fun(owner: Actor, damage: number): Damage
local Damage = prism.Action:extend("Damage")
Damage.name = "Damage"
Damage.targets = { DamageTarget }
Damage.requiredComponents = { prism.components.Health }

function Damage:perform(level, damage)
   local health = self.owner:expect(prism.components.Health)
   health.hp = health.hp - damage
   self.dealt = damage
   self.fatal = false

   if Name.get(self.owner) ~= "Player" then
      Game.stats.damageDone = Game.stats.damageDone + damage
   elseif Name.get(self.owner) == "Player" then
      Game.stats.damageTaken = Game.stats.damageTaken + damage
   end

   if health.hp <= 0 then
      level:perform(prism.actions.Die(self.owner))
      self.fatal = true
   end
end

return Damage
