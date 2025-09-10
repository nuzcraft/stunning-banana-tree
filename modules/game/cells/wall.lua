prism.registerCell("Wall", function()
   return prism.Cell.fromComponents {
      prism.components.Name("Wall"),
      prism.components.Drawable({
         char = "wallBrokenBrick",
         color = LIGHTGRAY,
         -- background = DARKGRAY
      }),
      prism.components.Collider(),
      prism.components.Opaque(),
      prism.components.Destructible(),
      prism.components.AlternateDrawable({
         original = {
            char = "wallBrokenBrick",
            color = LIGHTGRAY,
            -- background = DARKGRAY,
         },
         alternate = {
            char = "wallBrokenBrick",
            color = WHITE,
            -- background = DARKGRAY,
         },
         original05 = {
            char = "wallBrick",
            color = ORANGE,
         },
         alternate05 = {
            char = "wallBrokenBrick",
            color = BROWN,
         },
         original10 = {
            char = "wallBrick",
            color = RED,
         },
         alternate10 = {
            char = "wallBrokenBrick",
            color = DARKRED,
         },
      }),
   }
end)
