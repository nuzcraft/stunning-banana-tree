local keybindings = require "keybindingschema"
local Name = prism.components.Name
local GeneralTargetHandler = require "gamestates.targethandlers.generaltargethandler"

--- @class InventoryActionState : GameState
--- @field decision ActionDecision
--- @field previousState GameState
--- @overload fun(display: Display, decision: ActionDecision, level: Level, item: Actor)
local InventoryActionState = spectrum.GameState:extend "InventoryActionState"

--- @param display Display
--- @param decision ActionDecision
--- @param level Level
--- @param item Actor
function InventoryActionState:__new(display, decision, level, item)
   self.display = display
   self.decision = decision
   self.level = level
   self.item = item

   self.actions = {}

   for _, Action in ipairs(self.decision.actor:getActions()) do
      if Action:validateTarget(1, level, self.decision.actor, item) and not Action:isAbstract() then
         table.insert(self.actions, Action)
      end
   end
end

function InventoryActionState:load(previous)
   --- @cast previous InventoryState
   self.previousState = previous.previousState
end

function InventoryActionState:draw()
   self.previousState:draw()
   self.display:clear()
   self.display:putString(1, 4, Name.get(self.item), nil, nil, 2, "right")

   for i, action in ipairs(self.actions) do
      local letter = string.char(96 + i)
      local name = string.gsub(action.name or action.className, "Action", "")
      self.display:putString(1, 4 + i, string.format("[%s] %s", letter, name), nil, nil, nil, "right")
   end
   self.display:draw()
end

function InventoryActionState:keypressed(key)
   for i, Action in ipairs(self.actions) do
      -- print(key, string.char(i + 96))
      if key == string.char(i + 96) then
         self.decision:trySetAction(Action(self.decision.actor, self.item), self.level)
         if self.decision:validateResponse() then
            self.manager:pop()
            return
         end
         self.selectedAction = Action
         self.targets = { self.item }
         for i = Action:getNumTargets(), 2, -1 do
            self.manager:push(
               GeneralTargetHandler(
                  self.display,
                  self.previousState,
                  self.targets,
                  Action:getTargetObject(i),
                  self.targets
               )
            )
         end
      end
   end
   local binding = keybindings:keypressed(key)
   if binding == "inventory" or binding == "return" then self.manager:pop() end
end

function InventoryActionState:resume()
   if self.targets then
      local action = self.selectedAction(self.decision.actor, unpack(self.targets))
      local success, err = self.level:canPerform(action)
      if success then
         self.decision:setAction(action)
      else
         prism.components.Log.addMessage(self.decision.actor, err) -- this doesn't work
      end
      self.manager:pop()
   end
end

return InventoryActionState
