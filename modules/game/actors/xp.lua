prism.registerActor("XP", function()
   return prism.Actor.fromComponents {
      prism.components.Name("XP"),
      prism.components.Position(),
      prism.components.Drawable({
         char = 253,
         color = CYAN,
      }),
      prism.components.Item(),
      prism.components.XP(),
   }
end)
