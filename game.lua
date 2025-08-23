require "levelgen"

--- @class GameStats
--- @field numKicks integer
--- @field numStomps integer
--- @field koboldsKilled integer
--- @field koboldsPitted integer
--- @field healthHealed integer
--- @field chestsOpened integer
--- @field damageDone integer
--- @field damageTaken integer
--- @field floorsDescended integer

--- @class Game : Object
--- @field depth integer
--- @field rng RNG
--- @field turns integer
--- @field kickmode string
--- @field stats GameStats
--- @overload fun(seed: string): Game
local Game = prism.Object:extend("Game")

--- @param seed string
function Game:__new(seed)
   self.depth = 0
   self.rng = prism.RNG(seed)
   self.turns = 0
   self.kickmode = "Kicking"
   self.stats = {
      numKicks = 0,
      numStomps = 0,
      koboldsKilled = 0,
      koboldsPitted = 0,
      healthHealed = 0,
      chestsOpened = 0,
      damageDone = 0,
      damageTaken = 0,
      floorsDescended = 0,
   }
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
   return GetLevel(genRNG, player, 60, 30, self.depth)
end

return Game(tostring(os.time()))
