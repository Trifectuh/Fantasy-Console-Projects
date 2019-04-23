pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function char_update(c)
 -- get current controller
 local ctrl=c.id-1
 -- stop movement from last frame
 c.dx=0 c.dy=0
  -- reset status
 c.halt=false

 -- update the input buffer
 char_updateinputbuffer(c)
 --face the correct direction
 char_face(c)
 -- check if fireballs hit us - move this elsewhere idiot!
 fb_hitcalc()
 -- get currently pressed dpad direction
 char_updatedir(c)

 -- slide if we get hit by something
 if char_shouldknock(c) then c.upd=char_knock end
 -- walk if we should walk
 if char_shouldwalk(c) then
  if btn(0, ctrl) then c.upd=char_walk(c,0) end
  if btn(1, ctrl) then c.upd=char_walk(c,1) end
  if btn(2, ctrl) then c.upd=char_walk(c,2) end
  if btn(3, ctrl) then c.upd=char_walk(c,3) end
  char_walkanim(c)
 end
 -- dash if we should dash (broken)
 -- if char_shoulddash(c) then c.upd=char_dash end

 -- update attacks
 if char_shouldattack(c) then c.upd=char_attack end
 -- check if we should halt
 if char_shouldhalt(c) then c.upd=char_halt end
 --check if we should fall
 if char_shouldfall(c) then c.upd=char_fall end
  
 --do the thing we decided to do
 c.upd(c)
 c.x+=c.dx
 c.y+=c.dy
end

function char_shouldknock(c)
 if c.status.knockback>0 then
  return true
 else
  return false
 end
end

function char_shouldwalk(c)
 if c.halt==false then 
  return true
 else 
  return false 
 end
end

function char_updatedir(c)
  local ctrl=c.id-1
 if btn(0, ctrl) then
  c.xdir=-1
 elseif btn(1, ctrl) then
  c.xdir=1
 else c.xdir=0
 end
 if btn(2, ctrl) then
  c.ydir=-1
 elseif btn(3, ctrl) then
  c.ydir=1
 else c.ydir=0
 end
end

function char_shoulddash(c)
 local dist=1
 local l local r local u local d
  if c==p[1] then
   l=0 r=1 u=2 d=3
  else
   l=8 r=9 u=10 d=11 end
  if c.lastbtn[1]=='<' 
  and c.lastbtn[2]!=nil then
   if keys:down(l) then
    c.status.dashframe[1]=dist
    c.status.dashframe[2]='<'
    return true
   end
  end
  if c.lastbtn[1]=='>' 
  and c.lastbtn[2]!=nil then
   if keys:down(r) then
    c.status.dashframe[1]=dist
    c.status.dashframe[2]='>'
    return true
   end
  end
  if c.lastbtn[1]=='^' 
  and c.lastbtn[2]!=nil then
   if keys:down(u) then
    c.status.dashframe[1]=dist/1.25
    c.status.dashframe[2]='^' end
    return true
  end
  if c.lastbtn[1]=='v' 
  and c.lastbtn[2]!=nil then
   if keys:down(d) then
    c.status.dashframe[1]=dist/1.25
    c.status.dashframe[2]='v' end
    return true
   else 
    return false 
  end
end

function char_dash(c)
 local dist=1
 if c.status.dashframe[1]>0 then
  if c.status.dashframe[2]=='<' then
   c.dx=-c.status.dashframe[1]
   c.x+=c.dx end
  if c.status.dashframe[2]=='>' then
   c.dx=c.status.dashframe[1]
   c.x+=c.dx end
  if c.status.dashframe[2]=='^' then
   c.dy=-c.status.dashframe[1]
   c.y+=c.dy end
  if c.status.dashframe[2]=='v' then
   c.dy=c.status.dashframe[1]
   c.y+=c.dy 
  end
  c.status.dashframe[1]-=0.05
 end
end

function char_updateinputbuffer(c)
 keys:updatebuffer(c)
end

function char_shouldattack(c)
  if c.framecounter>0 then
  c.framecounter-=1
  return false
 else
  c.activemove=0 
  c.status.projectile=false
  return true
 end
end 

function char_attack(c)
 attack_1(c)
 attack_2(c) 
end

function char_shouldhalt(c)
 if c.status.attacking 
 or c.status.blocking 
 or c.status.falling 
 or c.status.dead then
  return true
 elseif c.status.knockback>0 or c.status.knockup>0 then
  return true
 else return false end
end

function char_halt(c)
 c.halt=true
end

function char_shouldfall(c)
 if c.y>=50 then
  c.lwalldist=(c.x+8)-((c.y-51)*2)
  c.rwalldist=(120-c.x)-((c.y-51)*2)
 elseif c.y<=49 then
  c.lwalldist=(c.x+8)-((47-c.y)*2)
  c.rwalldist=(120-c.x)-((47-c.y)*2)
 end

 if c.lwalldist<=0 or c.rwalldist<=0 or felly~=nil then 
   if c.status.felly==nil then
  		c.status.felly=c.y 
   end
    return true
  else return false
 end
end

function char_fall(c)
 c.y+=2
 if c.y>128 then
  time_falldelay(c)
 end
 if c.y>512 then
  c.status.stocks-=1
  char_respawn(c)
 end
end

function char_block(c)
  c.status.blocking=true
  c.status.activemove=0
  c.activespr=c.blockspr
end

function char_blockcheck(c,r)
 local op=char_getop(c)
 if char_isinrange(c,r) then
  if op.x<c.x and op.xdir==-1 then
   char_block(op)
  elseif op.x>c.x and op.xdir==1 then
   char_block(op)
  end
 end
