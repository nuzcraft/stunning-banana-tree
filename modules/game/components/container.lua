--- @class Container : Component
--- @overload fun(): Container
local Container = prism.Component:extend "Container"

function Container:getRequirements()
   return prism.components.Inventory
end

return Container
