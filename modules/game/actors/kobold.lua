prism.registerActor("Kobold", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Kobold"),
      prism.components.Drawable("k", YELLOW),
      prism.components.Position(),
      prism.components.Collider(),
      prism.components.Senses(),
      prism.components.Sight { range = 12, fov = true },
      prism.components.Mover { "walk" },
      prism.components.KoboldController(),
      prism.components.Health(3),
      prism.components.Attacker(1),
      prism.components.DropTable {
         chance = 0.3,
         entry = prism.actors.MeatBrick,
      },
   }
end)
