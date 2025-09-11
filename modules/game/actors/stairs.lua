prism.registerActor("Stairs", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Stairs"),
      prism.components.Position(),
      prism.components.Drawable({ char = "stairs_down", color = WHITE }),
      prism.components.Stair(),
      prism.components.Remembered(),
   }
end)
