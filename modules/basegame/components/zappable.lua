--- @class ZappableOptions
--- @field charges integer
--- @field cost integer

--- @class Zappable : Component
--- @overload fun(): Zappable
local Zappable = prism.Component:extend "Zappable"

function Zappable:__new(options)
   self.charges = options.charges
   self.cost = options.cost
end

function Zappable:canZap(cost)
   cost = cost or self.cost
   return self.charges >= cost
end

function Zappable:reduceCharges(cost)
   cost = cost or self.cost
   self.charges = self.charges - self.cost
end

return Zappable
