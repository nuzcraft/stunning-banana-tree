local PARTITIONS = 3

--- @param rng RNG
--- @param player Actor
--- @width integer
--- @height integer
return function(rng, player, width, height)
   local builder = prism.MapBuilder(prism.cells.Wall)
   local nox, noy = rng:random(1, 10000), rng:random(1, 10000)
   for x = 1, width do
      for y = 1, height do
         local noise = love.math.perlinNoise(x / 5 + nox, y / 5 + noy)
         local cell = noise > 0.5 and prism.cells.Wall or prism.cells.Pit
         builder:set(x, y, cell())
      end
   end
   -- create rooms in each of the partitions
   --- @type table<number, Rectangle>
   local rooms = {}
   local missing = prism.Vector2(rng:random(0, PARTITIONS - 1), rng:random(0, PARTITIONS - 1))
   local pw, ph = math.floor(width / PARTITIONS), math.floor(height / PARTITIONS)
   local minrw, minrh = math.floor(pw / 3), math.floor(ph / 3)
   local maxrw, maxrh = pw - 2, ph - 2
   for px = 0, PARTITIONS - 1 do
      for py = 0, PARTITIONS - 1 do
         if not missing:equals(px, py) then
            local rw = rng:random(minrw, maxrw)
            local rh = rng:random(minrh, maxrh)
            local x = rng:random(px * pw + 1, (px + 1) * pw - rw - 1)
            local y = rng:random(py * ph + 1, (py + 1) * ph - rh - 1)
            local roomRect = prism.Rectangle(x, y, rw, rh)
            rooms[prism.Vector2._hash(px, py)] = roomRect
            builder:drawRectangle(x, y, x + rw, y + rh, prism.cells.Floor)
         end
      end
   end

   return builder
end
