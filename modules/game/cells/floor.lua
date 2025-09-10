prism.registerCell("Floor", function()
   return prism.Cell.fromComponents {
      prism.components.Name("Floor"),
      prism.components.Drawable({ char = "floorSolid", color = DARKGRAY }),
      prism.components.Collider({ allowedMovetypes = { "walk", "fly" } }),
      prism.components.Destructible(),
      prism.components.AlternateDrawable({
         original = {
            char = "floorBrick",
            color = DARKGRAY,
         },
         alternate = {
            char = "floorSolidBrick",
            color = DARKGRAY,
         },
         original05 = {
            char = "floorSolid",
            color = DARKBROWN,
         },
         alternate05 = {
            char = "floorBrick",
            color = GRAY,
         },
         original10 = {
            char = "floorSolid",
            color = GRAY,
         },
      }),
   }
end)
