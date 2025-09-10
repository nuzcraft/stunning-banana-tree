prism.registerActor("XP", function()
   return prism.Actor.fromComponents {
      prism.components.Name("XP"),
      prism.components.Position(),
      prism.components.Drawable({
         char = "coin",
         color = CYAN,
         layer = 1,
      }),
      prism.components.Item(),
      prism.components.XP(1),
   }
end)
