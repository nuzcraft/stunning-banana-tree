--- @class Die : Action
--- @overload fun(owner: Actor): Die
local Die = prism.Action:extend("Die")

function Die:perform(level)
   level:removeActor(self.owner)
end

return Die
