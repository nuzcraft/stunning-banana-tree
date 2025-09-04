--- @class XP: Component
--- @field amount integer
--- @overload fun(amount: integer)
local XP = prism.Component:extend("XP")

--- @param amount integer
function XP:__new(amount)
   self.amount = amount
end

return XP
