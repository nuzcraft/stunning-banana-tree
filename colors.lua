require "prism"
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

local colors = preferences.colors

local black = colors.BLACK or { 0, 0, 0, 255 }
BLACK = prism.Color4(black[1] / 255.0, black[2] / 255.0, black[3] / 255.0, black[4] / 255.0)
local purple = colors.PURPLE or { 99, 42, 143, 255 }
PURPLE = prism.Color4(purple[1] / 255.0, purple[2] / 255.0, purple[3] / 255.0, purple[4] / 255.0)
local pink = colors.PINK or { 194, 71, 184, 255 }
PINK = prism.Color4(pink[1] / 255.0, pink[2] / 255.0, pink[3] / 255.0, pink[4] / 255.0)
local darkbrown = colors.DARKBROWN or { 78, 61, 59, 255 }
DARKBROWN = prism.Color4(darkbrown[1] / 255.0, darkbrown[2] / 255.0, darkbrown[3] / 255.0, darkbrown[4] / 255.0)
local darkgray = colors.DARKGRAY or { 84, 77, 84, 255 }
DARKGRAY = prism.Color4(darkgray[1] / 255.0, darkgray[2] / 255.0, darkgray[3] / 255.0, darkgray[4] / 255.0)
local gray = colors.GRAY or { 120, 108, 100, 255 }
GRAY = prism.Color4(gray[1] / 255.0, gray[2] / 255.0, gray[3] / 255.0, gray[4] / 255.0)
local lightgray = colors.LIGHTGRAY or { 160, 154, 146, 255 }
LIGHTGRAY = prism.Color4(lightgray[1] / 255.0, lightgray[2] / 255.0, lightgray[3] / 255.0, lightgray[4] / 255.0)
local white = colors.WHITE or { 245, 238, 228, 255 }
WHITE = prism.Color4(white[1] / 255.0, white[2] / 255.0, white[3] / 255.0, white[4] / 255.0)
local cyan = colors.CYAN or { 100, 213, 223, 255 }
CYAN = prism.Color4(cyan[1] / 255.0, cyan[2] / 255.0, cyan[3] / 255.0, cyan[4] / 255.0)
local lightblue = colors.LIGHTBLUE or { 71, 143, 202, 255 }
LIGHTBLUE = prism.Color4(lightblue[1] / 255.0, lightblue[2] / 255.0, lightblue[3] / 255.0, lightblue[4] / 255.0)
local blue = colors.BLUE or { 47, 88, 141, 255 }
BLUE = prism.Color4(blue[1] / 255.0, blue[2] / 255.0, blue[3] / 255.0, blue[4] / 255.0)
local darkblue = colors.DARKBLUE or { 37, 47, 64, 255 }
DARKBLUE = prism.Color4(darkblue[1] / 255.0, darkblue[2] / 255.0, darkblue[3] / 255.0, darkblue[4] / 255.0)
local darkred = colors.DARKRED or { 99, 37, 14, 255 }
DARKRED = prism.Color4(darkred[1] / 255.0, darkred[2] / 255.0, darkred[3] / 255.0, darkred[4] / 255.0)
local red = colors.RED or { 158, 50, 39, 255 }
RED = prism.Color4(red[1] / 255.0, red[2] / 255.0, red[3] / 255.0, red[4] / 255.0)
local orange = colors.ORANGE or { 216, 121, 69, 255 }
ORANGE = prism.Color4(orange[1] / 255.0, orange[2] / 255.0, orange[3] / 255.0, orange[4] / 255.0)
local yellow = colors.YELLOW or { 244, 220, 109, 255 }
YELLOW = prism.Color4(yellow[1] / 255.0, yellow[2] / 255.0, yellow[3] / 255.0, yellow[4] / 255.0)
local lightgreen = colors.LIGHTGREEN or { 137, 170, 85, 255 }
LIGHTGREEN = prism.Color4(lightgreen[1] / 255.0, lightgreen[2] / 255.0, lightgreen[3] / 255.0, lightgreen[4] / 255.0)
local green = colors.GREEN or { 78, 131, 87, 255 }
GREEN = prism.Color4(green[1] / 255.0, green[2] / 255.0, green[3] / 255.0, green[4] / 255.0)
local darkgreen = colors.DARKGREEN or { 56, 105, 86, 255 }
DARKGREEN = prism.Color4(darkgreen[1] / 255.0, darkgreen[2] / 255.0, darkgreen[3] / 255.0, darkgreen[4] / 255.0)
local darkergreen = colors.DARKERGREEN or { 43, 74, 60, 255 }
DARKERGREEN =
   prism.Color4(darkergreen[1] / 255.0, darkergreen[2] / 255.0, darkergreen[3] / 255.0, darkergreen[4] / 255.0)
local tan = colors.TAN or { 233, 155, 124, 255 }
TAN = prism.Color4(tan[1] / 255.0, tan[2] / 255.0, tan[3] / 255.0, tan[4] / 255.0)
local brown = colors.BROWN or { 130, 83, 65, 255 }
BROWN = prism.Color4(brown[1] / 255.0, brown[2] / 255.0, brown[3] / 255.0, brown[4] / 255.0)
