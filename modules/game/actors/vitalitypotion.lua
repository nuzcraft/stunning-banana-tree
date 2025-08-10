prism.registerActor("VitalityPotion", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Potion of Vitality"),
      prism.components.Drawable("!", prism.Color4.RED),
      prism.components.Item(),
      prism.components.Drinkable {
         healing = 5,
         status = prism.GameStatusInstance {
            duration = 10,
            modifiers = {
               prism.components.Health.Modifier(5),
            },
         },
      },
   }
end)
