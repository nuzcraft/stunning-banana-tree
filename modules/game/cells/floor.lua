prism.registerCell("Floor", function()
   return prism.Cell.fromComponents {
      prism.components.Name("Floor"),
      prism.components.Drawable({ char = ".", color = LIGHTGRAY }),
      prism.components.Collider({ allowedMovetypes = { "walk", "fly" } }),
      prism.components.Destructible(),
      prism.components.AlternateDrawable({
         original = {
            char = ".",
            color = LIGHTGRAY,
         },
         alternate = {
            char = ".",
            color = GRAY,
         },
         original05 = {
            char = ".",
            color = LIGHTGRAY,
         },
         alternate05 = {
            char = ".",
            color = GRAY,
         },
      }),
   }
end)
