pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

oop = {}

local function make(vars, parents, new)
 local required = {}
 for k,v in pairs(vars) do
  if v == 'req' then
   add(required, k)
   vars[k] = nil
  end
 end
 return function(self, input)
  for v in all(required) do
   assert(
    input[v] ~= nil,
    'missing constructor argument ' .. v
   )
  end
  for parent in all(parents) do
   parent.new(self, input)
  end
  tools.deepassign(vars, self)
  tools.assign(input, self)
  if new then new(self) end
 end
end

local function search(k, list)
 for v in all(list) do
  if v[k] then return v[k] end
 end
end

local function parent_function(parents)
 local parent
 if #parents == 1 then
  parent = parents[1]
 else
  parent = function(t, k)
   return search(k, parents)
  end
 end
 return parent
end

function oop.class(properties, parents, new, metatable)
 local class = setmetatable({}, metatable or {})
 if parents and #parents ~= 0 then
  getmetatable(class).__index = parent_function(parents)
 end
 local instance_mt = {
  __index = class
 }
 class.new = make(properties, parents, new)
 function new(self, input)
  local instance = setmetatable({}, instance_mt)
  class.new(instance, input)
  return instance
 end
 getmetatable(class).__call = new
 return class
end