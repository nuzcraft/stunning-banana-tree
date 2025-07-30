prism.registerActor("Kobold", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Kobold"),
      prism.components.Drawable("k", prism.Color4.RED),
      prism.components.Collider(),
      prism.components.Senses(),
      prism.components.Sight { range = 12, fov = true },
      prism.components.Mover { "walk" },
      prism.components.KoboldController(),
   }
end)
