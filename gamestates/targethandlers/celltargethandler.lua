local keybindings = require "keybindingschema"
local Name = prism.components.Name
local TargetHandler = require "gamestates.targethandlers.targethandler"

--- @class CellTargetHandler : TargetHandler
--- @field selectorPosition Vector2
local CellTargetHandler = TargetHandler:extend "CellTargetHandler"

function CellTargetHandler:getValidTargets()
   local valid = {}
   for i = 1, #self.targetList, 1 do
      local actingaction = self.action(self.levelState.decision.actor, self.targetList[i])
      if self.levelState.level:canPerform(actingaction) then table.insert(valid, self.targetList[i]) end
   end
   return valid
end

function CellTargetHandler:setSelectorPosition()
   self.selectorPosition = self.curTarget
end

function CellTargetHandler:init()
   self.action = self.target -- repurpose target for action
   TargetHandler.init(self)
   self.curTarget = self.validTargets[1]
   self:setSelectorPosition()
end

function CellTargetHandler:draw()
   local cameraPos = self.selectorPosition
   self.display:clear()
   local ox, oy = self.display:getCenterOffset(cameraPos:decompose())
   self.display:setCamera(ox, oy)

   local primary, secondary = self.levelState:getSenses()
   self.display:putSenses(primary, secondary)

   self.display:putString(1, 2, "Select a target!", WHITE, DARKGRAY)
   self.display:putString(self.selectorPosition.x + ox, self.selectorPosition.y + oy, "X", RED)
   self.display:draw()
end

local keybindOffsets = {
   ["move up"] = prism.Vector2.UP,
   ["move left"] = prism.Vector2.LEFT,
   ["move down"] = prism.Vector2.DOWN,
   ["move right"] = prism.Vector2.RIGHT,
   ["move up-left"] = prism.Vector2.UP_LEFT,
   ["move up-right"] = prism.Vector2.UP_RIGHT,
   ["move down-left"] = prism.Vector2.DOWN_LEFT,
   ["move down-right"] = prism.Vector2.DOWN_RIGHT,
}

function CellTargetHandler:keypressed(key)
   local action = keybindings:keypressed(key)
   if action == "inventory" then -- tab key
      local lastTarget = self.curTarget
      self.index, self.curTarget = next(self.validTargets, self.index)
      while (not self.index and #self.validTargets > 0) or (lastTarget == self.curTarget and #self.validTargets > 1) do
         self.index, self.curTarget = next(self.validTargets, self.index)
      end
      self:setSelectorPosition()
   end
   if action == "return" then self.manager:pop() end
   if action == "select" then
      local actingaction = self.action(self.levelState.decision.actor, self.curTarget)
      if self.levelState.level:canPerform(actingaction) then
         self.levelState.decision:setAction(actingaction)
         self.manager:pop()
      end
   end
   --    if keybindOffsets[action] then self.selectorPosition = self.selectorPosition + keybindOffsets[action] end
end

return CellTargetHandler
