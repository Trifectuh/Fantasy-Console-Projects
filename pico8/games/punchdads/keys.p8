pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

keys={btns={},ct={}}

function keys:update()
 for i=0,13 do
  if band(btn(),shl(1,i))==shl(1,i) then
   if keys:held(i) then
    keys.btns[i]=2
    keys.ct[i]=(keys.ct[i]+1) % 30
   else
    keys.btns[i]=3
   end
  else
   if keys:held(i) then 
    keys.btns[i]=4
   else
    keys.btns[i]=0
    keys.ct[i]=0
   end
  end
 end
end

function keys:held(b) 
 return band(keys.btns[b],2) == 2 
end

function keys:down(b) 
 return band(keys.btns[b],1) == 1 
end

function keys:up(b) 
 return band(keys.btns[b],4) == 4 
end

function keys:pulse(b,r) 
 return (keys:held(b) and keys.ct[b]%r==0) 
end

function keys:updatebuffer(c)
 local l local r local u local d
 if c==p[1] then
  l=0 r=1 u=2 d=3
 else
  l=8 r=9 u=10 d=11 end
 if c.lastbtn[2]!=nil then
  c.lastbtn[2]+=1 
  if c.lastbtn[2]>24 then
   c.lastbtn[2]=nil end
 end
  if c.btnbuffer[16]!=nil then
   del(c.btnbuffer,c.btnbuffer[1]) end
  if keys:down(l) then 
   add(c.btnbuffer,'<') c.lastbtn={'<',0} end
  if keys:down(r) then 
   add(c.btnbuffer,'>') c.lastbtn={'>',0} end
  if keys:down(u) then 
   add(c.btnbuffer,'^') c.lastbtn={'^',0} end
  if keys:down(d) then 
   add(c.btnbuffer,'v') c.lastbtn={'v',0} end
end