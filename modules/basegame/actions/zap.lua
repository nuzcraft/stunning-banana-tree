local log = prism.components.Log

local ZappableTarget = prism.InventoryTarget():inInventory():with(prism.components.Zappable)

--- @class Zap: Action
local Zap = prism.Action:extend "Zap"
Zap.name = "Zap"
Zap.abstract = true
Zap.targets = { ZappableTarget }
Zap.ZappableTarget = ZappableTarget

--- @param level Level
--- @param zappable Actor
function Zap:canPerform(level, zappable)
   return zappable:expect(prism.components.Zappable):canZap()
end

--- @param level Level
--- @param zappable Actor
function Zap:perform(level, zappable)
   local zappableComponent = zappable:expect(prism.components.Zappable):reduceCharges()
   Log.addMessage(self.owner, "You zap the wand!")
end

return Zap
