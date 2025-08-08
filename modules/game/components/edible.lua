--- @class Edible : Component
--- @field healing integer
--- @overload fun(healing: integer) : Edible
local Edible = prism.Component:extend("Edible")

--- @param healing integer
function Edible:__new(healing)
   self.healing = healing
end

return Edible
