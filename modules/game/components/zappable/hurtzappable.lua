--- @class HurtZappableOptions : ZappableOptions
--- @field damage integer

--- @class HurtZappable : Zappable
--- @overload fun(options: HurtZappableOptions) : HurtZappable
local HurtZappable = prism.components.Zappable:extend "HurtZappable"
