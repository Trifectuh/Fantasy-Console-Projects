pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

physics = {}

function physics.collided(body1, body2)
 local result = true
 for i=1,2 do
  result = result and
   body1.pos[i] < body2.pos[i] + body2.size[i] and
   body2.pos[i] < body1.pos[i] + body1.size[i]
 end
 return result
end

physics.world = oop.class{
 bodies = {},
 gravity = {0, .5},
}

function physics.world:update()
 for body in all(self.bodies) do
  if not body.static then
   if body.mass[1] or body.mass[2] then
    body:shove{
     self.gravity[1] * body.weight[1], self.gravity[2] * body.weight[2]
    }
    if body.friction[1] ~= 0 or body.friction[2] ~= 0 then
     body:slow(body.friction)
    end
   end

   body.collisions = {}
   for body2 in all(self.bodies) do
    if band(body.layer, body2.layer) ~= 0 and body ~= body2 then
     body:checkcollided(body2)
    end
   end
   body:update()
  end
 end
end

function physics.world:addbody(body)
 add(self.bodies, body)
 return body
end

physics.body = oop.class{
 pos="req",
 size="req",
 vel={0, 0},
 mass={1, 1},
 weight={1, 1},
 friction={.1, 0},
 collisions={},
 static=false,
 layer=0x1,
}
function physics.body:shove(vel)
 for i=1,2 do
  self.vel[i] += vel[i] * self.mass[i]
 end
end

function physics.body:update()
 for i=1,2 do
  self.pos[i] += self.vel[i]
 end
end

function physics.body:slow(vel)
 for i=1,2 do
  if self.vel[i] > 0 then
   self.vel[i] -= vel[i] * self.mass[i]
   if self.vel[i] < 0 then
    self.vel[i] = 0
   end
  elseif self.vel[i] < 0 then
   self.vel[i] += vel[i] * self.mass[i]
   if self.vel[i] > 0 then
    self.vel[i] = 0
   end
  end
 end
end

function physics.body:checkcollided(body)
 local oldpos = tools.assign(self.pos)
 for i=1,2 do
  local pos = tools.assign(oldpos)
  pos[i] += self.vel[i]
  if physics.collided({pos=pos, size=self.size}, body) then
   add(self.collisions, body)
   if self.vel[i] >= 0 then
    self.pos[i] = body.pos[i] - self.size[i]
   else
    self.pos[i] = body.pos[i] + body.size[i]
   end
   self.vel[i] = 0
  end
 end
end