--- @class Kicker : Component
--- @field distance integer
--- @overload fun(distance: integer)
local Kicker = prism.Component:extend "Kicker"

--- @param distance integer
function Kicker:__new(distance)
   self.distance = distance
end

return Kicker
