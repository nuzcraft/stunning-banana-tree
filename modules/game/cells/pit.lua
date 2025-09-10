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
            char = "overhang_vines_2",
            color = DARKBROWN,
         },
      }),
   }
end)
