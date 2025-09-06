prism.registerCell("Pit", function()
   return prism.Cell.fromComponents {
      prism.components.Name("Pit"),
      prism.components.Drawable({ char = " " }),
      prism.components.Collider({ allowedMovetypes = { "fly" } }),
      prism.components.Void(),
      prism.components.AlternateDrawable({
         original = {
            char = " ",
         },
         overhang = {
            char = '"',
            color = DARKGRAY,
         },
      }),
   }
end)
