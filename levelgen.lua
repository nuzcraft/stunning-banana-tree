require "helper"
local chestloot = require "loot.chest"
--- @type table<integer>
local PARTITIONS = { 3, 3, 3, 4, 4, 4, 4, 4, 5, 5 }

--- @type table<Vector2>
local SIZE_RECT = {
   prism.Vector2(40, 20),
   prism.Vector2(50, 30),
   prism.Vector2(50, 30),
   prism.Vector2(50, 30),
   prism.Vector2(60, 40),
   prism.Vector2(60, 40),
   prism.Vector2(70, 50),
   prism.Vector2(70, 50),
   prism.Vector2(80, 60),
   prism.Vector2(100, 80),
}
--- @type table<Vector2>
local SIZE_CIRC = {
   prism.Vector2(40, 40),
   prism.Vector2(40, 40),
   prism.Vector2(40, 40),
   prism.Vector2(40, 40),
   prism.Vector2(50, 50),
   prism.Vector2(50, 50),
   prism.Vector2(60, 60),
   prism.Vector2(70, 70),
   prism.Vector2(80, 80),
   prism.Vector2(100, 100),
}

--- @param rng RNG
--- @param width integer
--- @param height integer
--- @param depth integer
function GenerateBaseMapBuilder(rng, width, height, depth)
   -- remove width and height parameters, make width, height, and partitions a function of depth and type
   local builder = prism.MapBuilder(prism.cells.Wall)
   local nox, noy = rng:random(1, 10000), rng:random(1, 10000)
   for x = 1, width do
      for y = 1, height do
         local noise = love.math.perlinNoise(x / 5 + nox, y / 5 + noy)
         local noise_limit = math.max(0.6 - (depth * 0.02), 0.4)
         local cell = noise > noise_limit and prism.cells.Wall or prism.cells.Pit
         builder:set(x, y, cell())
      end
   end
   return builder
end

--- @param rng RNG
--- @param width integer
--- @param height integer
--- @param partitions integer
--- @param builder MapBuilder
--- @param type string
function AddRoomsToBuilder(rng, width, height, partitions, builder, type)
   local rooms = {}
   local missing = prism.Vector2(rng:random(0, partitions - 1), rng:random(0, partitions - 1))
   local pw, ph = math.floor(width / partitions), math.floor(height / partitions)
   -- rectangle min & max
   local minrw, minrh = math.floor(pw / 3), math.floor(ph / 3)
   local maxrw, maxrh = pw - 2, ph - 2
   -- radius min & max
   local minrx, minry = math.floor(pw / 6), math.floor(ph / 3)
   local maxrx, maxry = math.floor((pw - 2) / 2), math.floor((ph - 2) / 2)
   for px = 0, partitions - 1 do
      for py = 0, partitions - 1 do
         if not missing:equals(px, py) then
            if type == "RectangleGrid" then
               local rw = rng:random(minrw, maxrw)
               local rh = rng:random(minrh, maxrh)
               local x = rng:random(px * pw + 1, (px + 1) * pw - rw - 1)
               local y = rng:random(py * ph + 1, (py + 1) * ph - rh - 1)
               local roomRect = prism.Rectangle(x, y, rw, rh)
               rooms[prism.Vector2._hash(px, py)] = roomRect
               builder:drawRectangle(x, y, x + rw, y + rh, prism.cells.Floor)
            elseif type == "CircleGrid" then
               local rx = rng:random(minrx, maxrx)
               local ry = rng:random(minry, maxry)
               local r = math.max(rx, ry)
               local x = (px * pw + 1) + math.floor(pw / 2)
               local y = (py * ph + 1) + math.floor(ph / 2)
               local roomEllipse = { cx = x, cy = y, rx = r, ry = r }
               rooms[prism.Vector2._hash(px, py)] = roomEllipse
               builder:drawEllipse(x, y, r, r, prism.cells.Floor)
            end
         end
      end
   end
   return rooms, builder
end

--- @param rng RNG
--- @param builder MapBuilder
--- @param vecA Vector2
--- @param vecB Vector2
function CreateLShapedHallway(rng, builder, vecA, vecB)
   if not vecA or not vecB then return end
   -- randomly choose one of two l shaped tunnel patterns
   if rng:random() > 0.5 then
      builder:drawLine(vecA.x, vecA.y, vecB.x, vecA.y, prism.cells.Floor)
      builder:drawLine(vecB.x, vecA.y, vecB.x, vecB.y, prism.cells.Floor)
   else
      builder:drawLine(vecA.x, vecA.y, vecA.x, vecB.y, prism.cells.Floor)
      builder:drawLine(vecA.x, vecB.y, vecB.x, vecB.y, prism.cells.Floor)
   end
   return builder
end

