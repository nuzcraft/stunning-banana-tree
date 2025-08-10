--- @class Tick : Action
local Tick = prism.Action:extend "Tick"
Tick.requiredComponents = { prism.components.StatusEffects }

--- @param level Level
function Tick:perform(level)
   local statusComponent = self.owner:expect(prism.components.StatusEffects)
   local expired = {}
   for handle, status in statusComponent:pairs() do
      --- @cast status GameStatusInstance
      if status.duration then
         status.duration = status.duration - 1
         if status.duration <= 0 then table.insert(expired, handle) end
      end
   end

   for _, handle in ipairs(expired) do
      statusComponent:remove(handle)
   end

   local health = self.owner:get(prism.components.Health)
   if health then health:enforceBounds() end
end

return Tick
