--- @class TargetHandler : GameState
--- @field display Display
--- @field levelState LevelState
--- @field validTargets any
--- @field curTarget any
--- @field target Target
--- @field level Level
--- @field targetList any[]
--- @overload fun(display: Display, levelState: LevelState, targetList: any[], target: Target) : self
local TargetHandler = spectrum.GameState:extend "TargetHandler"

--- @param display Display
--- @param levelState LevelState
--- @param targetList any[]
--- @param target Target
function TargetHandler:__new(display, levelState, targetList, target)
   self.display = display
   self.levelState = levelState
   self.owner = self.levelState.decision.actor
   self.level = self.levelState.level
   self.targetList = targetList
   self.target = target
   self.index = nil
end

function TargetHandler:getValidTargets()
   error("Method 'getValidTargets' must be implemented in subclass")
end

function TargetHandler:init()
   self.validTargets = self:getValidTargets()
   if #self.validTargets == 0 then self.manager:pop("poprecursive") end
end

function TargetHandler:resume(previous, shouldPop)
   if shouldPop == "poprecursive" then
      self.manager:pop("poprecursive")
      return
   end
   if shouldPop then
      self.manager:pop()
      return
   end
   self:init()
end

function TargetHandler:load()
   self:init()
end

return TargetHandler
