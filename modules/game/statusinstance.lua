--- @class GameStatusInstance : StatusEffectsInstance
--- @field duration integer?
local GameStatusInstance = prism.components.StatusEffectsInstance:extend "GameStatusInstance"

--- @class GameStatusInstanceOptions : StatusEffectsInstanceOptions
--- @field duration integer

--- @param options GameStatusInstanceOptions
function GameStatusInstance:__new(options)
   prism.components.StatusEffectsInstance.__new(self, options)
   self.duration = options.duration or nil
end

return GameStatusInstance
