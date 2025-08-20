--- @diagnostic disable-next-line
function love.conf(t)
   t.window.title = "Nuzcraft's Kicking Kobolds v0.01"
   t.window.vsync = 0 -- Enable vsync (1 by default)
   t.window.width = 960
   t.window.height = 540
   t.window.usedpiscale = false
   -- Other configurations...
   t.modules.joystick = false
   t.modules.physics = false
end
