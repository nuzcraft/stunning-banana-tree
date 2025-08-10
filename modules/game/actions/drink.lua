local DrinkTarget = prism.InventoryTarget():inInventory():with(prism.components.Drinkable)

--- @class Drink : Action
local Drink = prism.Action:extend "Drink"
Drink.targets = {
   DrinkTarget,
}

--- @param level Level
function Drink:perform(level, drink)
   local drinkable = drink:expect(prism.components.Drinkable)
   local statusComponent = self.owner:get(prism.componets.StatusEffects)
   if statusComponent and drinkable.status then statusComponent:add(drinkable.status) end

   local health = self.owner:get(prism.components.Health)
   if health and drinkable.healing then health:heal(drinkable.healing) end
end

return Drink
