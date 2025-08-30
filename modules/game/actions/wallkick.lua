local WallKickTarget =
   prism.Target():isPrototype(prism.Cell):with(prism.components.Collider):with(prism.components.Opaque)
local Log = prism.components.Log
local Name = prism.components.Name
local sf = string.format

--- @class WallKick : Action
--- @overload fun(owner: Actor, attacked: Cell): WallKick
local WallKick = prism.Action:extend("WallKick")
WallKick.name = "Attack"
WallKick.targets = { WallKickTarget }
WallKick.requiredComponents = { prism.components.WallKicker }

--- @param level Level
--- @param attacked Cell
function WallKick:perform(level, attacked)
   local WallKicker = self.owner:expect(prism.components.WallKicker)
   print(Name.get(self.owner) .. "is kicking")
   -- local damage = prism.actions.Damage(attacked, attacker.damage)
   -- if level:canPerform(damage) then
   --    level:perform(damage)
   --    local dmgstr = ""
   --    if damage.dealt then dmgstr = sf("Dealing %i damage.", damage.dealt) end
   --    local attackName = Name.lower(attacked)
   --    local ownerName = Name.lower(self.owner)
   --    Log.addMessage(self.owner, sf("You attack the %s. %s", attackName, dmgstr))
   --    Log.addMessage(attacked, sf("The %s attacks you! %s", ownerName, dmgstr))
   --    Log.addMessageSensed(level, self, sf("The %s attacks the %s. %s", ownerName, attackName, dmgstr))
   -- end
end

return WallKick
