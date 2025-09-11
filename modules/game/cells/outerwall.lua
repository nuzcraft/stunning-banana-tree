prism.registerCell("OuterWall", function()
   return prism.Cell.fromComponents {
      prism.components.Name("Wall"),
      prism.components.Drawable({ char = "wallBrokenBrick", color = LIGHTGRAY }),
      prism.components.Collider(),
      prism.components.Opaque(),
      prism.components.AlternateDrawable({
         original = {
            char = "wallBrokenBrick",
            color = LIGHTGRAY,
         },
         alternate = {
            char = "wallBrokenBrick",
            color = WHITE,
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
