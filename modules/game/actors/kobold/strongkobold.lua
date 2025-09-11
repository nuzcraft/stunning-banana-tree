prism.registerActor("StrongKobold", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Strong Kobold"),
      prism.components.Drawable({
         char = "kobold_armed",
         color = RED,
         background = DARKBLUE,
         layer = 2,
      }),
      prism.components.Position(),
      prism.components.Collider(),
      prism.components.Senses(),
      prism.components.Sight { range = 12, fov = true },
      prism.components.Mover { "walk" },
      prism.components.KoboldController(),
      prism.components.Health(9),
      prism.components.Attacker(3),
      -- prism.components.Kicker(2, 0),
      prism.components.DropTable {
         {
            chance = 1.0,
            entry = prism.actors.MeatBrick,
         },
         {
            chance = 1.0,
            entry = prism.actors.XP2,
         },
         {
            chance = 1.0,
            entry = prism.actors.XP2,
         },
         {
            chance = 1.0,
            entry = prism.actors.XP2,
         },
         {
            chance = 1.0,
            entry = prism.actors.XP,
         },
      },
   }
end)
