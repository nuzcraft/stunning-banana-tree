local keybindings = require "keybindingschema"
local GameOverState = require "gamestates.gameoverstate"
-- local InventoryState = require "gamestates.inventorystate"
local PauseState = require "gamestates.pausestate"
local CellTargetHandler = require "gamestates.targethandlers.celltargethandler"

local keymode = ""

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

   self.shakeTime = 0
   self.shakeDuration = 0
   self.shakeMagnitude = 3
end

--- @param message Message
function GameLevelState:handleMessage(message)
   spectrum.LevelState.handleMessage(self, message)

   if prism.messages.Lose:is(message) then self.manager:enter(GameOverState(self.display)) end
   if prism.messages.Descend:is(message) then
      --- @diagnostic disable-next-line: undefined-field
      self.manager:enter(GameLevelState(self.display, Game:generateNextFloor(message.descender), Game:getLevelSeed()))
   end
end

---@param dt number
function GameLevelState:update(dt)
   spectrum.LevelState.update(self, dt)
   if self.shakeTime < self.shakeDuration then self.shakeTime = self.shakeTime + dt end
end

--- @param duration number
--- @param magnitude number
function GameLevelState:startShake(duration, magnitude)
   self.shakeTime = 0
   self.shakeDuration = duration or 0
   self.shakeMagnitude = magnitude or 5
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
   local health = currentActor and currentActor:get(prism.components.Health) or 0
   local healthString = string.format("HP:" .. health.hp .. "/" .. health:getMaxHP())
   if health then self.display:putString(1, 1, healthString) end
   local depthString = string.format("Depth:" .. Game.depth)
   self.display:putString(1, 2, depthString)

   self.display:putString(math.max(#healthString, #depthString) + 2, 1, "LVL:" .. Game.level, GREEN)
   self.display:putString(
      math.max(#healthString, #depthString) + 2,
      2,
      "XP:" .. Game.xp .. "/" .. Game.levelThreshold,
      CYAN
   )
   -- self.display:putString(1, 1, "FPS: " .. love.timer.getFPS(), WHITE, nil, nil, "right", self.display.width)
   self.display:putString(-1, 2, "Turns:" .. Game.turns, WHITE, nil, nil, "right", self.display.width)
   local kickmodeColor = ORANGE
   if Game.kickmode == "Stomping" then kickmodeColor = YELLOW end
   self.display:putString(1, 3, Game.kickmode, kickmodeColor)
   self.display:putString(1, self.display.height, "[esc] for options", LIGHTGRAY, nil, nil, "right", self.display.width)

   local log = currentActor and currentActor:get(prism.components.Log)
   if log then
      local offset = 0
      for line in log:iterLast(5) do
         local color = DARKGRAY
         if string.find(line, "Level Up!") then color = GREEN end
         self.display:putString(1, self.display.height - offset, line, color)
         offset = offset + 1
      end
   end

   -- Actually render the terminal out and present it to the screen.
   -- You could use love2d to translate and say center a smaller terminal or
   -- offset it for custom non-terminal UI elements. If you do scale the UI
   -- just remember that display:getCellUnderMouse expects the mouse in the
   -- display's local pixel coordinates
   if self.shakeTime < self.shakeDuration then
      local dx = love.math.random(-self.shakeMagnitude, self.shakeMagnitude)
      local dy = love.math.random(-self.shakeMagnitude, self.shakeMagnitude)
      love.graphics.translate(dx, dy)
   end

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

   if key == "lshift" or key == "rshift" then
      keymode = "shift"
   elseif key == "lctrl" or key == "rctrl" then
      keymode = "control"
   end

   -- Resolve the action string from the keybinding schema
   local action = keybindings:keypressed(key)
   if keymode == "shift" or keymode == "control" then action = keybindings:keypressed(key, keymode) end

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

      local target = self.level:query(prism.components.Collider):at(destination:decompose()):first()
      if Game.kickmode == "Kicking" then
         local kick = prism.actions.Kick(owner, target)
         -- local wallkick = prism.actions.WallKick(owner, destination)
         if self.level:canPerform(kick) then
            decision:setAction(kick)
            self:startShake(0.075, 2)
            Game.turns = Game.turns + 1
            -- elseif self.level:canPerform(wallkick) then
            --    decision:setAction(wallkick)
            --    Game.turns = Game.turns + 1
         end
      else
         local stomp = prism.actions.Stomp(owner, target)
         if self.level:canPerform(stomp) then
            decision:setAction(stomp)
            self:startShake(0.1, 2)
            Game.turns = Game.turns + 1
         end
      end
   end

   if action == "pause" then
      local pauseState = PauseState(self.display, decision, self.level)
      self.manager:push(pauseState)
   end

   if action == "targeting" then
      local nearbyCells = {}
      local startPos = owner:getPosition()
      if startPos then
         for i = -1, 1, 1 do
            for j = -1, 1, 1 do
               table.insert(nearbyCells, prism.Vector2(startPos.x + i, startPos.y + j))
            end
         end
         if owner:get(prism.components.WallKicker) and Game.kickmode == "Kicking" then
            local wallkick = prism.actions.WallKick
            local celltargethandler = CellTargetHandler(self.display, self, nearbyCells, wallkick)
            self.manager:push(celltargethandler)
         elseif owner:get(prism.components.PitStomper) and Game.kickmode == "Stomping" then
            local pitstomp = prism.actions.PitStomp
            local celltargethandler = CellTargetHandler(self.display, self, nearbyCells, pitstomp)
            self.manager:push(celltargethandler)
         end
      end
   end

   -- if action == "inventory" then
   --    local inventory = owner:get(prism.components.Inventory)
   --    if inventory then
   --       local inventoryState = InventoryState(self.display, decision, self.level, inventory)
   --       self.manager:push(inventoryState)
   --    end
   -- end

   -- if action == "pickup" then
   --    local target = self.level:query(prism.components.Item):at(owner:getPosition():decompose()):first()
   --    local pickup = prism.actions.Pickup(owner, target)
   --    if self.level:canPerform(pickup) then
   --       decision:setAction(pickup)
   --       return
   --    end
   -- end

   if action == "switch-kickmode" then
      if Game.kickmode == "Kicking" then
         Game.kickmode = "Stomping"
      else
         Game.kickmode = "Kicking"
      end

      prism.components.Log.addMessage(owner, "You're in a " .. string.lower(Game.kickmode) .. " mood!")
      return
   end

   -- Handle waiting
   if action == "wait" then
      decision:setAction(prism.actions.Wait(self.decision.actor))
      Game.turns = Game.turns + 1
   end
end

function GameLevelState:keyreleased(key)
   if key == "lshift" or key == "rshift" or key == "lctrl" or key == "rctrl" then keymode = "" end
end

-- - @param x integer
-- - @param y integer
-- - @param depth integer
-- function GameLevelState:setAlternateCell(x, y, depth)
--    local cell = self.level:getCell(x, y)
--    local altdrawable = cell:get(prism.components.AlternateDrawable)
--    if altdrawable then
--       if altdrawable.options["overhang"] and cell:getName() ~= self.level:getCell(x, y - 1):getName() then
--          local drawable = prism.components.Drawable(altdrawable.options["overhang"])
--          cell:give(drawable)
--       end

--       local ogDepth = 0
--       local ogString = "original"
--       for key, _ in pairs(altdrawable.options) do
--          local depthNum = tonumber(string.match(key, "%d+"))
--          if key:match("^original") and depthNum and depthNum > ogDepth and depthNum <= depth then
--             ogString = key
--             ogDepth = depthNum
--          end
--       end

--       local drawable = prism.components.Drawable(altdrawable.options[ogString])
--       cell:give(drawable)
--    end
-- end

return GameLevelState
