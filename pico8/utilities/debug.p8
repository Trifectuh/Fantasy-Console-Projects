pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--
-- various functions useful for debugging and profiling
--

-- Contributors: sulai

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

table={}
---
-- Use this for some basic memory profiling.
-- this function counts the number
-- of entities (deep), not bytes
-- @param t table to get the size of
-- @return size in number of entities (recursive)
function table.size(t)
	local size=0
	for _,v in pairs(t) do
		size=size+1
		if type(v)=="table" then
			size=size+table.size(v)
		end
	end
	return size
end

-- test
--print(table.size({true,1,{false,"---"}}))

--- converts anything to string
function tostring(any)
	if type(any)=="function" then return "function" end
	if any==nil then return "nil" end
	if type(any)=="string" then return any end
	if type(any)=="boolean" then return any and "true" or "false" end
	if type(any)=="number" then return ""..any end
	if type(any)=="table" then -- recursion
		local str = "{ "
		for k,v in pairs(any) do
			str=str..tostring(k).."->"..tostring(v).." "
		end
		return str.."}"
	end
	return "unkown" -- should never show
end

-- tests
--print(""..tostring({true,x=7,{"nest"}}))
--print(function() end)

--- do some basic cpu profiling
-- Example usage:
--
--   check_cpu()
--   ... do some intensive stuff ...
--   check_cpu("this took") -- log on system console
function check_cpu(msg)
	local percent=0
	if msg~=nil then
		percent = ((stat(1)-check_cpu_start)*100)
		printh(msg.." "..flr(percent).."% of a frame")
	end
	check_cpu_start=stat(1)
	return percent
end

-- tests
--check_cpu()
--for i = 1, 10000 do printh("consume some time") end
--check_cpu("for loop")
--for i = 1, 20000 do printh("consume more time") end
--check_cpu("second for loop")

function print_cpu_mem()
	color(7)
	camera(0,0)
	cursor(0,0)
	print("cpu "..flr(stat(1)*100).."%")
	print("mem "..stat(0))
end