local Log = prism.components.Log
local Name = prism.components.Name

--- @class Die : Action
--- @overload fun(owner: Actor): Die
local Die = prism.Action:extend("Die")

local walkmask = prism.Collision.createBitmaskFromMovetypes { "walk" }

function Die:perform(level)
   local x, y = self.owner:getPosition():decompose()
   local dropTable = self.owner:get(prism.components.DropTable)

   local dropcells = {}
   for i = -2, 2, 1 do
      for j = -2, 2, 1 do
         if level:inBounds(x + i, y + j) then
            local cellmask = level:getCell(x + i, y + j):getCollisionMask()
            if prism.Collision.checkBitmaskOverlap(walkmask, cellmask) then
               local cellVec = prism.Vector2(x + i, y + j)
               local dist = cellVec:distance(prism.Vector2(x, y))
               table.insert(dropcells, { pos = cellVec, distance = dist })
            end
         end
      end
   end

   local function distanceSorting(celldist1, celldist2)
      return celldist1.distance < celldist2.distance
   end

   table.sort(dropcells, distanceSorting)

   local deadPosCellMask = level:getCell(x, y):getCollisionMask()
   if prism.Collision.checkBitmaskOverlap(walkmask, deadPosCellMask) and dropTable then
      local drops = dropTable:getDrops(level.RNG)
      for _, drop in ipairs(drops) do
         local vec = table.remove(dropcells, 1).pos
         if vec then level:addActor(drop, vec.x, vec.y) end
      end
   end

   if Name.get(self.owner) == "Kobold" then Game.stats.koboldsKilled = Game.stats.koboldsKilled + 1 end

   level:removeActor(self.owner)

   if not level:query(prism.components.PlayerController):first() then level:yield(prism.messages.Lose()) end
end

return Die
