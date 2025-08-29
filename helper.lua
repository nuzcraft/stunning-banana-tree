--- @param t table
function ShuffleInPlace(t)
   for i = #t, 2, -1 do
      local j = math.random(i)
      t[i], t[j] = t[j], t[i]
   end
end

function IndexOf(array, value)
   for i, v in ipairs(array) do
      if v == value then return i end
   end
   return nil
end
