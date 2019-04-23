pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function attack_1(c)
 local m=c.moves.atk1
 local op=char_getop(c)
 local ctrl=c.id-1
 if btn(4, ctrl) and c.activemove==0 then
   c.status.attacking=true
   c.shouldact=false
   attack_anim(c,m)
   c.activemove=1
 elseif c.activemove==1 then
  c.status.attacking=true
  char_blockcheck(c,m.ra)
  if attack_anim(c,m)=='a' then
   char_fwdstep(c,0.5)
   char_blockcheck(c,m.ra)
   if char_isinrange(c,m.ra) then
    attack_impact(op,m) end
  elseif attack_anim(c,m)=='r' then
   char_blockreset(op) end
 elseif c.activemove!=0 then c.status.attacking=true
 else 
  c.status.attacking=false
  c.activemove=0
  c.shouldact=true
  char_blockreset(op) end
end

function attack_2(c)
 local m=c.moves.atk2
 local op=char_getop(c)
 local ctrl=c.id-1
 local opctrl=op.id-1
 if btn(5, ctrl) and c.activemove==0 then
   c.status.attacking=true
   c.shouldact=false
   attack_anim(c,m)
   c.activemove=2
 elseif c.activemove==2 then
  c.status.attacking=true
  if attack_anim(c,m)=='a' then
   if c.status.projectile==false then
    if op.x<c.x then fb_throw(c,-1)
    else fb_throw(c,1) end
    c.status.projectile=true
   end
   char_backstep(c,0.5)
 elseif attack_anim(c,m)=='r' then
   char_blockreset(op) end
 elseif c.activemove!=0 then c.status.attacking=true
 else 
  c.status.attacking=false
  c.shouldact=true
  c.activemove=0
  char_blockreset(op) end
end

function attack_anim(c,m)
 if c.framecounter<=0 and c.activemove==0 then
  c.framecounter=m.s[1]+m.a[1]+m.r[1]
  c.activespr=m.s[2]
  return 's'
 elseif c.framecounter>=m.a[1]+m.r[1] then
  c.activespr=m.s[2]
  return 's'
 elseif c.framecounter>=m.r[1] then
  c.activespr=m.a[2]
  return 'a'
 elseif c.framecounter>=0 then
  c.activespr=m.r[2] 
  return 'r' end
end

function attack_impact(c,m)
 local op=char_getop(c)
 if c.status.blocking==false then
  if c.status.knockback<=0 then
   cameraoffset=0.2
   c.status.hp-=m.d
   c.status.knockback=m.i end
  if op.y-2>c.y then
   c.status.knockup=m.i/2
  elseif op.y+2<c.y then
   c.status.knockup=-(m.i/2) end
 end
end