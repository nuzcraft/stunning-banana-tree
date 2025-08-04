--- @class Health : Component
--- @field maxHP integer
--- @field hp integer
local Health = prism.Component:extend("Health")

function Health:__new(maxHP)
   self.maxHP = maxHP
   self.hp = maxHP
end

return Health