end

function char_blockreset(c)
 c.status.blocking=false
end

function char_face()
	if p[1].x<p[2].x then
		p[1].drc=false p[2].drc=true 
 end
	if p[1].x>p[2].x then
		p[1].drc=true  p[2].drc=false 
 end
end

function time_falldelay(c)
 if c.y<256 then
  c.fallcounter=3
 elseif c.y<384 then
  c.fallcounter=2
 elseif c.y<512 then
  c.fallcounter=1
 end
end

function char_fellofftop(c)
	if c.status.falling==true 
  and c.status.felly<=48 then 
   return true 
 end
end

function char_getcollisions(c)
 local op=char_getop(c)
 local collisions={}
 if c.y<=op.y-5 or c.y>=op.y+5 then
  collisions.coly=false
 else collisions.coly=true end
 if c.x-op.x<=9 and op.x-c.x<=0 then
  collisions.cl=true
 else collisions.cl=false end
 if c.x-op.x>=-9 and op.x-c.x>=0 then
  collisions.cr=true
 else collisions.cr=false end
 if c.x-op.x>8 or c.x-op.x<-8 then
  collisions.cu=false
 else collisions.cu=true end
 if collisions.coly and collisions.cl then
  collisions.coll=true 
 else collisions.coll=false end
 if collisions.coly and collisions.cr then
  collisions.colr=true 
 else collisions.colr = false end
 return collisions
end

function char_getop(c)
 if c.id==1 then 
  return p[2] 
 end
 if c.id==2 then 
  return p[1] 
 end
end

function char_isinrange(c,r)
 local op=char_getop(c)
 local x=char_getcollisions(c)
 if op.x-c.x<=r and op.x-c.x>0 and x.coly then
  return true
 elseif c.x-op.x<=r and c.x-op.x>=0 and x.coly then
  return true
 else 
  return false 
 end
end

function char_knock(c)
 local op=char_getop(c)
 if c.x<op.x then
  c.x-=c.status.knockback
  c.y-=c.status.knockup
  c.status.knockback-=0.15 
  if c.status.knockup>0 then
   c.status.knockup-=0.075
  elseif c.status.knockup<0 then
   c.status.knockup+=0.075 
  end
 elseif c.x>op.x then
  c.x+=c.status.knockback
  c.y-=c.status.knockup
  c.status.knockback-=0.15
  if c.status.knockup>0 then
   c.status.knockup-=0.075
  elseif c.status.knockup<0 then
   c.status.knockup+=0.075 
  end 
 end
end

function char_respawn(c)
 c.status.falling=false
 c.status.knockback=0
 c.x=c.sx 
 c.y=c.sy
 c.status.felly=nil
end

function char_fwdstep(c,d)
 local op=char_getop(c)
 if op.x<c.x and c.x-op.x>9 then 
  c.x-=d
 elseif op.x>c.x and op.x-c.x>9 then 
  c.x+=d 
 end
end

function char_backstep(c,d)
 local op=char_getop(c)
 if op.x<c.x and c.x-op.x>9 then 
  c.x+=d
  c.y-=c.ydir/4
 elseif op.x>c.x and op.x-c.x>9 then 
  c.x-=d 
  c.y-=c.ydir/4
 end
end

function char_updateattacks(c)
 if c.framecounter>0 then
  c.framecounter-=1
 else
  c.activemove=0 
  c.status.projectile=false
 end
 attack_1(c)
 attack_2(c)
end

function char_walk(c,d)
 local op=char_getop(c)
 local x=char_getcollisions(c)
 if c.halt==false then
  if d==0 and x.coll==false and c.lwalldist>=3 then
   c.dx=-0.5 c.xdir=-1 c.walk=true end
  if d==1 and x.colr==false and c.rwalldist>=3 then
   c.dx=0.5 c.xdir=1 c.walk=true end
  if (d==2 and c.lwalldist>=3 and c.rwalldist>=3)
  or (d==2 and c.y>50) then
   c.ydir=-1
   if x.cu==true then
    if c.y>=op.y+6 or op.y>=c.y+5 then
     c.dy=-0.25 c.walk=true end 
   else c.dy=-0.25 c.walk=true end
  end
  if (d==3 and c.lwalldist>=4 and c.rwalldist>=4)
  or (d==3 and c.y<48) then
   c.ydir=1
   if x.cu==true then
    if c.y<=op.y-6 or op.y<=c.y-5 then
     c.dy=0.25 c.walk=true end 
   else c.dy=0.25 c.walk=true end
  end
 end
end

function char_updatewalldist(c)
 if c.y>=50 then
  c.lwalldist=(c.x+8)-((c.y-51)*2)
  c.rwalldist=(120-c.x)-((c.y-51)*2)
 elseif c.y<=49 then
  c.lwalldist=(c.x+8)-((47-c.y)*2)
  c.rwalldist=(120-c.x)-((47-c.y)*2)
 end
end

function char_walkanim(c)
	stride=6
	if c.walkframe==nil then
		c.walkframe=stride
		c.activespr=c.walkspr[1]
		c.walkframe-=1 
 end
	if c.walkframe>0 then
		c.activespr=c.activespr
		c.walkframe-=1
	elseif c.activespr==c.walkspr[1] then
		c.walkframe=stride
		c.activespr=c.walkspr[2]
	elseif c.activespr==c.walkspr[2] then
		c.walkframe=stride
		c.activespr=c.walkspr[3]
	elseif c.activespr==c.walkspr[3] then
		c.walkframe=stride
		c.activespr=c.walkspr[4]
	else 
  c.walkframe=stride
		c.activespr=c.walkspr[1]
	end
end