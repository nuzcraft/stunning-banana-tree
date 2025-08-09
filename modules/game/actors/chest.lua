prism.registerActor("Chest", function(contents)
   return prism.Actor.fromComponents {
      prism.components.Name("Chest"),
      prism.components.Position(),
      prism.components.Inventory { items = contents },
      prism.components.Drawable("(", prism.Color4.YELLOW),
      prism.components.Container(),
      prism.components.Collider(),
   }
end)
