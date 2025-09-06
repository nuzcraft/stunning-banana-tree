prism.registerActor("MeatBrick", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Meat Brick"),
      prism.components.Position(),
      prism.components.Drawable({ char = "%", color = RED, layer = 2 }),
      prism.components.Collider(),
      prism.components.Consumable({
         healing = 1,
      }),
      prism.components.Item {},
   }
end)
