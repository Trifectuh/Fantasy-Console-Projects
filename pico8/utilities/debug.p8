pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

debug = {}

function debug.tstr(t, indent)
 indent = indent or 0
 local indentstr = ''
 for i=0,indent do
  indentstr = indentstr .. ' '
 end
 local str = ''
 for k, v in pairs(t) do
  if type(v) == 'table' then
   str = str .. indentstr .. k .. '\n' .. debug.tstr(v, indent + 1) .. '\n'
  else
   str = str .. indentstr .. tostr(k) .. ': ' .. tostr(v) .. '\n'
  end
 end
  str = sub(str, 1, -2)
 return str
end

function debug.print(...)
 printh("\n")
 for v in all{...} do
  if type(v) == "table" then
   printh(debug.tstr(v))
  elseif type(v) == "nil" then
    printh("nil")
  else
   printh(v)
  end
 end
end