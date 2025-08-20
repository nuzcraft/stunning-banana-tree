local keybindings = require "keybindingschema"
local GameOverState = require "gamestates.gameoverstate"
local InventoryState = require "gamestates.inventorystate"

--- @class GameLevelState : LevelState
--- @field path Path
--- @field level Level
--- @overload fun(display: Display, builder: MapBuilder, seed: string): GameLevelState
local GameLevelState = spectrum.LevelState:extend "GameLevelState"

--- @param display Display
--- @param builder MapBuilder
--- @param seed string
function GameLevelState:__new(display, builder, seed)
   local map, actors = builder:build()
   local level = prism.Level(map, actors, {
      prism.systems.Senses(),
      prism.systems.Sight(),
      prism.systems.Fall(),
      prism.systems.Tick(),
   }, nil, seed)

   spectrum.LevelState.__new(self, level, display)
end

--- @param message Message
function GameLevelState:handleMessage(message)
   spectrum.LevelState.handleMessage(self, message)

   if prism.messages.Lose:is(message) then self.manager:enter(GameOverState(self.display)) end
   if prism.messages.Descend:is(message) then
      self.manager:enter(GameLevelState(self.display, Game:generateNextFloor(message.descender), Game:getLevelSeed()))
   end
end

--- @param primary Senses[] { curActor:getComponent(prism.components.Senses)}
--- @param secondary Senses[]
function GameLevelState:draw(primary, secondary)
   if not self.decision then return end

   self.display:clear()

   local position = self.decision.actor:getPosition()
   if not position then return end

   local x, y = self.display:getCenterOffset(position:decompose())
   self.display:setCamera(x, y)

   local primary, secondary = self:getSenses()
   -- Render the level using the actor’s senses
   self.display:putSenses(primary, secondary)

   -- custom terminal drawing goes here!
   local currentActor = self:getCurrentActor()
   local health = currentActor and currentActor:get(prism.components.Health)
   if health then self.display:putString(1, 1, "HP:" .. health.hp .. "/" .. health:getMaxHP()) end
   self.display:putString(1, 2, "Depth: " .. Game.depth)
   self.display:putString(-1, 2, "Turns: " .. Game.turns, nil, nil, nil, "right", self.display.width)

   local log = currentActor and currentActor:get(prism.components.Log)
   if log then
      local offset = 0
      for line in log:iterLast(5) do
         self.display:putString(1, self.display.height - offset, line)
         offset = offset + 1
      end
   end

   -- Actually render the terminal out and present it to the screen.
   -- You could use love2d to translate and say center a smaller terminal or
   -- offset it for custom non-terminal UI elements. If you do scale the UI
   -- just remember that display:getCellUnderMouse expects the mouse in the
   -- display's local pixel coordinates
   self.display:draw()

   -- custom love2d drawing goes here!
end

-- Maps string actions from the keybinding schema to directional vectors.
local keybindOffsets = {
   ["move up"] = prism.Vector2.UP,
   ["move left"] = prism.Vector2.LEFT,
   ["move down"] = prism.Vector2.DOWN,
   ["move right"] = prism.Vector2.RIGHT,
   ["move up-left"] = prism.Vector2.UP_LEFT,
   ["move up-right"] = prism.Vector2.UP_RIGHT,
   ["move down-left"] = prism.Vector2.DOWN_LEFT,
   ["move down-right"] = prism.Vector2.DOWN_RIGHT,
}

-- The input handling functions act as the player controller’s logic.
-- You should NOT mutate the Level here directly. Instead, find a valid
-- action and set it in the decision object. It will then be executed by
-- the level. This is a similar pattern to the example KoboldController.
function GameLevelState:keypressed(key, scancode)
   -- handles opening geometer for us
   spectrum.LevelState.keypressed(self, key, scancode)

   local decision = self.decision
   if not decision then return end

   local owner = decision.actor

   -- Resolve the action string from the keybinding schema
   local action = keybindings:keypressed(key)

   -- Attempt to translate the action into a directional move
   if keybindOffsets[action] then
      local destination = owner:getPosition() + keybindOffsets[action]

      local descendTarget = self.level:query(prism.components.Stairs):at(destination:decompose()):first()
      local descend = prism.actions.Descend(owner, descendTarget)
      if self.level:canPerform(descend) then
         decision:setAction(descend)
         return
      end

      local move = prism.actions.Move(owner, destination)
      if self.level:canPerform(move) then
         decision:setAction(move)
         Game.turns = Game.turns + 1
         return
      end

      local openable = self.level:query(prism.components.Container):at(destination:decompose()):first()
      local openContainer = prism.actions.OpenContainer(owner, openable)
      if self.level:canPerform(openContainer) then
         decision:setAction(openContainer)
         Game.turns = Game.turns + 1
         return
      end

      local target = self.level:query():at(destination:decompose()):first()
      local kick = prism.actions.Kick(owner, target)
      if self.level:canPerform(kick) then
         decision:setAction(kick)
         Game.turns = Game.turns + 1
      end
   end

   if action == "inventory" then
      local inventory = owner:get(prism.components.Inventory)
      if inventory then
         local inventoryState = InventoryState(self.display, decision, self.level, inventory)
         self.manager:push(inventoryState)
      end
   end

   if action == "pickup" then
      local target = self.level:query(prism.components.Item):at(owner:getPosition():decompose()):first()
      local pickup = prism.actions.Pickup(owner, target)
      if self.level:canPerform(pickup) then
         decision:setAction(pickup)
         return
      end
   end

   -- Handle waiting
   if action == "wait" then
      decision:setAction(prism.actions.Wait(self.decision.actor))
      Game.turns = Game.turns + 1
   end
end

return GameLevelState
