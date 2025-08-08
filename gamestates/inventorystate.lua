local utf8 = require "utf8"
local keybindings = require "keybindingschema"

--- @class InventoryState : GameState
--- @overload fun(display: Display, decision: ActionDecision, level: Level, inventory: Inventory)
local InventoryState = spectrum.GameState:extend "InventoryState"

--- @param display Display
--- @param decision ActionDecision
--- @param level Level
--- @param inventory Inventory
function InventoryState:__new(display, decision, level, inventory)
   self.display = display
   self.decision = decision
   self.level = level
   self.inventory = inventory
   self.items = inventory.inventory:getAllActors()
   self.letters = {}
   for i = 1, #self.items do
      self.letters[i] = utf8.char(96 + i)
   end
end

--- @param previous GameState
function InventoryState:load(previous)
   self.previousState = previous
end

function InventoryState:draw()
   self.previousState:draw()
   self.display:clear()
   self.display:putString(1, 1, "Inventory", nil, nil, 2, "right")

   for i, actor in ipairs(self.items) do
      local name = actor:getName()
      local letter = self.letters[i]

      local item = actor:expect(prism.components.Item)
      local countstr = ""
      if item.stackCount and item.stackCount > 1 then countstr = ("%sx "):format(item.stackCount) end
      local itemstr = ("[%s] %s%s"):format(letter, countstr, name)
      self.display:putString(1, 1 + i, itemstr, nil, nil, 2, "right")
   end
   self.display:draw()
end
