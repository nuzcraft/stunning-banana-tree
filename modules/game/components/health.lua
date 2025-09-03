local StatusEffects = prism.components.StatusEffects
local Name = prism.components.Name

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
function Health:setMaxHP(amount)
   self.maxHP = amount
   if self.hp > amount then self.hp = amount end
end

--- @param amount integer
function Health:heal(amount)
   local amt = math.min(self.hp + amount, self:getMaxHP())
   if Name.get(self.owner) == "Player" then Game.stats.healthHealed = Game.stats.healthHealed + (amt - self.hp) end
   self.hp = amt
end

function Health:enforceBounds()
   self.hp = math.min(self.hp, self:getMaxHP())
end

Health.Modifier = HealthModifier

return Health
