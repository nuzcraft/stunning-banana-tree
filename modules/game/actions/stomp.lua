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
   if level:canPerform(damage) then
      level:perform(damage)

      local dmgstr = ""
      if damage.dealt then dmgstr = sf("Dealing %i damage.", damage.dealt) end

      local stompName = Name.lower(stomped)
      local ownerName = Name.lower(self.owner)
      Log.addMessage(self.owner, sf("You stomp the %s. %s", stompName, dmgstr))
      Log.addMessage(stomped, sf("The %s stomps you! %s", ownerName, dmgstr))
      Log.addMessageSensed(level, self, sf("The %s stomps the %s. %s", ownerName, stompName, dmgstr))
   end

   local openContainer = prism.actions.OpenContainer(self.owner, stomped)
   if level:canPerform(openContainer) then
      local stompName = Name.lower(stomped)
      local ownerName = Name.lower(self.owner)
      Log.addMessage(self.owner, sf("You stomp the %s.", stompName))
      Log.addMessage(stomped, sf("The %s stomps you!", ownerName))
      Log.addMessageSensed(level, self, sf("The %s stomps the %s.", ownerName, stompName))
      level:perform(openContainer)
   end

   local consume = prism.actions.Consume(self.owner, stomped)
   if level:canPerform(consume) then
      local stompName = Name.lower(stomped)
      local ownerName = Name.lower(self.owner)
      Log.addMessage(self.owner, sf("You stomp the %s.", stompName))
      Log.addMessage(stomped, sf("The %s stomps you!", ownerName))
      Log.addMessageSensed(level, self, sf("The %s stomps the %s.", ownerName, stompName))
      level:perform(consume)
   end
end

return Stomp
