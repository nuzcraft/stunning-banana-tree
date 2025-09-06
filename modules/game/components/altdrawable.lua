--- @class AlternateDrawable : Component
--- @field options table<string, DrawableOptions>
--- @overload fun(options: table<string, DrawableOptions>)
local AlternateDrawable = prism.Component:extend("AlternateDrawable")

--- @param options table<string, DrawableOptions>
function AlternateDrawable:__new(options)
   self.options = options
end

return AlternateDrawable
