require "debugger"
require "prism"

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

-- Load a sprite atlas and configure the terminal-style display,
local spriteAtlas = spectrum.SpriteAtlas.fromASCIIGrid("display/wanderlust_16x16.png", 16, 16)
local display = spectrum.Display(81, 41, spriteAtlas, prism.Vector2(16, 16))

-- Automatically size the window to match the terminal dimensions
display:fitWindowToTerminal()

-- spin up our state machine
--- @type GameStateManager
local manager = spectrum.StateManager()

-- we put out levelstate on top here, but you could create a main menu
--- @diagnostic disable-next-line
function love.load()
   local builder = Game:generateNextFloor(prism.actors.Player())
   manager:push(GameLevelState(display, builder, Game:getLevelSeed()))
   manager:hook()
end
