prism.registerCell("Wall", function()
   return prism.Cell.fromComponents {
      prism.components.Name("Wall"),
      prism.components.Drawable({ char = "#", color = LIGHTGRAY }),
      prism.components.Collider(),
      prism.components.Opaque(),
      prism.components.Destructible(),
      prism.components.AlternateDrawable({
         original = {
            char = "#",
            color = WHITE,
         },
         alternate = {
            char = "#",
            color = LIGHTGRAY,
         },
         original05 = {
            char = "#",
            color = ORANGE,
         },
         alternate05 = {
            char = "#",
            color = BROWN,
         },
         original10 = {
            char = "#",
            color = RED,
         },
         alternate10 = {
            char = "#",
            color = DARKRED,
         },
      }),
   }
end)
