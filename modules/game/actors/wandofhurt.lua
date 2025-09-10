prism.registerActor("WandofHurt", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Wand of Hurt"),
      prism.components.Drawable {
         char = "wand",
         color = PURPLE,
      },
      prism.components.HurtZappable {
         charges = 3,
         cost = 1,
         damage = 3,
      },
      prism.components.Item(),
   }
end)
