local StatusEffects = prism.components.StatusEffects

--- @class HealthModifier : StatusEffectsModifier
--- @field maxHP integer
local HealthModifier = prism.components.StatusEffects.Modifier:extend "HealthModifier"

function HealthModifier:__new(delta)
   self.maxHP = delta
end

--- @class Health : Component
--- @field private maxHP integer
--- @field hp integer
local Health = prism.Component:extend("Health")

function Health:__new(maxHP)
   self.maxHP = maxHP
   self.hp = maxHP
end

--- @return integer maxHP
function Health:getMaxHP()
   local modifiers = StatusEffects.getActorModifiers(self.owner, HealthModifier)
   local modifiedMaxHP = self.maxHP
   for _, modifier in ipairs(modifiers) do
      modifiedMaxHP = modifiedMaxHP + modifier.maxHP
   end
   return modifiedMaxHP
end

--- @param amount integer
function Health:heal(amount)
   self.hp = math.min(self.hp + amount, self:getMaxHP())
end

function Health:enforceBounds()
   self.hp = math.min(self.hp, self:getMaxHP())
end

Health.Modifier = HealthModifier

return Health
