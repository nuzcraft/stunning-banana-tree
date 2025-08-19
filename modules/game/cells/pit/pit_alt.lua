prism.registerCell("PitAlt", function()
   return prism.Cell.fromComponents {
      prism.components.Name("Pit"),
      prism.components.Drawable({
         char = '"',
         color = prism.Color4.DARKGRAY,
      }),
      prism.components.Collider({ allowedMovetypes = { "fly" } }),
      prism.components.Void(),
   }
end)
