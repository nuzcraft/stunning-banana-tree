require "levelgen"

local levelThresholds = {
   5,
   10,
   15,
   20,
   25,
   30,
   40,
   50,
   60,
   70,
   80,
   90,
   100,
}

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
--- @field xpCollected integer

--- @class Game : Object
--- @field depth integer
--- @field rng RNG
--- @field turns integer
--- @field kickmode string
--- @field stats GameStats
--- @field scale number
--- @overload fun(seed: string): Game
local Game = prism.Object:extend("Game")

--- @param seed string
function Game:__new(seed)
   self.depth = 0
   self.rng = prism.RNG(seed)
   self.turns = 0
   self.kickmode = "Kicking"
   self.xp = 0
   self.level = 1
   self.levelThreshold = levelThresholds[self.level]
   self.skillPoints = 10
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
      xpCollected = 0,
   }
   self.scale = 1.0
end

--- @return string
function Game:getLevelSeed()
   return tostring(self.rng:random())
end

--- @param player Actor
--- @return MapBuilder builder
function Game:generateNextFloor(player)
   self.depth = self.depth + 1
   self.depth = 5
   local genRNG = prism.RNG(self:getLevelSeed())
   -- return CircleLevel(genRNG, player, 50, 50, self.depth)
   return GetLevel(genRNG, player, self.depth)
end

--- @param level integer
function Game:setLevelThreshold(level)
   self.levelThreshold = levelThresholds[level]
end

return Game(tostring(os.time()))
