local utf8 = require "utf8"
local keybindings = require "keybindingschema"
require "helper"

-- tile indexes
local right_triangle = 17
local left_triangle = 18
local light_shade = 177
local medium_shade = 178
local box_vert = 180
local box_down_left = 192
local box_up_right = 193
local box_up_horiz = 194
local box_down_horiz = 195
local box_horiz = 197
local box_up_left = 218
local box_down_right = 219
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
      newLevel = 0,
   },
   {
      text = "kick dist",
      currentAmount = 0,
      levels = 5,
      amounts = { 4, 5, 6, 7, 8 },
      costs = { 2, 2, 3, 3, 5 },
      currentLevel = 0,
      selected = false,
      newLevel = 0,
   },
   {
      text = "wall kick",
      currentAmount = "-",
      levels = 1,
      amounts = { "-" },
      costs = { 3 },
      currentLevel = 0,
      selected = false,
      newLevel = 0,
   },
   {
      text = "stomp dmg",
      currentAmount = 0,
      levels = 5,
      amounts = { 2, 3, 4, 5, 6 },
      costs = { 1, 2, 2, 3, 4 },
      currentLevel = 0,
      selected = false,
      newLevel = 0,
   },
   {
      text = "stomp aoe dmg",
      currentAmount = 0,
      levels = 5,
      amounts = { 1, 2, 3, 4, 5 },
      costs = { 1, 2, 2, 3, 4 },
      currentLevel = 0,
      selected = false,
      newLevel = 0,
   },
   {
      text = "stomp aoe size",
      currentAmount = 0,
      levels = 3,
      amounts = { 1, 2, 3 },
      costs = { 3, 4, 5 },
      currentLevel = 0,
      selected = false,
      newLevel = 0,
   },
   {
      text = "pit stomp",
      currentAmount = "-",
      levels = 1,
      amounts = { "-" },
      costs = { 3 },
      currentLevel = 0,
      selected = false,
      newLevel = 0,
   },
   {
      text = "max hp",
      currentAmount = 0,
      levels = 5,
      amounts = { 15, 20, 25, 30, 35 },
      costs = { 2, 2, 2, 2, 2 },
      currentLevel = 0,
      selected = false,
      newLevel = 0,
   },
}

