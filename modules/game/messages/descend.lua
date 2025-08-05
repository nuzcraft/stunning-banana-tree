--- @class DescendMessage : Message
--- @field descender Actor
--- @overload fun(descender: Actor): DescendMessage
local DescendMessage = prism.Object:extend("DescendMessage")

--- @param descender Actor
function DescendMessage:__new(descender)
   self.descender = descender
end

return DescendMessage
