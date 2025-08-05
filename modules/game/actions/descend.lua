local DescendTarget = prism.Target():with(prism.components.Stair):range(1)

--- @class Descend : Action
--- @overload fun(owner: Actor): Descend
local Descend = prism.Action:extend "Descend"
Descend.targets = { DescendTarget }

function Descend:perform(level)
   level:removeActor(self.owner)
   level:yield(prism.messages.Descend())
end

return Descend
