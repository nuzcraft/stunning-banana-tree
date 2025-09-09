local keybindings = require "keybindingschema"
local GameLevelState = require "gamestates.gamelevelstate"

--- @class TitleState : GameState
--- @field display Display
--- @overload fun(display: Display): TitleState
local TitleState = spectrum.GameState:extend "TitleState"

function TitleState:__new(display)
   self.display = display
end

function TitleState:draw()
   local midpoint = math.floor(self.display.height / 2)
   local midwidth = math.floor(self.display.width / 2)
   local cam = spectrum.Camera(0, 0)
   cam:setScale(1.0 / Game.scale, 1.0 / Game.scale)
   cam:push()
   self.display:clear()
   self.display:putString(1, midpoint - 2, "Nuzcraft's Kicking Kobolds", WHITE, nil, nil, "center", self.display.width)
   self.display:put(midwidth - 13, midpoint - 2, 219, GREEN, nil, nil)
   self.display:put(midwidth + 14, midpoint - 2, 192, GREEN, nil, nil)
   self.display:put(midwidth - 13, midpoint - 1, 193, GREEN, nil, nil)
   self.display:put(midwidth + 14, midpoint - 1, 218, GREEN, nil, nil)
   for i = 1, 26 do
      self.display:put(midwidth - 13 + i, midpoint - 1, 197, GREEN, nil, nil)
   end
   self.display:putString(1, midpoint + 3, "press any key to start", WHITE, nil, nil, "center", self.display.width)
   self.display:putString(1, midpoint + 4, "[esc] to quit", DARKGRAY, nil, nil, "center", self.display.width)
   self.display:putString(
      2,
      midpoint + 18,
      "Made with Love2D & PrismRL",
      DARKGRAY,
      nil,
      nil,
      "left",
      self.display.width
   )
   self.display:putString(
      2,
      midpoint + 19,
      "Wanderlust tiles by Kynsmer",
      DARKGRAY,
      nil,
      nil,
      "left",
      self.display.width
   )
   self.display:putString(
      2,
      midpoint + 20,
      "Extended from PrismRL 'Kicking Kobolds' project",
      DARKGRAY,
      nil,
      nil,
      "left",
      self.display.width
   )
   self.display:putString(2, midpoint + 21, "Version 0.02", DARKGRAY, nil, nil, "left", self.display.width)
   self.display:draw()
   cam:pop()
end

function TitleState:keypressed(key, scancode, isrepeat)
   local action = keybindings:keypressed(key, "title")
   if action == "quit" then
      love.event.quit()
   else
      local builder = Game:generateNextFloor(prism.actors.Player())
      self.manager:push(GameLevelState(self.display, builder, Game:getLevelSeed()))
   end
end

return TitleState
