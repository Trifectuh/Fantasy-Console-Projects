pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function _drawui()
 print('health: ',0,1,14)
 print(p[1].status.hp,30,1,14)
 print('stocks: ',0,8,14)
 print(p[1].status.stocks,30,8,14)
 print('health: ',90,1,12)
 print(p[2].status.hp,120,1,12)
 print('stocks: ',90,8,12)
 print(p[2].status.stocks,120,8,12)
 print(p[1].roundwins,48,110,14)
 print('round',54,110,5)
 print(p[2].roundwins,76,110,12)
end

function _drawtilemap()
 mapdone=false
	startx=48 
 starty=32 
 rows=4
	while rows>0 do
		x=startx 
  y=starty 
  c=4
		while c>0 do
			spr(128,x,y,32,32)
			x=x-16 y=y+8 c=c-1
		end
		startx=startx+16
		starty=starty+8
		rows=rows-1
	end
 mapdone=true
end