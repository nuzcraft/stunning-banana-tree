prism.registerActor("Player", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Player"),
      prism.components.Drawable("@", prism.Color4.GREEN, nil, math.huge),
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
   }
end)