local skillPointsAvailable = 0
local skillPointsSpending = 0

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
   local kicker = self.currentActor and self.currentActor:get(prism.components.Kicker)
   local kickDamage = upgrades[1].currentAmount
   if attacker and kicker then kickDamage = attacker.damage + kicker.bonusDamage end
   upgrades[1].currentAmount = kickDamage
   local kickDamageLevel = IndexOf(upgrades[1].amounts, kickDamage)
   if kickDamageLevel then upgrades[1].currentLevel = kickDamageLevel end
   -- kick dist
   local kickDistance = upgrades[2].currentAmount
   if kicker then kickDistance = kicker.distance end
   upgrades[2].currentAmount = kickDistance
   local kickDistanceLevel = IndexOf(upgrades[2].amounts, kickDistance)
   if kickDistanceLevel then upgrades[2].currentLevel = kickDistanceLevel end
   -- wall kick
   local wallKicker = self.currentActor and self.currentActor:get(prism.components.WallKicker)
   if wallKicker then upgrades[3].currentLevel = 1 end
   -- stomp damage
   local stomper = self.currentActor and self.currentActor:get(prism.components.Stomper)
   local stompDamage = upgrades[4].currentAmount
   if attacker and stomper then stompDamage = attacker.damage + stomper.bonusDamage end
   upgrades[4].currentAmount = stompDamage
   local stompDamageLevel = IndexOf(upgrades[4].amounts, stompDamage)
   if stompDamageLevel then upgrades[4].currentLevel = stompDamageLevel end
   -- stomp aoe damage
   local stompAOEDamage = upgrades[5].currentAmount
   if stomper then stompAOEDamage = stomper.aoeDamage end
   upgrades[5].currentAmount = stompAOEDamage
   local stompAOEDamageLevel = IndexOf(upgrades[5].amounts, stompAOEDamage)
   if stompAOEDamageLevel then upgrades[5].currentLevel = stompAOEDamageLevel end
   -- stomp aoe size
   local stompAOESize = upgrades[6].currentAmount
   if stomper then stompAOESize = stomper.aoeRadius end
   upgrades[6].currentAmount = stompAOESize
   local stompAOESizeLevel = IndexOf(upgrades[6].amounts, stompAOESize)
   if stompAOESizeLevel then upgrades[6].currentLevel = stompAOESizeLevel end
   -- pit stomp
   local pitStomper = self.currentActor and self.currentActor:get(prism.components.PitStomper)
   if pitStomper then upgrades[7].currentLevel = 1 end
   -- maxHP
   local health = self.currentActor and self.currentActor:get(prism.components.Health)
   local maxHP = upgrades[8].currentAmount
   if health then maxHP = health:getMaxHP() end
   upgrades[8].currentAmount = maxHP
   local maxHPLevel = IndexOf(upgrades[8].amounts, maxHP)
   if maxHPLevel then upgrades[8].currentLevel = maxHPLevel end
   skillPointsAvailable = Game.skillPoints
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
   self.display:putString(
      1,
      midpoint - 12,
      "SKILL POINTS: " .. skillPointsAvailable,
      GREEN,
      nil,
      nil,
      "center",
      self.display.width
   )
   local boxRect = { x = midwidth - 20, y = midpoint - 8, w = 40, h = 17 }
   self.display:putString(midwidth - 19, midpoint - 9, "skill", nil, nil, nil, "center", 14)
   self.display:putString(midwidth - 4, midpoint - 9, "amt", nil, nil, nil, "center", 3)
   self.display:putString(midwidth, midpoint - 9, "progress", nil, nil, nil, "center", 9)
   self.display:putString(midwidth + 10, midpoint - 9, "nxt", nil, nil, nil, "center", 3)
   self.display:putString(midwidth + 14, midpoint - 9, "cost", nil, nil, nil, "center", 5)
   for index, upgrade in ipairs(upgrades) do
      local fg = DARKGRAY
      local bg = nil
      local yPos = midpoint - 7 + (index - 1) * 2
      if upgrade.selected then fg = WHITE end
      self.display:putString(midwidth - 19, yPos, upgrade.text, fg, bg, nil, "right", 14)
      local curAmt = tostring(upgrade.currentAmount)
      local curAmtFG = fg
      if upgrade.newLevel > 0 then
         curAmt = tostring(upgrade.amounts[upgrade.currentLevel + upgrade.newLevel])
         curAmtFG = GREEN
      end
      self.display:putString(midwidth - 4, yPos, curAmt, curAmtFG, bg, nil, "center", 3)
      -- levels
      local midChar = light_shade
      local midFG = fg
      if upgrade.levels == 1 then
         if upgrade.currentLevel >= 1 then
            midChar = full_block
         elseif upgrade.newLevel >= 1 then
            midChar = medium_shade
            midFG = GREEN
         end
      elseif upgrade.levels >= 2 and upgrade.levels < 4 then
         if upgrade.currentLevel >= 2 then
            midChar = full_block
         elseif upgrade.currentLevel + upgrade.newLevel >= 2 then
            midChar = medium_shade
            midFG = GREEN
         end
      elseif upgrade.levels >= 4 then
         if upgrade.currentLevel >= 3 then
            midChar = full_block
         elseif upgrade.currentLevel + upgrade.newLevel >= 3 then
            midChar = medium_shade
            midFG = GREEN
         end
      end
      self.display:put(midwidth + 4, yPos, midChar, midFG, bg, nil)
      local midLeftChar = light_shade
      local midLeftFG = fg
      if upgrade.levels >= 2 then
         if upgrade.levels < 4 then
            if upgrade.currentLevel >= 1 then
               midLeftChar = full_block
            elseif upgrade.currentLevel + upgrade.newLevel >= 1 then
               midLeftChar = medium_shade
               midLeftFG = GREEN
            end
         elseif upgrade.levels >= 4 then
            if upgrade.currentLevel >= 2 then
               midLeftChar = full_block
            elseif upgrade.currentLevel + upgrade.newLevel >= 2 then
               midLeftChar = medium_shade
               midLeftFG = GREEN
            end
         end
         self.display:put(midwidth + 3, yPos, midLeftChar, midLeftFG, bg, nil)
      end
      local midRightChar = light_shade
      local midRightFG = fg
      if upgrade.levels >= 3 then
         if upgrade.levels < 4 then
            if upgrade.currentLevel >= 3 then
               midRightChar = full_block
            elseif upgrade.currentLevel + upgrade.newLevel >= 3 then
               midRightChar = medium_shade
               midRightFG = GREEN
            end
         elseif upgrade.currentLevel >= 4 then
            midRightChar = full_block
         elseif upgrade.currentLevel + upgrade.newLevel >= 4 then
            midRightChar = medium_shade
            midRightFG = GREEN
         end
         self.display:put(midwidth + 5, yPos, midRightChar, midRightFG, bg, nil)
      end
      local leftChar = light_shade
      local leftFG = fg
      if upgrade.levels >= 4 then
         if upgrade.currentLevel >= 1 then
            leftChar = full_block
         elseif upgrade.currentLevel + upgrade.newLevel >= 1 then
            leftChar = medium_shade
            leftFG = GREEN
         end
         self.display:put(midwidth + 2, yPos, leftChar, leftFG, bg, nil)
      end
      local rightChar = light_shade
      local rightFG = fg
      if upgrade.levels >= 5 then
         if upgrade.currentLevel >= 5 then
            rightChar = full_block
         elseif upgrade.currentLevel + upgrade.newLevel >= 5 then
            rightChar = medium_shade
            rightFG = GREEN
         end
         self.display:put(midwidth + 6, yPos, rightChar, rightFG, bg, nil)
      end

      local nxtAmt = "MAX"
      if upgrade.currentLevel + upgrade.newLevel < #upgrade.amounts then
         nxtAmt = tostring(upgrade.amounts[upgrade.currentLevel + upgrade.newLevel + 1])
      end
      self.display:putString(midwidth + 10, yPos, nxtAmt, fg, bg, nil, "center", 3)
      local costAmt = "100"
      if upgrade.currentLevel + upgrade.newLevel < #upgrade.costs then
         costAmt = tostring(upgrade.costs[upgrade.currentLevel + upgrade.newLevel + 1])
      end
      local costColor = RED
      if tonumber(costAmt) <= skillPointsAvailable then costColor = GREEN end
      if costAmt == "100" then
         costAmt = "-"
         costColor = fg
      end
      self.display:putString(midwidth + 14, yPos, costAmt, costColor, bg, nil, "center", 5)

      if upgrade.selected then
         local left_tri_x = midwidth + 1
         local right_tri_x = midwidth + 7
         self.display:put(left_tri_x, yPos, left_triangle, fg, bg, nil)
         self.display:put(right_tri_x, yPos, right_triangle, fg, bg, nil)
         for j = midwidth - 19, midwidth + 18, 1 do
            self.display:putBG(j, yPos, DARKGRAY, nil)
         end
      end
   end

   self.display:putLine(midwidth - 20, midpoint - 7, midwidth - 20, midpoint + 7, box_vert, WHITE, nil, nil)
   self.display:putLine(midwidth - 5, midpoint - 7, midwidth - 5, midpoint + 7, box_vert, WHITE, nil, nil)
   self.display:putLine(midwidth - 1, midpoint - 7, midwidth - 1, midpoint + 7, box_vert, WHITE, nil, nil)
   self.display:putLine(midwidth + 9, midpoint - 7, midwidth + 9, midpoint + 7, box_vert, WHITE, nil, nil)
   self.display:putLine(midwidth + 13, midpoint - 7, midwidth + 13, midpoint + 7, box_vert, WHITE, nil, nil)
   self.display:putLine(midwidth + 19, midpoint - 7, midwidth + 19, midpoint + 7, box_vert, WHITE, nil, nil)
   self.display:putLine(midwidth - 19, midpoint - 8, midwidth + 18, midpoint - 8, box_horiz, WHITE, nil, nil)
   self.display:putLine(midwidth - 19, midpoint + 8, midwidth + 18, midpoint + 8, box_horiz, WHITE, nil, nil)
   self.display:put(boxRect.x, boxRect.y, box_down_right, WHITE, nil, nil)
   self.display:put(boxRect.x + boxRect.w - 1, boxRect.y, box_down_left, WHITE, nil, nil)
   self.display:put(boxRect.x, boxRect.y + boxRect.h - 1, box_up_right, WHITE, nil, nil)
   self.display:put(boxRect.x + boxRect.w - 1, boxRect.y + boxRect.h - 1, box_up_left, WHITE, nil, nil)
   self.display:put(boxRect.x + 15, boxRect.y, box_down_horiz, WHITE, nil, nil)
   self.display:put(boxRect.x + 19, boxRect.y, box_down_horiz, WHITE, nil, nil)
   self.display:put(boxRect.x + 29, boxRect.y, box_down_horiz, WHITE, nil, nil)
   self.display:put(boxRect.x + 33, boxRect.y, box_down_horiz, WHITE, nil, nil)
   self.display:put(boxRect.x + 15, boxRect.y + boxRect.h - 1, box_up_horiz, WHITE, nil, nil)
   self.display:put(boxRect.x + 19, boxRect.y + boxRect.h - 1, box_up_horiz, WHITE, nil, nil)
   self.display:put(boxRect.x + 29, boxRect.y + boxRect.h - 1, box_up_horiz, WHITE, nil, nil)
   self.display:put(boxRect.x + 33, boxRect.y + boxRect.h - 1, box_up_horiz, WHITE, nil, nil)

   self.display:putString(1, midpoint + 10, "[wasd] to select & spend", WHITE, nil, nil, "center", self.display.width)
   self.display:putString(1, midpoint + 11, "[esc] to return", LIGHTGRAY, nil, nil, "center", self.display.width)
   self.display:putString(1, midpoint + 12, "[r] to restart", DARKGRAY, nil, nil, "center", self.display.width)
   self.display:putString(1, midpoint + 13, "[q] to quit", DARKGRAY, nil, nil, "center", self.display.width)

   self.display:draw()
