local utf8 = require "utf8"
local keybindings = require "keybindingschema"
require "helper"

-- tile indexes
local right_triangle = 17
local left_triangle = 18
local light_shade = 177
local box_vert = 180
local box_horiz = 197
local full_block = 220

-- upgrades
local selected_index = 1
local upgrades = {
   {
      text = "kick dmg",
      currentAmount = 0,
      levels = 5,
      amounts = { 2, 3, 4, 5, 6 },
      costs = { 1, 2, 2, 3, 4 },
      currentLevel = 0,
      selected = true,
   },
   {
      text = "kick dist",
      currentAmount = 0,
      levels = 5,
      amounts = { 4, 5, 6, 7, 8 },
      costs = { 2, 2, 3, 3, 5 },
      currentLevel = 0,
      selected = false,
   },
   {
      text = "wall kick",
      currentAmount = "-",
      levels = 1,
      amounts = { "-" },
      costs = { 3 },
      currentLevel = 0,
      selected = false,
   },
   {
      text = "stomp dmg",
      currentAmount = 0,
      levels = 5,
      amounts = { 2, 3, 4, 5, 6 },
      costs = { 1, 2, 2, 3, 4 },
      currentLevel = 0,
      selected = false,
   },
   {
      text = "stomp aoe dmg",
      currentAmount = 0,
      levels = 5,
      amounts = { 1, 2, 3, 4, 5 },
      costs = { 1, 2, 2, 3, 4 },
      currentLevel = 0,
      selected = false,
   },
   {
      text = "stomp aoe size",
      currentAmount = "-",
      levels = 3,
      amounts = { 1, 2, 3 },
      costs = { 3, 4, 5 },
      currentLevel = 0,
      selected = false,
   },
   {
      text = "pit stomp",
      currentAmount = "-",
      levels = 1,
      amounts = { "-" },
      costs = { 3 },
      currentLevel = 0,
      selected = false,
   },
   {
      text = "max hp",
      currentAmount = 0,
      levels = 5,
      amounts = { 15, 20, 25, 30, 35 },
      costs = { 2, 2, 2, 2, 2 },
      currentLevel = 0,
      selected = false,
   },
}

--- @class PauseState : GameState
--- @overload fun(display: Display, decision: ActionDecision, level: Level)
local PauseState = spectrum.GameState:extend "PauseState"

--- @param display Display
--- @param decision ActionDecision
--- @param level Level
function PauseState:__new(display, decision, level)
   self.display = display
   self.decision = decision
   self.level = level
end

--- @param previous LevelState
function PauseState:load(previous)
   self.previousState = previous
   self:GetCurrentInfo()
end

function PauseState:GetCurrentInfo()
   self.currentActor = self.previousState:getCurrentActor()
   -- kick damage
   local attacker = self.currentActor and self.currentActor:get(prism.components.Attacker)
   local kickDamage = upgrades[1].currentAmount
   if attacker then kickDamage = attacker.damage end
   upgrades[1].currentAmount = kickDamage
   local kickDamageLevel = IndexOf(upgrades[1].amounts, kickDamage)
   if kickDamageLevel then upgrades[1].currentLevel = kickDamageLevel end
   -- kick dist
   local kicker = self.currentActor and self.currentActor:get(prism.components.Kicker)
   local kickDistance = upgrades[2].currentAmount
   if kicker then kickDistance = kicker.distance end
   upgrades[2].currentAmount = kickDistance
   local kickDistanceLevel = IndexOf(upgrades[2].amounts, kickDistance)
   if kickDistanceLevel then upgrades[2].currentLevel = kickDistanceLevel end
   -- wall kick
   local wallKicker = self.currentActor and self.currentActor:get(prism.components.WallKicker)
   if wallKicker then upgrades[3].currentLevel = 1 end
   -- stomp damage
   local stompDamage = upgrades[4].currentAmount
   if attacker then stompDamage = attacker.damage end
   upgrades[4].currentAmount = stompDamage
   local stompDamageLevel = IndexOf(upgrades[4].amounts, stompDamage)
   if stompDamageLevel then upgrades[4].currentLevel = stompDamageLevel end
   -- stomp aoe damage
   local stompAOE = self.currentActor and self.currentActor:get(prism.components.StompAOE)
   local stompAOEDamage = upgrades[5].currentAmount
   if stompAOE then stompAOEDamage = stompAOE.damage end
   upgrades[5].currentAmount = stompAOEDamage
   local stompAOEDamageLevel = IndexOf(upgrades[5].amounts, stompAOEDamage)
   if stompAOEDamageLevel then upgrades[5].currentLevel = stompAOEDamageLevel end
   -- stomp aoe size
   local stompAOESize = upgrades[6].currentAmount
   if stompAOE then stompAOESize = stompAOE.size end
   upgrades[6].currentAmount = stompAOESize
   local stompAOESizeLevel = IndexOf(upgrades[6].amounts, stompAOESize)
   if stompAOESizeLevel then upgrades[6].currentLevel = stompAOESizeLevel end
   -- pit stomp
   local pitStomper = self.currentActor and self.currentActor:get(prism.components.pitStomper)
   if pitStomper then upgrades[7].currentLevel = 1 end
   -- maxHP
   local health = self.currentActor and self.currentActor:get(prism.components.Health)
   local maxHP = upgrades[8].currentAmount
   if health then maxHP = health:getMaxHP() end
   upgrades[8].currentAmount = maxHP
   local maxHPLevel = IndexOf(upgrades[8].amounts, maxHP)
   if maxHPLevel then upgrades[8].currentLevel = maxHPLevel end
