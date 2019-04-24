pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- returns the distance between two objects

-- Contributors: Scathe (@clowerweb), @msauder

function dst(o1,o2)
 return sqrt(sqr(o1.x-o2.x)+sqr(o1.y-o2.y))
end

function sqr(x) return x*x end
