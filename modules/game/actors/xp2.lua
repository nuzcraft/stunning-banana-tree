prism.registerActor("XP2", function()
   return prism.Actor.fromComponents {
      prism.components.Name("XP"),
      prism.components.Position(),
      prism.components.Drawable({
         char = "coin_stack",
         color = CYAN,
         background = DARKBLUE,
         layer = 1,
      }),
      prism.components.Item(),
      prism.components.XP(2),
   }
end)
