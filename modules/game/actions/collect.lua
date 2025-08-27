local Log = prism.components.Log

local CollectTarget = prism.Target():with(prism.components.XP):range(1)

--- @class Collect : Action
--- @overload fun(owner: Actor, xp: Actor): Descend
local Collect = prism.Action:extend "Collect"
Collect.targets = { CollectTarget }

function Collect:perform(level, xp)
   level:removeActor(xp)
   if self.owner:has(prism.components.PlayerController) then
      Game.xp = Game.xp + 1
      Game.stats.xpCollected = Game.stats.xpCollected + 1
      if Game.xp >= Game.levelThreshold then
         Game.xp = Game.xp - Game.levelThreshold
         Game.level = Game.level + 1
         Game:setLevelThreshold(Game.level)
         Log.addMessage(self.owner, "Level Up! You gained a skill point.")
      end
   end
end

return Collect
