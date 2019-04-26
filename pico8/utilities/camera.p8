pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- give the screen a shake
function cam_screenshake()
  local fade = 0.15
  local offset_x=16-rnd(32)
  local offset_y=16-rnd(32)
  offset_x*=cameraoffset
  offset_y*=cameraoffset
  
  camera(offset_x,offset_y)
  cameraoffset*=fade
  if cameraoffset<0.05 then
    camereaoffset=0
  end
end
