local levelgen = require "levelgen"

--- @class Game : Object
--- @field depth integer
--- @field rng RNG
--- @field turns integer
--- @field kickmode string
--- @overload fun(seed: string): Game
local Game = prism.Object:extend("Game")

--- @param seed string
function Game:__new(seed)
   self.depth = 0
   self.rng = prism.RNG(seed)
   self.turns = 0
   self.kickmode = "Kicking"
end

--- @return string
function Game:getLevelSeed()
   return tostring(self.rng:random())
end

--- @param player Actor
--- @return MapBuilder builder
function Game:generateNextFloor(player)
   self.depth = self.depth + 1
   local genRNG = prism.RNG(self:getLevelSeed())
   return levelgen(genRNG, player, 60, 30)
end

return Game(tostring(os.time()))
