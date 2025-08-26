local CollectTarget = prism.Target():with(prism.components.XP):range(1)

--- @class Collect : Action
--- @overload fun(owner: Actor, xp: Actor): Descend
local Collect = prism.Action:extend "Collect"
Collect.targets = { CollectTarget }

function Collect:perform(level, xp)
   level:removeActor(xp)
   Game.xp = Game.xp + 1
   Game.stats.xpCollected = Game.stats.xpCollected + 1
end

return Collect
