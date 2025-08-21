local Log = prism.components.Log
local Name = prism.components.Name

--- @class Die : Action
--- @overload fun(owner: Actor): Die
local Die = prism.Action:extend("Die")

local walkmask = prism.Collision.createBitmaskFromMovetypes { "walk" }

function Die:perform(level)
   local x, y = self.owner:getPosition():decompose()
   local dropTable = self.owner:get(prism.components.DropTable)
   local cellmask = level:getCell(x, y):getCollisionMask()

   if prism.Collision.checkBitmaskOverlap(walkmask, cellmask) and dropTable then
      local drops = dropTable:getDrops(level.RNG)
      for _, drop in ipairs(drops) do
         level:addActor(drop, x, y)
      end
   end

   level:removeActor(self.owner)

   if not level:query(prism.components.PlayerController):first() then level:yield(prism.messages.Lose()) end
end

return Die
