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
}

function Stomp:canPerform(level)
   return true
end

--- @param level Level
--- @param stomped Actor
function Stomp:perform(level, stomped)
   local damage = prism.actions.Damage(stomped, 1)
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

   if Name.get(self.owner) == "Player" then Game.stats.numStomps = Game.stats.numStomps + 1 end

   Log.addMessage(self.owner, stompstr .. dmgstr .. deadstr)
   Log.addMessage(stomped, stompstr2 .. dmgstr .. deadstr)
   Log.addMessageSensed(level, self, stompstr3 .. dmgstr .. deadstr)

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

return Stomp
