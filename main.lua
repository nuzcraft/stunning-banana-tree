require "debugger"
require "prism"
require "colors"
local json = require "prism.engine.lib.json"
local prefData
if love.filesystem.getInfo("preferences.json") then
   prefData = love.filesystem.read("preferences.json")
else
   local file = io.open("preferences.json", "r")
   local file2 = io.open("lib/preferences.json", "r")
   local file3 = io.open("../Resources/preferences.json", "r")
   if file then
      prefData = file:read("*a")
      file:close()
   elseif file2 then
      prefData = file2:read("*a")
      file2:close()
   elseif file3 then
      prefData = file3:read("*a")
      file3:close()
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
local fontWidth, fontHeight = 16, 16
local w, h = string.match(fontPath, "(%d+)x(%d+)")
if w and h then
   fontWidth = tonumber(w)
   fontHeight = tonumber(h)
end
love.graphics.setDefaultFilter("nearest", "nearest")
local atlasPath = "display/" .. string.gsub(fontPath, ".png", ".json")
local spriteAtlas
if love.filesystem.getInfo(atlasPath) then
   spriteAtlas = spectrum.SpriteAtlas.fromAtlased("display/" .. fontPath, atlasPath)
else
   spriteAtlas = spectrum.SpriteAtlas.fromAtlased(
      "display/" .. fontPath,
      "display/ascii_" .. fontWidth .. "x" .. fontHeight .. ".json"
   )
end
local display = spectrum.Display(81, 41, spriteAtlas, prism.Vector2(fontWidth, fontHeight))

Game.scale = preferences.scale
-- Automatically size the window to match the terminal dimensions
-- display:fitWindowToTerminal()
local cellWidth, cellHeight = display.cellSize.x, display.cellSize.y
local windowWidth = display.width * cellWidth * Game.scale
local windowHeight = display.height * cellHeight * Game.scale
love.window.updateMode(windowWidth, windowHeight, { resizable = true, usedpiscale = false })

-- spin up our state machine
--- @type GameStateManager
local manager = spectrum.StateManager()

-- we put out levelstate on top here, but you could create a main menu
--- @diagnostic disable-next-line
function love.load()
   manager:push(TitleState(display))
   manager:hook()
end
