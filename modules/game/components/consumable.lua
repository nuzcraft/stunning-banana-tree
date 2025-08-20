--- @class ConsumableOptions
--- @field healing integer?
--- @field status StatusEffectsInstance?

--- @class Consumable : Component
--- @field healing integer?
--- @field status StatusEffectsInstance?
--- @overload fun(options: ConsumableOptions): Consumable
local Consumable = prism.Component:extend "Consumable"

function Consumable:__new(options)
   self.healing = options.healing
   self.status = options.status
end

return Consumable
