prism.registerActor("VitalityPotion", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Potion of Vitality"),
      prism.components.Drawable({
         char = "!",
         color = prism.Color4.RED,
      }),
      prism.components.Collider(),
      prism.components.Consumable {
         healing = 5,
         status = prism.GameStatusInstance {
            duration = 10,
            modifiers = {
               prism.components.Health.Modifier(5),
            },
         },
      },
      prism.components.Item {
         stackable = prism.actors.VitalityPotion,
         stackLimit = 99,
      },
   }
end)
