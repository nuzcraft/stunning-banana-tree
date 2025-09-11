prism.registerActor("XP", function()
   return prism.Actor.fromComponents {
      prism.components.Name("XP"),
      prism.components.Position(),
      prism.components.Drawable({
         char = "coin",
         color = CYAN,
         background = DARKBLUE,
         layer = 1,
      }),
      prism.components.Item(),
      prism.components.XP(1),
   }
end)
