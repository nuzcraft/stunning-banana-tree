prism.registerActor("Kobold", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Kobold"),
      prism.components.Drawable({
         char = "kobold",
         color = YELLOW,
         background = DARKBROWN,
         layer = 2,
      }),
      prism.components.Position(),
      prism.components.Collider(),
      prism.components.Senses(),
      prism.components.Sight { range = 12, fov = true },
      prism.components.Mover { "walk" },
      prism.components.KoboldController(),
      prism.components.Health(3),
      prism.components.Attacker(1),
      -- prism.components.Kicker(2, 0),
      prism.components.DropTable {
         {
            chance = 0.3,
            entry = prism.actors.MeatBrick,
         },
         {
            chance = 1.0,
            entry = prism.actors.XP,
         },
         {
            chance = 1.0,
            entry = prism.actors.XP,
         },
         {
            chance = 1.0,
            entry = prism.actors.XP,
         },
      },
   }
end)
