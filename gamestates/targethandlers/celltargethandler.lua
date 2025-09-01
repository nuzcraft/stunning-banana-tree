local keybindings = require "keybindingschema"
local Name = prism.components.Name
local TargetHandler = require "gamestates.targethandlers.targethandler"

--- @class CellTargetHandler : TargetHandler
--- @field selectorPosition Vector2
local CellTargetHandler = TargetHandler:extend "CellTargetHandler"

function CellTargetHandler:getValidTargets()
   return self.targetList
end

function CellTargetHandler:draw()
   self.display:putString(1, 5, "Select a target!", WHITE, DARKGRAY)
   self.display:draw()
end

function CellTargetHandler:keypressed(key)
   local action = keybindings:keypressed(key)
   if action == "return" then self.manager:pop() end
end

return CellTargetHandler
