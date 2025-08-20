local Log = prism.components.Log
local Name = prism.components.Name
local sf = string.format

local OpenContainerTarget = prism.Target():with(prism.components.Container):sensed()

--- @class OpenContainer : Action
local OpenContainer = prism.Action:extend "OpenContainer"
OpenContainer.targets = { OpenContainerTarget }
OpenContainer.name = "Open"

--- @param level Level
--- @param container Actor
function OpenContainer:perform(level, container)
   local inventory = container:expect(prism.components.Inventory)
   local items = inventory:query():gather()

   local x, y = container:expectPosition():decompose()
   for _, item in ipairs(items) do
      inventory:removeItem(item)
      level:addActor(item, x, y)
   end
   level:removeActor(container)
   local containerName = Name.get(container)
   Log.addMessage(self.owner, sf("You break the %s.", containerName))
   Log.addMessageSensed(level, self, sf("The %s breaks the %s.", Name.get(self.owner), containerName))
end

return OpenContainer
