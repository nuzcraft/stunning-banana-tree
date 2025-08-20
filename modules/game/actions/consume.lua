local Log = prism.components.Log
local Name = prism.components.Name
local sf = string.format

local ConsumeTarget = prism.Target():with(prism.components.Consumable):sensed()

--- @class Consume : Action
local Consume = prism.Action:extend "Consume"
Consume.targets = { ConsumeTarget }
Consume.name = "Consume"

--- @param level Level
--- @param consumable Actor
function Consume:perform(level, consumable)
   local consumablecomponent = consumable:expect(prism.components.Consumable)

   local statusComponent = self.owner:get(prism.components.StatusEffects)
   if statusComponent and consumablecomponent.status then statusComponent:add(consumablecomponent.status) end

   local health = self.owner:get(prism.components.Health)
   if health and consumablecomponent.healing then health:heal(consumablecomponent.healing) end

   level:removeActor(consumable)
   local consumableName = Name.get(consumable)
   Log.addMessage(self.owner, sf("You consume the %s.", consumableName))
   Log.addMessageSensed(level, self, sf("The %s consumes the %s.", Name.get(self.owner), consumableName))
end

return Consume
