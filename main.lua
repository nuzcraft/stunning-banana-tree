require "debugger"
require "prism"
require "colors"

prism.loadModule("prism/spectrum")
prism.loadModule("prism/extra/sight")
prism.loadModule("prism/extra/log")
prism.loadModule("prism/extra/inventory")
prism.loadModule("prism/extra/droptable")
prism.loadModule("prism/extra/statuseffects")
prism.loadModule("modules/basegame")
prism.loadModule("modules/game")

Game = require("game")

-- Grab our level state and sprite atlas.
local GameLevelState = require "gamestates.gamelevelstate"
local TitleState = require "gamestates.titlestate"
-- local TitleState = require "gamestates.gameoverstate" -- for testing

-- Load a sprite atlas and configure the terminal-style display,
love.graphics.setDefaultFilter("nearest", "nearest")
local spriteAtlas = spectrum.SpriteAtlas.fromASCIIGrid("display/wanderlust_16x16.png", 16, 16)

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
