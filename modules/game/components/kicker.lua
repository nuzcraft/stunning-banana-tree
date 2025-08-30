--- @class Kicker : Component
--- @field distance integer
--- @field bonusDamage integer
--- @overload fun(distance: integer, bonusDamage: integer)
local Kicker = prism.Component:extend "Kicker"

--- @param distance integer
--- @param bonusDamage integer
function Kicker:__new(distance, bonusDamage)
   self.distance = distance
   self.bonusDamage = bonusDamage
end

return Kicker
