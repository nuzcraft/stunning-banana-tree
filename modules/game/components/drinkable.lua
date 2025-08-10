--- @class DrinkableOptions
--- @field healing integer?
--- @field status StatusEffectsInstance?

--- @class Drinkable : Component
--- @field healing integer?
--- @field status StatusEffectsInstance?
--- @overload fun(options: DrinkableOptions): Drinkable
local Drinkable = prism.Component:extend "Drinkable"

function Drinkable:__new(options)
   self.healing = options.healing
   self.status = options.status
end

return Drinkable
