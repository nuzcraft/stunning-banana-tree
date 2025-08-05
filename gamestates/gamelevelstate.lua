local keybindings = require "keybindingschema"
local GameOverState = require "gamestates.gameoverstate"
local levelgen = require "levelgen"

--- @class MyGameLevelState : LevelState
--- A custom game level state responsible for initializing the level map,
--- handling input, and drawing the state to the screen.
---
--- @field path Path
--- @field level Level
--- @overload fun(display: Display): MyGameLevelState
local MyGameLevelState = spectrum.LevelState:extend "MyGameLevelState"

--- @param display Display
function MyGameLevelState:__new(display)
   local seed = tostring(os.time())
   local mapbuilder = levelgen(prism.RNG(seed), prism.actors.Player(), 60, 30)

   -- Build the map and instantiate the level with systems
   local map, actors = mapbuilder:build()

   local level = prism.Level(map, actors, {
      prism.systems.Senses(),
      prism.systems.Sight(),
      prism.systems.Fall(),
   })

   -- Initialize with the created level and display, the heavy lifting is done by
   -- the parent class.
   spectrum.LevelState.__new(self, level, display)
end

function MyGameLevelState:handleMessage(message)
   spectrum.LevelState.handleMessage(self, message)

   if prism.messages.Lose:is(message) then self.manager:enter(GameOverState(self.display)) end
   if prism.messages.Descend:is(message) then self.manager:enter(MyGameLevelState(self.display)) end
   -- Handle any messages sent to the level state from the level. LevelState
   -- handles a few built-in messages for you, like the decision you fill out
   -- here.

   -- This is where you'd process custom messages like advancing to the next
   -- level or triggering a game over.
end

--- @param primary Senses[] { curActor:getComponent(prism.components.Senses)}
--- @param secondary Senses[]
function MyGameLevelState:draw(primary, secondary)
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
   if health then self.display:putString(1, 1, "HP:" .. health.hp .. "/" .. health.maxHP) end

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
function MyGameLevelState:keypressed(key, scancode)
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
         return
      end

      local target = self.level:query():at(destination:decompose()):first()

      local kick = prism.actions.Kick(owner, target)
      if self.level:canPerform(kick) then decision:setAction(kick) end
   end

   -- Handle waiting
   if action == "wait" then decision:setAction(prism.actions.Wait(self.decision.actor)) end
end

return MyGameLevelState
