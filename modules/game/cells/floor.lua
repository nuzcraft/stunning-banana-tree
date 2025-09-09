prism.registerCell("Floor", function()
   return prism.Cell.fromComponents {
      prism.components.Name("Floor"),
      prism.components.Drawable({ char = "floor", color = LIGHTGRAY }),
      prism.components.Collider({ allowedMovetypes = { "walk", "fly" } }),
      prism.components.Destructible(),
      prism.components.AlternateDrawable({
         original = {
            char = "floor",
            color = LIGHTGRAY,
         },
         alternate = {
            char = "floor2",
            color = GRAY,
         },
         original05 = {
            char = "floor",
            color = LIGHTGRAY,
         },
         alternate05 = {
            char = "floor2",
            color = GRAY,
         },
      }),
   }
end)
