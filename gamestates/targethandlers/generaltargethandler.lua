local keybindings = require "keybindingschema"
local Name = prism.components.Name
local TargetHandler = require "gamestates.targethandlers.targethandler"

--- @class GeneralTargetHandler : TargetHandler
--- @field selectorPosition Vector2
local GeneralTargetHandler = TargetHandler:extend "GeneralTargetHandler"

function GeneralTargetHandler:getValidTargets()
   local valid = {}
   for foundTarget in self.level:query():target(self.target, self.level, self.owner, self.targetList):iter() do
      table.insert(valid, foundTarget)
   end
   if not (self.target.type and self.target.type ~= prism.Vector2) then
      for x, y in self.level.map:each() do
         local vec = prism.Vector2(x, y)
         if self.target:validate(self.level, self.owner, vec, self.targetList) then table.insert(valid, vec) end
      end
   end
   return valid
end

function GeneralTargetHandler:setSelectorPosition()
   if prism.Vector2.is(self.curTarget) then
      self.selectorPosition = self.curTarget
   elseif self.curTarget then
      self.selectorPosition = self.curTarget:getPosition()
   end
end

function GeneralTargetHandler:init()
   TargetHandler.init(self)
   self.curTarget = self.validTargets[1]
   self:setSelectorPosition()
end

function GeneralTargetHandler:draw()
   local cameraPos = self.selectorPosition
   self.display:clear()
   local ox, oy = self.display:getCenterOffset(cameraPos:decompose())
   self.display:setCamera(ox, oy)

   local primary, secondary = self.levelState:getSenses()
   self.display:putSenses(primary, secondary)

   self.display:putString(1, 1, "Select a target!")
   self.display:putString(self.selectorPosition.x + ox, self.selectorPosition.y + oy, "X", RED)

   if self.curTarget then
      local x, y = cameraPos:decompose()
      self.display:putString(x + ox + 1, y + oy, Name.get(self.curTarget))
   end
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

function GeneralTargetHandler:keypressed(key)
   local action = keybindings:keypressed(key)
   if action == "inventory" then -- tab key
      local lastTarget = self.curTarget
      self.index, self.curTarget = next(self.validTargets, self.index)
      while (not self.index and #self.validTargets > 0) or (lastTarget == self.curTarget and #self.validTargets > 1) do
         self.index, self.curTarget = next(self.validTargets, self.index)
      end
      self:setSelectorPosition()
   end
   if action == "select" and self.curTarget then
      table.insert(self.targetList, self.curTarget)
      self.manager:pop()
   end
   if action == "return" then self.manager:pop("pop") end
   if keybindOffsets[action] then
      self.selectorPosition = self.selectorPosition + keybindOffsets[action]
      self.curTarget = nil
      if self.target:validate(self.level, self.owner, self.selectorPosition, self.targetList) then
         self.curTarget = self.selectorPosition
      end
      -- stylua ignore
      local validTarget = self.level
         :query()
         :at(self.selectorPosition:decompose())
         :target(self.target, self.level, self.owner, self.targetList)
         :first()

      if validTarget then self.curTarget = validTarget end
   end
end

return GeneralTargetHandler
