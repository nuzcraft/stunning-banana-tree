-- stylua: ignore
local wallKickTarget = prism.Target():with(prism.components.Collider)
    :with(prism.components.Opaque)
    :range(1)
    :sensed()
-- collider + opaque is a stand-in for walls for now

local Log = prism.components.Log
local Name = prism.components.Name
local sf = string.format

--- @class WallKickAction : Action
local WallKick = prism.Action:extend "WallKickAction"
WallKick.name = "Kick"
WallKick.targets = { wallKickTarget }

function WallKick:perform(level, kicked)
   Log.addMessage(self.owner, sf("You kick the %s and it crumbles.", Name.lower(kicked)))
end
