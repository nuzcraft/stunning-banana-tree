prism.registerActor("Chest", function(contents)
   return prism.Actor.fromComponents {
      prism.components.Name("Chest"),
      prism.components.Position(),
      prism.components.Inventory { items = contents },
      prism.components.Drawable({
         char = "chest",
         color = YELLOW,
         background = DARKBROWN,
         layer = 2,
      }),
      prism.components.Container(),
      prism.components.Collider(),
   }
end)
