--- @class Sturdy : Component
--- @field knockbackResist integer
--- @overload fun(knockbackResist: integer)
local Sturdy = prism.Component:extend("Sturdy")

--- @param knockbackResist integer
function Sturdy:__new(knockbackResist)
   self.knockbackResist = knockbackResist
end

return Sturdy
