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
   local walkmask = prism.Collision.createBitmaskFromMovetypes { "walk" }
   local x, y = container:expectPosition():decompose()

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

   for _, item in ipairs(items) do
      inventory:removeItem(item)
      local vec = table.remove(dropcells, 1).pos
      if vec then level:addActor(item, vec.x, vec.y) end
   end

   level:removeActor(container)
   local containerName = Name.get(container)
   Log.addMessage(self.owner, sf("You break the %s.", containerName))
   Log.addMessageSensed(level, self, sf("The %s breaks the %s.", Name.get(self.owner), containerName))
   if Name.get(self.owner) == "Player" then Game.stats.chestsOpened = Game.stats.chestsOpened + 1 end
end

return OpenContainer
