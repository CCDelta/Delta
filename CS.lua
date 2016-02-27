local path = ...
if not path then
  print("Nope")
else
  shell.run(path.."/Console.lua",path)
end
