--- @class Stomper : Component
--- @field bonusDamage integer
--- @overload fun(bonusDamage: integer)
local Stomper = prism.Component:extend "Stomper"

--- @param bonusDamage integer
function Stomper:__new(bonusDamage)
   self.bonusDamage = bonusDamage
end

return Stomper
