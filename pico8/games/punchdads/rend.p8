pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function end_update()
 if p[1].roundwins<2
   and p[2].roundwins<2 then
   _softrestart() 
  else _fullrestart() end
end

function end_draw()
 if _roundend()==p[1] and countround==true then
  countround=false
  p[1].roundwins+=1
 elseif _roundend()==p[2] and countround==true then
  countround=false
  p[2].roundwins+=1
 end
 if _roundend()==p[1] then
  if p[1].roundwins<2 then
   print('k.o! pink dad won the round!',10,40,14)
   print('press (a) to continue',23,60,14) 
  else
   print('player 1 wins!',36,40,14)
   print('press (a) to run it back',20,60,14) 
  end
 elseif _roundend()==p[2] then
  if p[2].roundwins<2 then
   print('k.o! blue dad won the round!',10,40,12)
   print('press (a) to continue',23,60,12) 
  else
   print('player 2 wins!',36,40,12)
   print('press (a) to run it back',20,60,12) 
  end
 end
end

function _roundend()
 if p[1].status.hp<=0 or 
 p[1].status.stocks<=0 then 
  return p[2]
 elseif p[2].status.hp<=0 or 
 p[2].status.stocks<=0 then
  return p[1]
 else 
  return nil 
 end
end

function _softrestart()
 if restarttimer==nil then
  restarttimer=60
 elseif restarttimer>0 then
  restarttimer-=1
 elseif btn(4,0) or btn(4,1) then
  p[1].status.hp=50
  p[1].status.stocks=2
  p[2].status.hp=50
  p[2].status.stocks=2
  firstrun=true
  countround=true
 end
end

function _fullrestart()
 if restarttimer==nil then
  restarttimer=60
 elseif restarttimer>0 then
  restarttimer-=1
 elseif btn(4,0) or btn(4,1) then
  run()
 end
end