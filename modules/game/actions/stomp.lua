local StompTarget = prism.Target():with(prism.components.Collider):range(1):sensed()
local Log = prism.components.Log
local Name = prism.components.Name
local sf = string.format

--- @class StompAction : Action
local Stomp = prism.Action:extend "StompAction"
Stomp.name = "Stomp"
Stomp.targets = { StompTarget }
Stomp.requiredComponents = {
   prism.components.Controller,
   prism.components.Stomper,
   prism.components.Attacker,
}

function Stomp:canPerform(level)
   return true
end

--- @param level Level
--- @param stomped Actor
function Stomp:perform(level, stomped)
   local stomper = self.owner:get(prism.components.Stomper)
   if stomper then
      local damageAmount = self.owner:get(prism.components.Attacker).damage + stomper.bonusDamage
      local damage = prism.actions.Damage(stomped, damageAmount)
      local stompstr = sf("You stomp the %s.", Name.lower(stomped))
      local stompstr2 = sf("The %s stomps you!", Name.lower(self.owner))
      local stompstr3 = sf("The %s stomps the %s.", Name.lower(self.owner), Name.lower(stomped))
      local dmgstr = ""
      local deadstr = ""
      if level:canPerform(damage) then
         level:perform(damage)
         if damage.dealt then dmgstr = sf(" Dealing %i damage.", damage.dealt) end
         if damage.fatal then deadstr = " It died." end
      end
      -- aoe stuff
      local pos = stomped:getPosition()
      local aoedmgstr = ""
      if stomper.aoeRadius > 0 and pos then
         local aoeDamageAmount = 0
         for j = pos.y - stomper.aoeRadius, pos.y + stomper.aoeRadius, 1 do
            for i = pos.x - stomper.aoeRadius, pos.x + stomper.aoeRadius, 1 do
               local target = level:query(prism.components.Collider):at(i, j):first()
               if target and target ~= self.owner and target ~= stomped then
                  aoeDamageAmount = stomper.aoeDamage
                  if aoeDamageAmount > 0 then
                     local aoeDamage = prism.actions.Damage(target, aoeDamageAmount)
                     if level:canPerform(aoeDamage) then level:perform(aoeDamage) end
                  end
               end
            end
         end
         if aoeDamageAmount > 0 then aoedmgstr = "The stomp-wave damaged those nearby." end
      end

      if Name.get(self.owner) == "Player" then Game.stats.numStomps = Game.stats.numStomps + 1 end

      Log.addMessage(self.owner, stompstr .. dmgstr .. deadstr)
      Log.addMessage(stomped, stompstr2 .. dmgstr .. deadstr)
      Log.addMessageSensed(level, self, stompstr3 .. dmgstr .. deadstr)
      if #aoedmgstr > 1 then Log.addMessage(self.owner, aoedmgstr) end

      local openContainer = prism.actions.OpenContainer(self.owner, stomped)
      if level:canPerform(openContainer) then level:perform(openContainer) end

      local consume = prism.actions.Consume(self.owner, stomped)
      if level:canPerform(consume) then
         Log.addMessage(self.owner, sf("The %s explodes. You feel better.", Name.lower(stomped)))
         Log.addMessageSensed(
            level,
            consume,
            sf("The %s explodes. The %s looks refreshed.", Name.lower(stomped), Name.lower(self.owner))
         )
         level:perform(consume)
      end
   end
end

return Stomp
