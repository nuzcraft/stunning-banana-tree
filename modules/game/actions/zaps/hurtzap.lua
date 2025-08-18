-- stylua: ignore
local HurtZappableTarget = prism.InventoryTarget(prism.components.HurtZappable)
    :inInventory()

-- stylua: ignore
local HurtTarget = prism.Target(prism.components.Health)
    :range(5)
    :sensed()

--- @class HurtZap : Zap
local HurtZap = prism.actions.Zap:extend "HurtZap"
HurtZap.abstract = false
HurtZap.targets = {
   HurtZappableTarget,
   HurtTarget,
}

--- @param level Level
function HurtZap:perform(level, zappable, hurtable)
   prism.actions.Zap.perform(self, level, zappable)
   local zappableComponent = zappable:expect(prism.components.HurtZappable)
   level:tryPerform(prism.actions.Damage(hurtable, zappableComponent.damage))
end

return HurtZap