--- @param width integer
--- @param height integer
--- @param depth integer
--- @param builder MapBuilder
function SetAlternateCells(width, height, depth, builder)
   for x = 0, width + 1 do
      for y = 0, height + 1 do
         local cell = builder:get(x, y)
         if cell:getName() == "Pit" and builder:get(x, y - 1):getName() ~= "Pit" then
            cell:give(prism.components.Drawable({ char = '"', color = prism.Color4.DARKGRAY }))
            -- elseif builder:get(x, y):getName() == "Wall" and builder:get(x, y + 1):getName() == "Floor" then
            --    builder:get(x, y):give(prism.components.Drawable({ char = "=" }))
         elseif cell:getName() == "Wall" and depth >= 5 then
            local drawable = cell:get(prism.components.Drawable)
            if drawable and depth < 10 then
               drawable.color = ORANGE
            else
               drawable.color = prism.Color4.RED
            end
            cell:give(drawable)
         end
      end
   end
   return builder
end

--- @param rng RNG
--- @param player Actor
--- @depth integer
function ClassicLevel(rng, player, depth)
   local size_depth = depth
   if size_depth > #SIZE_RECT then size_depth = #SIZE_RECT end
   local width, height = SIZE_RECT[size_depth]:decompose()

   local partitions_depth = depth
   if partitions_depth > #PARTITIONS then partitions_depth = #PARTITIONS end
   local partitions = PARTITIONS[partitions_depth]

   local builder = GenerateBaseMapBuilder(rng, width, height, depth)
   --- @type table<number, Rectangle>
   local rooms = {}
   rooms, builder = AddRoomsToBuilder(rng, width, height, partitions, builder, "RectangleGrid")

   -- add hallways between rooms
   for hash, currentRoom in pairs(rooms) do
      local px, py = prism.Vector2._unhash(hash)
      local adjRoom1 = rooms[prism.Vector2._hash(px + 1, py)]
      local a1x, a1y = nil, nil
      if adjRoom1 then
         a1x, a1y = adjRoom1:center():floor():decompose()
      end
      local adjRoom2 = rooms[prism.Vector2._hash(px, py + 1)]
      local a2x, a2y = nil, nil
      if adjRoom2 then
         a2x, a2y = adjRoom2:center():floor():decompose()
      end
      local cx, cy = currentRoom:center():floor():decompose()
      if adjRoom1 then builder = CreateLShapedHallway(rng, builder, prism.Vector2(cx, cy), prism.Vector2(a1x, a1y)) end
      if adjRoom2 then builder = CreateLShapedHallway(rng, builder, prism.Vector2(cx, cy), prism.Vector2(a2x, a2y)) end
   end

   local startRoom
   while not startRoom do
      local x, y = rng:random(0, partitions - 1), rng:random(0, partitions - 1)
      startRoom = rooms[prism.Vector2._hash(x, y)]
   end

   local playerPos = startRoom:center():floor()
   assert(builder)
   builder:addActor(player, playerPos.x, playerPos.y)

   for _, room in pairs(rooms) do
      local cx, cy = room:center():floor():decompose()
      local sides = {
         prism.Vector2(cx - 1, cy - 1),
         prism.Vector2(cx - 1, cy + 1),
         prism.Vector2(cx + 1, cy - 1),
         prism.Vector2(cx + 1, cy - 1),
      }
      ShuffleInPlace(sides)
      if room ~= startRoom then
         for n = 1, math.min(math.ceil((depth + 1) / 5), 4) do
            local vec = sides[n]
            builder:addActor(prism.actors.Kobold(), vec.x, vec.y)
         end
      end
   end

   builder:addPadding(1, prism.cells.Wall)

   --- @type Rectangle[]
   local availableRooms = {}
   for _, room in pairs(rooms) do
      if room ~= startRoom then table.insert(availableRooms, room) end
   end

   local stairRoom = availableRooms[rng:random(1, #availableRooms)]
   local corners = stairRoom:toCorners()
   local randCorner = corners[rng:random(1, #corners)]
   builder:addActor(prism.actors.Stairs(), randCorner.x, randCorner.y)

   local chestRoom = availableRooms[rng:random(1, #availableRooms)]
   local center = chestRoom:center()
   local drops = prism.components.DropTable(chestloot):getDrops(rng)
   builder:addActor(prism.actors.Chest(drops), math.floor(center.x), math.floor(center.y))

   if depth >= 5 then
      local chestRoom2 = availableRooms[rng:random(1, #availableRooms)]
      local center2 = chestRoom2:center()
      local drops2 = prism.components.DropTable(chestloot):getDrops(rng)
      builder:addActor(prism.actors.Chest(drops2), math.floor(center2.x), math.floor(center2.y))
   end
   if depth >= 10 then
      local chestRoom2 = availableRooms[rng:random(1, #availableRooms)]
      local center2 = chestRoom2:center()
      local drops2 = prism.components.DropTable(chestloot):getDrops(rng)
      builder:addActor(prism.actors.Chest(drops2), math.floor(center2.x), math.floor(center2.y))
   end

   builder = SetAlternateCells(width, height, depth, builder)

   return builder
end

--- @param rng RNG
--- @param player Actor
--- @depth integer
function CircleLevel(rng, player, depth)
   local size_depth = depth
   if size_depth > #SIZE_CIRC then size_depth = #SIZE_CIRC end
   local width, height = SIZE_CIRC[size_depth]:decompose()

   local partitions_depth = depth
   if partitions_depth > #PARTITIONS then partitions_depth = #PARTITIONS end
   local partitions = PARTITIONS[partitions_depth]

   local builder = GenerateBaseMapBuilder(rng, width, height, depth)
   --- @type table<number, table>
   local rooms = {}
   rooms, builder = AddRoomsToBuilder(rng, width, height, partitions, builder, "CircleGrid")

   -- add hallways between rooms
   for hash, currentRoom in pairs(rooms) do
      local px, py = prism.Vector2._unhash(hash)
      local adjRoom1 = rooms[prism.Vector2._hash(px + 1, py)]
      local adjRoom2 = rooms[prism.Vector2._hash(px, py + 1)]
      if adjRoom1 then
         builder = CreateLShapedHallway(
            rng,
            builder,
            prism.Vector2(currentRoom.cx, currentRoom.cy),
            prism.Vector2(adjRoom1.cx, adjRoom1.cy)
         )
      end
      if adjRoom2 then
         builder = CreateLShapedHallway(
            rng,
            builder,
            prism.Vector2(currentRoom.cx, currentRoom.cy),
            prism.Vector2(adjRoom2.cx, adjRoom2.cy)
         )
      end
   end

   assert(builder)

   -- add pits to the middles
   for _, room in pairs(rooms) do
      local r = math.min(room.ry - 3, room.rx - 3)
      builder:drawEllipse(room.cx, room.cy, r, r, prism.cells.Pit)
   end

   local startRoom
   while not startRoom do
      local x, y = rng:random(0, partitions - 1), rng:random(0, partitions - 1)
      startRoom = rooms[prism.Vector2._hash(x, y)]
   end

   local playerPos = prism.Vector2(startRoom.cx - startRoom.rx + 1, startRoom.cy)
   builder:addActor(player, playerPos.x, playerPos.y)

   for _, room in pairs(rooms) do
      local sides = {
         prism.Vector2(room.cx - room.rx + 1, room.cy),
         prism.Vector2(room.cx + room.rx - 1, room.cy),
         prism.Vector2(room.cx, room.cy - room.ry + 1),
         prism.Vector2(room.cx, room.cy + room.ry - 1),
      }
      ShuffleInPlace(sides)
      if room ~= startRoom then
         for n = 1, math.min(math.ceil((depth + 1) / 5), 4) do
            local vec = sides[n]
            builder:addActor(prism.actors.Kobold(), vec.x, vec.y)
         end
      end
   end

   builder:addPadding(1, prism.cells.Wall)

   --- @type table[]
   local availableRooms = {}
   for _, room in pairs(rooms) do
      if room ~= startRoom then table.insert(availableRooms, room) end
   end

   local stairRoom = availableRooms[rng:random(1, #availableRooms)]
   -- local corners = stairRoom:toCorners()
   local corners = {
      prism.Vector2(stairRoom.cx - stairRoom.rx + 1, stairRoom.cy + 1),
      prism.Vector2(stairRoom.cx + stairRoom.rx - 1, stairRoom.cy + 1),
      prism.Vector2(stairRoom.cx - stairRoom.rx + 1, stairRoom.cy - 1),
      prism.Vector2(stairRoom.cx + stairRoom.rx - 1, stairRoom.cy - 1),
   }
   local randCorner = corners[rng:random(1, #corners)]
   builder:addActor(prism.actors.Stairs(), randCorner.x, randCorner.y)

   local chestRoom = availableRooms[rng:random(1, #availableRooms)]
   local center = prism.Vector2(chestRoom.cx + chestRoom.rx - 1, chestRoom.cy - 1)
   local drops = prism.components.DropTable(chestloot):getDrops(rng)
   builder:addActor(prism.actors.Chest(drops), math.floor(center.x), math.floor(center.y))

   if depth >= 5 then
      local chestRoom2 = availableRooms[rng:random(1, #availableRooms)]
      local center2 = prism.Vector2(chestRoom2.cx + chestRoom.rx - 1, chestRoom2.cy - 1)
      local drops2 = prism.components.DropTable(chestloot):getDrops(rng)
      builder:addActor(prism.actors.Chest(drops2), math.floor(center2.x), math.floor(center2.y))
   end
   if depth >= 10 then
      local chestRoom2 = availableRooms[rng:random(1, #availableRooms)]
      local center2 = prism.Vector2(chestRoom2.cx + chestRoom.rx - 1, chestRoom2.cy - 1)
      local drops2 = prism.components.DropTable(chestloot):getDrops(rng)
      builder:addActor(prism.actors.Chest(drops2), math.floor(center2.x), math.floor(center2.y))
   end

   builder = SetAlternateCells(width, height, depth, builder)

   return builder
end

--- @param rng RNG
--- @param player Actor
--- @depth integer
function GetLevel(rng, player, depth)
   if rng:random() < 0.5 then
      return ClassicLevel(rng, player, depth)
   else
      return CircleLevel(rng, player, depth)
   end
end
