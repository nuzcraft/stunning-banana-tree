require "debugger"
require "prism"

prism.loadModule("prism/spectrum")
prism.loadModule("modules/game")

local spriteAtlas = spectrum.SpriteAtlas.fromASCIIGrid("display/wanderlust_16x16.png", 16, 16)
local display = spectrum.Display(81, 41, spriteAtlas, prism.Vector2(16, 16))

display:fitWindowToTerminal()

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
   local map = prism.Map(81, 41, prism.cells.Wall)
   local player = prism.actors.Player()
   player.position = prism.Vector2(12, 12)
   local actors = { player }
   local systems = {}
   local level = prism.Level(map, actors, systems)
   local levelState = spectrum.LevelState(level, display)
   levelState.display:clear()
   levelState.display:putString(1, 1, "Hello World!")
   levelState.display:draw()
end
