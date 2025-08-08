prism.registerActor("MeatBrick", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Meat Brick"),
      prism.components.Position(),
      prism.components.Drawable("%", prism.Color4.RED),
      prism.components.Item {
         stackable = prism.actors.MeatBrick,
         stackLimit = 99,
      },
   }
end)
