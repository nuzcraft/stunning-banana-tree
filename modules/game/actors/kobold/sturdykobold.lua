prism.registerActor("SturdyKobold", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Sturdy Kobold"),
      prism.components.Drawable({
         char = "kobold_armed",
         color = ORANGE,
         background = DARKBROWN,
         layer = 2,
      }),
      prism.components.Position(),
      prism.components.Collider(),
      prism.components.Senses(),
      prism.components.Sight { range = 12, fov = true },
      prism.components.Mover { "walk" },
      prism.components.KoboldController(),
      prism.components.Health(6),
      prism.components.Attacker(1),
      -- prism.components.Kicker(2, 0),
      prism.components.Sturdy(1),
      prism.components.DropTable {
         {
            chance = 0.5,
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
            entry = prism.actors.XP,
         },
      },
   }
end)
