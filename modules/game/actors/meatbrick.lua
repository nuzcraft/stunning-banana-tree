prism.registerActor("MeatBrick", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Meat Brick"),
      prism.components.Position(),
      prism.components.Drawable({ char = "%", color = prism.Color4.RED }),
      prism.components.Collider(),
      prism.components.Consumable({
         healing = 1,
      }),
      prism.components.Item {
         stackable = prism.actors.MeatBrick,
         stackLimit = 99,
      },
   }
end)
