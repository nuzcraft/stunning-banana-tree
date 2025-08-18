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
