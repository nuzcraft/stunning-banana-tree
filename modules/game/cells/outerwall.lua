prism.registerCell("OuterWall", function()
   return prism.Cell.fromComponents {
      prism.components.Name("Wall"),
      prism.components.Drawable("#"),
      prism.components.Collider(),
      prism.components.Opaque(),
      prism.components.Unbreakable(),
   }
end)
