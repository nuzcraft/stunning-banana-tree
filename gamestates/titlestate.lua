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
   self.display:clear()
   self.display:putString(
      1,
      midpoint - 2,
      "Nuzcraft's Kicking Kobolds",
      prism.Color4.WHITE,
      nil,
      nil,
      "center",
      self.display.width
   )
   self.display:put(midwidth - 13, midpoint - 2, 219, prism.Color4.GREEN, nil, nil)
   self.display:put(midwidth + 14, midpoint - 2, 192, prism.Color4.GREEN, nil, nil)
   self.display:put(midwidth - 13, midpoint - 1, 193, prism.Color4.GREEN, nil, nil)
   self.display:put(midwidth + 14, midpoint - 1, 218, prism.Color4.GREEN, nil, nil)
   for i = 1, 26 do
      self.display:put(midwidth - 13 + i, midpoint - 1, 197, prism.Color4.GREEN, nil, nil)
   end
   self.display:putString(1, midpoint + 3, "press any key to start", nil, nil, nil, "center", self.display.width)
   self.display:putString(
      1,
      midpoint + 4,
      "[esc] to quit",
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "center",
      self.display.width
   )
   self.display:putString(
      2,
      midpoint + 18,
      "Made with Love2D & PrismRL",
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "left",
      self.display.width
   )
   self.display:putString(
      2,
      midpoint + 19,
      "Wanderlust tiles by Kynsmer",
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "left",
      self.display.width
   )
   self.display:putString(
      2,
      midpoint + 20,
      "Extended from PrismRL 'Kicking Kobolds' project",
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "left",
      self.display.width
   )
   self.display:draw()
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
