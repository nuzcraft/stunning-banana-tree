--- @class Stomper : Component
--- @field bonusDamage integer
--- @field aoeRadius integer
--- @field aoeDamage integer
--- @overload fun(bonusDamage: integer, aoeRadius: integer, aoeDamage: integer)
local Stomper = prism.Component:extend "Stomper"

--- @param bonusDamage integer
--- @param aoeRadius integer
--- @param aoeDamage integer
function Stomper:__new(bonusDamage, aoeRadius, aoeDamage)
   self.bonusDamage = bonusDamage
   self.aoeRadius = aoeRadius
   self.aoeDamage = aoeDamage
end

return Stomper
