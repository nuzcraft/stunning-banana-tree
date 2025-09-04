prism.registerActor("XP2", function()
   return prism.Actor.fromComponents {
      prism.components.Name("XP"),
      prism.components.Position(),
      prism.components.Drawable({
         char = 253,
         color = CYAN,
         layer = 1,
      }),
      prism.components.Item(),
      prism.components.XP(2),
   }
end)
