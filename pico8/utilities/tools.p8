pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

tools = {}

function tools.assign(t, initial)
 initial = initial or {}
 for k, v in pairs(t) do
  initial[k] = v
 end
 return initial
end

function tools.deepassign(t, initial)
 initial = initial or {}
 for k, v in pairs(t) do
  if type(v) == "table" then
   initial[k] = tools.deepassign(v)
  else
   initial[k] = v
  end
 end
 return initial
end