end

function PauseState:draw()
   -- self.previousState:draw()
   local midpoint = math.floor(self.display.height / 2)
   local midwidth = math.floor(self.display.width / 2)
   self.display:clear()
   local health = self.currentActor and self.currentActor:get(prism.components.Health)
   local healthString = ""
   if health then
      healthString = string.format("HP:" .. health.hp .. "/" .. health:getMaxHP())
      self.display:putString(1, 1, healthString)
   end
   local depthString = string.format("Depth:" .. Game.depth)
   self.display:putString(1, 2, depthString)
   self.display:putString(math.max(#healthString, #depthString) + 2, 1, "LVL:" .. Game.level, GREEN)
   self.display:putString(
      math.max(#healthString, #depthString) + 2,
      2,
      "XP:" .. Game.xp .. "/" .. Game.levelThreshold,
      CYAN
   )
   -- working on level up screen
   for index, upgrade in ipairs(upgrades) do
      local fg = DARKGRAY
      local bg = nil
      if upgrade.selected then fg = WHITE end
      self.display:putString(midwidth - 19, midpoint - 7 + (index - 1) * 2, upgrade.text, fg, bg, nil, "right", 14)
      self.display:putString(
         midwidth - 4,
         midpoint - 7 + (index - 1) * 2,
         tostring(upgrade.currentAmount),
         fg,
         bg,
         nil,
         "center",
         3
      )
      -- levels
      local midChar = light_shade
      if upgrade.levels == 1 and upgrade.currentLevel >= 1 then
         midChar = full_block
      elseif upgrade.levels >= 2 and upgrade.levels < 4 and upgrade.currentLevel >= 2 then
         midChar = full_block
      elseif upgrade.levels >= 4 and upgrade.currentLevel >= 3 then
         midChar = full_block
      end
      self.display:put(midwidth + 4, midpoint - 7 + (index - 1) * 2, midChar, fg, bg, nil)
      local midLeftChar = light_shade
      if upgrade.levels >= 2 then
         if upgrade.levels < 4 and upgrade.currentLevel >= 1 then
            midLeftChar = full_block
         elseif upgrade.levels >= 4 and upgrade.currentLevel >= 2 then
            midLeftChar = full_block
         end
         self.display:put(midwidth + 3, midpoint - 7 + (index - 1) * 2, midLeftChar, fg, bg, nil)
      end
      local midRightChar = light_shade
      if upgrade.levels >= 3 then
         if upgrade.levels < 4 and upgrade.currentLevel >= 3 then
            midRightChar = full_block
         elseif upgrade.currentLevel >= 4 then
            midRightChar = full_block
         end
         self.display:put(midwidth + 5, midpoint - 7 + (index - 1) * 2, midRightChar, fg, bg, nil)
      end
      local leftChar = light_shade
      if upgrade.levels >= 4 then
         if upgrade.currentLevel >= 1 then leftChar = full_block end
         self.display:put(midwidth + 2, midpoint - 7 + (index - 1) * 2, leftChar, fg, bg, nil)
      end
      local rightChar = light_shade
      if upgrade.levels >= 5 then
         if upgrade.currentLevel >= 5 then rightChar = full_block end
         self.display:put(midwidth + 6, midpoint - 7 + (index - 1) * 2, rightChar, fg, bg, nil)
      end

      local nxtAmt = "MAX"
      if upgrade.currentLevel < #upgrade.amounts then nxtAmt = tostring(upgrade.amounts[upgrade.currentLevel + 1]) end
      self.display:putString(midwidth + 10, midpoint - 7 + (index - 1) * 2, nxtAmt, fg, bg, nil, "center", 3)
      local costAmt = "100"
      if upgrade.currentLevel < #upgrade.costs then costAmt = tostring(upgrade.costs[upgrade.currentLevel + 1]) end
      local costColor = RED
      if tonumber(costAmt) <= 1 then costColor = GREEN end
      if costAmt == "100" then
         costAmt = "-"
         costColor = fg
      end
      self.display:putString(midwidth + 14, midpoint - 7 + (index - 1) * 2, costAmt, costColor, bg, nil, "center", 5)

      if upgrade.selected then
         local left_tri_x = midwidth + 3
         local right_tri_x = midwidth + 5
         if upgrade.levels == 3 or upgrade.levels == 2 then
            left_tri_x = left_tri_x - 1
            right_tri_x = right_tri_x + 1
         elseif upgrade.levels == 5 or upgrade.levels == 4 then
            left_tri_x = left_tri_x - 2
            right_tri_x = right_tri_x + 2
         end
         self.display:put(left_tri_x, midpoint - 7 + (index - 1) * 2, left_triangle, fg, bg, nil)
         self.display:put(right_tri_x, midpoint - 7 + (index - 1) * 2, right_triangle, fg, bg, nil)
         for j = midwidth - 19, midwidth + 18, 1 do
            self.display:putBG(j, midpoint - 7 + (index - 1) * 2, DARKGRAY, nil)
         end
      end
   end

   self.display:putLine(
      midwidth - 20,
      midpoint - 7,
      midwidth - 20,
      midpoint + 7,
      box_vert,
      prism.Color4.WHITE,
      nil,
      nil
   )
   self.display:putLine(midwidth - 5, midpoint - 7, midwidth - 5, midpoint + 7, box_vert, prism.Color4.WHITE, nil, nil)
   self.display:putLine(midwidth - 1, midpoint - 7, midwidth - 1, midpoint + 7, box_vert, prism.Color4.WHITE, nil, nil)
   self.display:putLine(midwidth + 9, midpoint - 7, midwidth + 9, midpoint + 7, box_vert, prism.Color4.WHITE, nil, nil)
   self.display:putLine(
      midwidth + 13,
      midpoint - 7,
      midwidth + 13,
      midpoint + 7,
      box_vert,
      prism.Color4.WHITE,
      nil,
      nil
   )
   self.display:putLine(
      midwidth + 19,
      midpoint - 7,
      midwidth + 19,
      midpoint + 7,
      box_vert,
      prism.Color4.WHITE,
      nil,
      nil
   )
   self.display:putLine(midwidth - 19, midpoint - 8, midwidth + 18, midpoint - 8, box_horiz, WHITE, nil, nil)
   self.display:putLine(midwidth - 19, midpoint + 8, midwidth + 18, midpoint + 8, box_horiz, WHITE, nil, nil)

   self.display:putString(1, midpoint + 10, "[wasd] to select & spend", WHITE, nil, nil, "center", self.display.width)
   self.display:putString(
      1,
      midpoint + 11,
      "[esc] to return",
      prism.Color4.LIGHTGRAY,
      nil,
      nil,
      "center",
      self.display.width
   )
   self.display:putString(
      1,
      midpoint + 12,
      "[r] to restart",
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "center",
      self.display.width
   )
   self.display:putString(
      1,
      midpoint + 13,
      "[q] to quit",
      prism.Color4.DARKGRAY,
      nil,
      nil,
      "center",
      self.display.width
   )

   self.display:draw()
end

function PauseState:keypressed(key)
   local binding = keybindings:keypressed(key)
   if binding == "pause" then self.manager:pop() end
   local action = keybindings:keypressed(key, "paused")
   if action == "restart" then
      love.event.restart()
   elseif action == "quit" then
      love.event.quit()
   end
end

return PauseState
