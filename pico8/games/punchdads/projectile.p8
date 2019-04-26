pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function fb_throw(c,d)
 local op=char_getop(c)
 local f = {
  t=op, sp=c.projectilespr, 
  x=c.x, y=c.y,
  dx=d, dy=c.ydir/2,
 }
 add(fb,f)
 c.ydir=0
end

function fb_draw()
 for f in all(fb) do
   spr(f.sp,f.x,f.y)
  end
end

function fb_hitcalc()
  for f in all(fb) do
    if f.t.x-f.x<20 and f.t.x-f.x>-30
      and f.t.y-f.y<4 and f.t.y-f.y>-6 then
        if f.t.xdir==f.dx then
          f.t.status.blocking=true 
          f.t.activespr=f.t.blockspr
        end
      if f.t.x-f.x<2 and f.t.x-f.x>-10
        and f.t.y-f.y<4 and f.t.y-f.y>-6 then 
          if f.t.xdir!=f.dx then
            fb_impact(f)
            del(fb, f)
          else
            del(fb, f)
          end
      end
    end
  end
end

function fb_impact(f)
 cameraoffset=0.2
 f.t.status.hp-=5
 if f.t.status.knockback<=0 then
      f.t.status.knockback=1.5 
     end
     if f.y>f.t.y then
      f.t.status.knockup=0.75
     elseif f.y<f.t.y then
      f.t.status.knockup=-0.75 
     end 
end