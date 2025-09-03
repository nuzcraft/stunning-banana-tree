prism.registerActor("Player", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Player"),
      prism.components.Drawable({
         char = "@",
         color = prism.Color4.GREEN,
         layer = math.huge,
      }),
      prism.components.Position(),
      prism.components.Collider(),
      prism.components.PlayerController(),
      prism.components.Senses(),
      prism.components.Sight { range = 64, fov = true },
      prism.components.Mover { "walk" },
      prism.components.Health(10),
      prism.components.Log(),
      prism.components.Inventory {
         limitCount = 26,
      },
      prism.components.StatusEffects(),
      prism.components.Attacker(1),
      prism.components.Kicker(3, 0),
      prism.components.Stomper(0),
      prism.components.XPCollector(),
      -- prism.components.WallKicker(),
   }
end)