end

function PauseState:keypressed(key)
   local binding = keybindings:keypressed(key)
   if binding == "pause" then
      -- kick damage
      local kickUPG = upgrades[1]
      if kickUPG.newLevel > 0 then
         local newAMT = kickUPG.amounts[kickUPG.currentLevel + kickUPG.newLevel]
         local kicker = self.currentActor:get(prism.components.Kicker)
         local attacker = self.currentActor:get(prism.components.Attacker)
         if kicker and attacker then kicker.bonusDamage = newAMT - attacker.damage end
         kickUPG.newLevel = 0
      end
      -- kick dist
      local kickDistUPG = upgrades[2]
      if kickDistUPG.newLevel > 0 then
         local newAMT = kickDistUPG.amounts[kickDistUPG.currentLevel + kickDistUPG.newLevel]
         local kicker = self.currentActor:get(prism.components.Kicker)
         if kicker then kicker.distance = newAMT end
         kickDistUPG.newLevel = 0
      end
      -- wall kick
      local wallkickUPG = upgrades[3]
      if wallkickUPG.newLevel > 0 then
         self.currentActor:give(prism.components.WallKicker())
         wallkickUPG.newLevel = 0
      end
      -- stomp damage
      local stompUPG = upgrades[4]
      if stompUPG.newLevel > 0 then
         local newAMT = stompUPG.amounts[stompUPG.currentLevel + stompUPG.newLevel]
         local stomper = self.currentActor:get(prism.components.Stomper)
         local attacker = self.currentActor:get(prism.components.Attacker)
         if stomper and attacker then stomper.bonusDamage = newAMT - attacker.damage end
         stompUPG.newLevel = 0
      end
      -- stomp aoe dmg
      local stompAOEDmgUPG = upgrades[5]
      if stompAOEDmgUPG.newLevel > 0 then
         local newAMT = stompAOEDmgUPG.amounts[stompAOEDmgUPG.currentLevel + stompAOEDmgUPG.newLevel]
         local stomper = self.currentActor:get(prism.components.Stomper)
         if stomper then stomper.aoeDamage = newAMT end
         stompAOEDmgUPG.newLevel = 0
      end
      -- stomp aoe size
      local stompAOESizeUPG = upgrades[6]
      if stompAOESizeUPG.newLevel > 0 then
         local newAMT = stompAOESizeUPG.amounts[stompAOESizeUPG.currentLevel + stompAOESizeUPG.newLevel]
         local stomper = self.currentActor:get(prism.components.Stomper)
         if stomper then stomper.aoeRadius = newAMT end
         stompAOESizeUPG.newLevel = 0
      end
      -- pit stomp
      local pitstompUPG = upgrades[7]
      if pitstompUPG.newLevel > 0 then
         self.currentActor:give(prism.components.PitStomper())
         pitstompUPG.newLevel = 0
      end
      -- max health
      local healthUPG = upgrades[8]
      if healthUPG.newLevel > 0 then
         local newAMT = healthUPG.amounts[healthUPG.currentLevel + healthUPG.newLevel]
         local health = self.currentActor:get(prism.components.Health)
         if health then
            local diff = newAMT - health:getMaxHP()
            health:setMaxHP(newAMT)
            if diff > 0 then health:heal(diff) end
         end
         healthUPG.newLevel = 0
      end
      Game.skillPoints = Game.skillPoints - skillPointsSpending
      skillPointsSpending = 0
      self.manager:pop()
   end
   local action = keybindings:keypressed(key, "paused")
   if action == "restart" then
      love.event.restart()
   elseif action == "quit" then
      love.event.quit()
   elseif action == "move down" then
      if selected_index < #upgrades then
         upgrades[selected_index].selected = false
         selected_index = selected_index + 1
         upgrades[selected_index].selected = true
      end
   elseif action == "move up" then
      if selected_index > 1 then
         upgrades[selected_index].selected = false
         selected_index = selected_index - 1
         upgrades[selected_index].selected = true
      end
   elseif action == "move right" then
      local upg = upgrades[selected_index]
      if upg.currentLevel + upg.newLevel < upg.levels then
         local cost = upg.costs[upg.currentLevel + upg.newLevel + 1]
         if cost <= skillPointsAvailable then
            upg.newLevel = upg.newLevel + 1
            skillPointsAvailable = skillPointsAvailable - cost
            skillPointsSpending = skillPointsSpending + cost
         end
      end
   elseif action == "move left" then
      local upg = upgrades[selected_index]
      if upg.newLevel > 0 then
         local cost = upg.costs[upg.currentLevel + upg.newLevel]
         if cost <= skillPointsSpending then
            upg.newLevel = upg.newLevel - 1
            skillPointsAvailable = skillPointsAvailable + cost
            skillPointsSpending = skillPointsSpending - cost
         end
      end
   end
end

return PauseState
