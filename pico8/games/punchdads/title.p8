pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

titleoffset=-32

function title_update()
 keys:update()
 if keys:up(4) or keys:up(12) then
  game.upd=game_update
  game.draw=game_draw
 end
end

function title_draw()
 cls()
 _drawtitle(titleoffset)
 initoffset=titleoffset
 titleoffset+=1
 if titleoffset>10 then 
 titleoffset=-32 end
end

function _drawtitle(q)
 startx=q
 starty=-128 
 rows=12
 while rows>0 do
  x=startx 
  y=starty 
  c=16
  while c>0 do
   print('punch dads',x,y,14)
   print('punch dads',x+16,y+8,12)
   x=x-27 y=y+8 c=c-1
  end
  startx=startx+32
  starty=starty+16
  rows=rows-1
 end
 for x=0,121 do
  print('\128',x,80,0)
  print('press (n) or (tab) to start',10,80,6)
  x+=8
 end
end