require "debugger"
require "prism"
require "colors"
local json = require "prism.engine.lib.json"
local prefData
if love.filesystem.getInfo("preferences.json") then
   prefData = love.filesystem.read("preferences.json")
else
   local file = io.open("preferences.json", "r")
   if file then
      prefData = file:read("*a")
      file:close()
   end
end
local preferences = json.decode(prefData)

prism.loadModule("prism/spectrum")
prism.loadModule("prism/extra/sight")
prism.loadModule("prism/extra/log")
prism.loadModule("prism/extra/inventory")
prism.loadModule("prism/extra/droptable")
prism.loadModule("prism/extra/statuseffects")
prism.loadModule("modules/basegame")
prism.loadModule("modules/game")
Game = require("game")
local TitleState = require "gamestates.titlestate"

love.graphics.setBackgroundColor(BLACK.r, BLACK.g, BLACK.b, BLACK.a)

-- Load a sprite atlas and configure the terminal-style display,
local fontPath = preferences.font or "wanderlust_16x16.png"
love.graphics.setDefaultFilter("nearest", "nearest")
local spriteAtlas = spectrum.SpriteAtlas.fromASCIIGrid("display/" .. fontPath, 16, 16)

-- local spriteAtlas = spectrum.SpriteAtlas.fromASCIIGrid("display/cp437_12x12.png", 12, 12)
-- local spriteAtlas = spectrum.SpriteAtlas.fromAtlased("display/GoblinRL.png", "display/GoblinRL.json")
local display = spectrum.Display(81, 41, spriteAtlas, prism.Vector2(16, 16))

-- Automatically size the window to match the terminal dimensions
display:fitWindowToTerminal()

-- spin up our state machine
--- @type GameStateManager
local manager = spectrum.StateManager()

-- we put out levelstate on top here, but you could create a main menu
--- @diagnostic disable-next-line
function love.load()
   manager:push(TitleState(display))
   manager:hook()
end
