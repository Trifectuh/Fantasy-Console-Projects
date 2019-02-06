-- title:  FPS80
-- author: Bruno Oliveira
-- desc:   A 3D first-person shooter for the TIC-80
-- script: lua
-- saveid: fps80

--GENERATED CODE. DO NOT EDIT.
--Edit the source .lua files instead.

local sin,cos,PI=math.sin,math.cos,math.pi
local floor,ceil,sqrt=math.floor,math.ceil,math.sqrt
local min,max,abs,HUGE=math.min,math.max,math.abs,math.huge
local random=math.random
function clamp(x,lo,hi) return max(min(x,hi),lo) end
local SCRW=240
local SCRH=136
local TID={
  STONE=116,     -- stone wall
  WOOD=256,      -- wood wall
  DOOR=112,      -- door
  LDOOR=264,     -- locked door
  CYC_W1=320,    -- cyclops walk 1
  CYC_ATK=324,   -- cyclops attack
  CYC_W2=384,    -- cyclops walk 2
  CYC_PRE=448,   -- cyclops prepare
  CBOW_N=460,    -- crossbow neutral
  CBOW_D=492,    -- crossbow drawn
  CBOW_E=428,    -- crossbow empty
  ARROW=412,     -- arrow flying
  POTION_1=458,  -- healing potion
  POTION_2=490,
  AMMO_1=456,    -- ammo (arrows)
  AMMO_2=488,
  DEMON_1=388,   -- flying demon, flying 1
  DEMON_2=390,   -- flying demon, flying 2
  DEMON_PRE=420, -- flying demon, prepare
  DEMON_ATK=422, -- flying demon, attack
  KEY_1=440,     -- key (on floor, to pick up)
  KEY_2=442,
  SPITTER_1=452,   -- fire spitting demon
  SPITTER_2=454,   --
  SPITTER_PRE=484, -- preparing to shoot
  SPITTER_ATK=488, -- shooting
  FIREBALL_1=392,
  FIREBALL_2=394,
  GREN=413,        -- grenade
  GREN_BOX=398,    -- box of grenades (item to
  PILLAR=15,
  LEVER=328,       -- wall with a lever on it
  LEVER_P=332,     -- wall with a lever on it (pulled)
  GATE=260,
  TREE=46,
  PORTAL_1=152,PORTAL_2=154,PORTAL_3=156,
  FOUNT_1=120,FOUNT_2=122,FOUNT_3=124,
}
local S3={
 ILEAVE=true,
 VP_L=0,VP_T=0,VP_R=239,VP_B=119,
 FLOOR_Y=0,
 CEIL_Y=50,
 FOG_S=10000,
 FOG_E=80000,
 FLIC_AMP=1500,
 FLIC_FM=0.003,  -- frequency multiplier
 FLOOR_CLR=9,
 CEIL_CLR=0,
 TEX={
  [TID.STONE]={w=32,h=32},
  [TID.WOOD]={w=32,h=32},
  [TID.DOOR]={w=32,h=32},
  [TID.LDOOR]={w=32,h=32},
  [TID.CYC_W1]={w=32,h=32},
  [TID.CYC_ATK]={w=32,h=32},
  [TID.CYC_W2]={w=32,h=32},
  [TID.CYC_PRE]={w=32,h=32},
  [TID.CBOW_N]={w=32,h=16},
  [TID.CBOW_D]={w=32,h=16},
  [TID.CBOW_E]={w=32,h=16},
  [TID.ARROW]={w=8,h=8},
  [TID.POTION_1]={w=16,h=16},
  [TID.POTION_2]={w=16,h=16},
  [TID.AMMO_1]={w=16,h=16},
  [TID.AMMO_2]={w=16,h=16},
  [TID.DEMON_1]={w=16,h=16},
  [TID.DEMON_2]={w=16,h=16},
  [TID.DEMON_PRE]={w=16,h=16},
  [TID.DEMON_ATK]={w=16,h=16},
  [TID.KEY_1]={w=16,h=8},
  [TID.KEY_2]={w=16,h=8},
  [TID.SPITTER_1]={w=16,h=16},
  [TID.SPITTER_2]={w=16,h=16},
  [TID.SPITTER_PRE]={w=16,h=16},
  [TID.SPITTER_ATK]={w=16,h=16},
  [TID.FIREBALL_1]={w=16,h=16},
  [TID.FIREBALL_2]={w=16,h=16},
  [TID.GREN]={w=8,h=8},
  [TID.GREN_BOX]={w=16,h=16},
  [TID.PILLAR]={w=8,h=32},
  [TID.LEVER]={w=32,h=32},
  [TID.LEVER_P]={w=32,h=32},
  [TID.GATE]={w=32,h=32},
  [TID.TREE]={w=8,h=16},
  [TID.PORTAL_1]={w=16,h=16},
  [TID.PORTAL_2]={w=16,h=16},
  [TID.PORTAL_3]={w=16,h=16},
  [TID.FOUNT_1]={w=16,h=16},
  [TID.FOUNT_2]={w=16,h=16},
  [TID.FOUNT_3]={w=16,h=16},
 },
 lastFT=nil,
 ex=0, ey=0, ez=0, yaw=0,
 cosMy=0, sinMy=0, termA=0, termB=0,
 t=0,
 NCLIP=0.1,
 FCLIP=1000,
 walls={},
 hbuf={},
 clrM={
  {1,2,3,15},
  {7,6,5,4},
  {8,9,10,11}
 },
 clrMR={}, -- computed on init
 PVS_CELL=50,
 pvstab={},
 stencil={},
 bills={},
 overs={},
 zobills={},
 flashes={},
 parts={},
 partPool={},
}
function S3Init()
 _S3InitClr()
 S3Reset()
 _S3StencilInit()
end
function S3Reset()
 S3SetCam(0,0,0,0)
 S3.walls={}
 S3.pvstab={}
 S3.overs={}
 S3.bills={}
 S3.zobills={}
 S3.flashes={}
 S3.parts={}
 S3.partPool={}
end
function _S3InitClr()
 for c=15,1,-1 do S3.clrMR[c]=nil end
 for _,ramp in pairs(S3.clrM) do
  for i=1,#ramp do
   local thisC=ramp[i]
   S3.clrMR[thisC]={ramp=ramp,i=i}
  end
 end
end
function _S3ClrMod(c,f,x,y)
 if f==1 then return c end
 local mr=S3.clrMR[c]
 if not mr then return c end
 local di=mr.i*f -- desired intensity
 local int
 if x then
  local loi=floor(di)
  local hii=ceil(di)
  local fac=di-loi
  local ent=(x+y)%3
  int=fac>0.9 and hii or
   ((fac>0.5 and ent~=1) and hii or
   ((fac>0.1 and ent==1) and hii or loi))
 else
  int=S3Round(di)
 end
 return int<=0 and 0 or
   mr.ramp[S3Clamp(int,1,#mr.ramp)]
end
function S3WallAdd(w)
 assert(w.lx) assert(w.lz) assert(w.rx) assert(w.rz)
 assert(w.tid)
 table.insert(S3.walls,w)
 _S3WallReg(w.lx,w.lz,w)
 _S3WallReg(w.rx,w.rz,w)
end
function S3WallDel(w) w.dead=true end
function _S3WallReg(x,z,w)
 local RADIUS=6
 local RADIUS2=RADIUS*RADIUS
 x,z=S3Round(x),S3Round(z)
 local centerC,centerR=x//S3.PVS_CELL,z//S3.PVS_CELL
 for r=centerR-RADIUS,centerR+RADIUS do
  for c=centerC-RADIUS,centerC+RADIUS do
   local dist2=(c-centerC)*(c-centerC)+
     (r-centerR)*(r-centerR)
   if dist2<=RADIUS2 then
    _S3PvsAdd(c,r,w)
   end
  end
 end
end
function _S3PvsAdd(c,r,w)
 local t=S3.pvstab[r*32768+c]
 if not t then
  t={}
  S3.pvstab[r*32768+c]=t
 end
 for i=1,#t do
  if t[i]==w then return end -- already in table
 end
 table.insert(t,w)
end
local _S3PvsGet_empty={}
function _S3PvsGet(x,z)
 x,z=S3Round(x),S3Round(z)
 local c,r=x//S3.PVS_CELL,z//S3.PVS_CELL
 return S3.pvstab[r*32768+c] or _S3PvsGet_empty;
end
function S3SetCam(ex,ey,ez,yaw)
 S3.ex,S3.ey,S3.ez,S3.yaw=ex,ey,ez,yaw
 S3.cosMy,S3.sinMy=cos(-yaw),sin(-yaw)
 S3.termA=-ex*S3.cosMy-ez*S3.sinMy
 S3.termB=ex*S3.sinMy-ez*S3.cosMy
end
function S3Proj(x,y,z)
 local c,s,a,b=S3.cosMy,S3.sinMy,S3.termA,S3.termB
 local px=0.9815*c*x+0.9815*s*z+0.9815*a
 local py=1.7321*y-1.7321*S3.ey
 local pz=s*x-z*c-b-0.2
 local pw=x*s-z*c-b
 local ndcx=px/abs(pw)
 local ndcy=py/abs(pw)
 return 120+ndcx*120,68-ndcy*68,pz
end
function S3Rend()
 local nowMs=time()
 S3.dt=S3.lastFT and (0.001*(nowMs-S3.lastFT)) or 16
 S3.lastFT=nowMs
 _S3PrepFlashes()
 local pvs=_S3PvsGet(S3.ex,S3.ez)
 local hbuf=S3.hbuf
 _S3PrepHbuf(hbuf,pvs)
 _S3RendOvers()
 _S3RendBills()
 _S3RendHbuf(hbuf)
 _S3RendFlats(hbuf)
 _S3PartsUpdate()
 _S3RendParts()
 S3.t=S3.t+1
end
function _S3ResetHbuf(hbuf)
 for x=S3.VP_L,S3.VP_R do
  hbuf[x+1]=hbuf[x+1] or {}
  local b=hbuf[x+1]
  b.wall=nil
  b.z=HUGE
 end
end
function _S3PrepFlashes()
 for i=#S3.flashes,1,-1 do
  local f=S3.flashes[i]
  local unused
  f.sx,unused,f.sz=S3Proj(f.x,S3.ey,f.z)
 end
end
function _S3ProjWall(w,boty,topy)
 topy=topy or S3.CEIL_Y
 boty=boty or S3.FLOOR_Y
 local nclip=S3.NCLIP
 local fclip=S3.FCLIP
 local lx,lz,rx,rz=w.lx,w.lz,w.rx,w.rz
 for try=1,2 do  -- second try is with z clipping
  local ltx,lty,ltz=S3Proj(lx,topy,lz)
  local rtx,rty,rtz=S3Proj(rx,topy,rz)
  if rtx<=ltx then return false end  -- cull back side
  if rtx<S3.VP_L or ltx>S3.VP_R then return false end
  local lbx,lby,lbz=S3Proj(lx,boty,lz)
  local rbx,rby,rbz=S3Proj(rx,boty,rz)
  w.slx,w.slz,w.slty,w.slby=ltx,ltz,lty,lby
  w.srx,w.srz,w.srty,w.srby=rtx,rtz,rty,rby
  if w.slz<nclip and w.srz<nclip
    then return false
  elseif w.slz>fclip and w.srz>fclip
    then return false
  elseif try==2 then return true
  elseif w.slz<nclip then -- left is nearer than nclip
   local cutsx=_S3Interp(w.slz,w.slx,w.srz,w.srx,nclip)
   local f=(cutsx-w.slx)/(w.srx-w.slx)
   lx,lz=lx+f*(rx-lx),lz+f*(rz-lz)
   w.clifs,w.clife=f,1
  elseif w.srz<nclip then -- right is nearer than nclip
   local cutsx=_S3Interp(w.slz,w.slx,w.srz,w.srx,nclip)
   local f=(cutsx-w.slx)/(w.srx-w.slx)
   rx,rz=lx+f*(rx-lx),lz+f*(rz-lz)
   w.clifs,w.clife=0,f
  else
   w.clifs,w.clife=0,1
   return true
  end
 end
end
function _S3AdjHbufIter(startx,endx)
 startx=S3Round(startx)
 endx=S3Round(endx)
 if startx<0 and endx<0 then return nil,nil,nil end
 if startx>=240 and endx>=240 then return nil,nil,nil end
 startx=max(startx,0)
 endx=min(endx,239)
 if not S3.ILEAVE then
  return startx,endx,1
 end
 if startx%2~=S3.t%2 then
  return startx+1,endx,2
 else
  return startx,endx,2
 end
end
function _S3PrepHbuf(hbuf,walls)
 _S3ResetHbuf(hbuf)
 for i=1,#walls do
  local w=walls[i]
  if not w.dead then
   if _S3ProjWall(w) then _AddWallToHbuf(hbuf,w) end
  end
 end
 for x=S3.VP_L,S3.VP_R do
  local hb=hbuf[x+1] -- hbuf is 1-indexed
  if hb.wall then
   local w=hb.wall
   hb.ty=S3Round(_S3Interp(w.slx,w.slty,w.srx,w.srty,x))
   hb.by=S3Round(_S3Interp(w.slx,w.slby,w.srx,w.srby,x))
  end
 end
end
function _AddWallToHbuf(hbuf,w)
 local startx=max(S3.VP_L,S3Round(w.slx))
 local endx=min(S3.VP_R,S3Round(w.srx))
 local step
 local nclip,fclip=S3.NCLIP,S3.FCLIP
 startx,endx,step=_S3AdjHbufIter(startx,endx)
 if not startx then return end
 for x=startx,endx,step do
  local hbx=hbuf[x+1]
  local z=_S3Interp(w.slx,w.slz,w.srx,w.srz,x)
  if z>nclip and z<fclip then
   if hbx.z>z then  -- depth test.
    hbx.z,hbx.wall=z,w  -- write new depth.
   else
   end
  end
 end
end
function _S3RendHbuf(hbuf)
 local startx,endx,step=_S3AdjHbufIter(S3.VP_L,S3.VP_R)
 if not startx then return end
 for x=startx,endx,step do
  local hb=hbuf[x+1]  -- hbuf is 1-indexed
  local w=hb.wall
  if w then
   local z=_S3Interp(w.slx,w.slz,w.srx,w.srz,x)
   local u=_S3PerspTexU(w,x)
   _S3RendTexCol(w.tid,x,hb.ty,hb.by,u,z,nil,nil,nil,
     nil,nil,w.cmt)
  end
 end
end
function _S3StencilInit()
 for i=1,240*136+1 do S3.stencil[i]=-1 end
end
function _S3StencilRead(x,y)
 return S3.stencil[240*y+x+1]==S3.t
end
function _S3StencilWrite(x,y)
 if x>=0 and y>=0 and x<240 and y<136 then
  S3.stencil[240*y+x+1]=S3.t
 end
end
function S3BillAdd(bill)
 assert(bill.x and bill.y and bill.z and bill.w and
  bill.h and bill.tid)
 table.insert(S3.bills,bill)
 return bill
end
function S3BillDel(bill)
 local bills=S3.bills
 for i=1,#bills do
  if bills[i]==bill then
   bills[i]=bills[#bills]
   table.remove(bills)
   return true
  end
 end
 return false
end
function S3OverAdd(over)
 assert(over.sx) assert(over.sy) assert(over.tid)
 over.scale=over.scale or 1
 table.insert(S3.overs,over)
 return over
end
function S3FlashAdd(flash)
 assert(flash.x)
 assert(flash.z)
 assert(flash.int)
 assert(flash.fod2)
 table.insert(S3.flashes,flash)
 return flash
end
function S3FlashDel(flash)
 for i=1,#S3.flashes do
  if S3.flashes[i]==flash then
   S3.flashes[i]=S3.flashes[#S3.flashes]
   table.remove(S3.flashes)
   return
  end
 end
end
function _S3RendBill(b)
 if b.slx<S3.VP_L and b.srx<S3.VP_L or 
   b.slx>S3.VP_R and b.srx>S3.VP_R
   then return end
 local lx,rx,z=b.slx,b.srx,b.sz
 local startx,endx,step=_S3AdjHbufIter(lx,rx)
 if not startx then return end
 local tid=b.tid
 local ty,by=b.sty,b.sby
 local hbuf=S3.hbuf
 for x=startx,endx,step do
  local hb=hbuf[x+1] -- 1-indexed
  if not hb or not hb.wall or hb.z>z then
   local u=_S3Interp(lx,0,rx,1,x)
   if _S3RendTexCol(tid,x,ty,by,u,z,nil,nil,
     0,true,b.clrO,b.cmt) then b.vis=true end
  end
 end
end
function _S3RendOvers()
 local overs=S3.overs
 for i=1,#overs do _S3RendOver(overs[i]) end
end
function _S3RendOver(o)
 local td=S3.TEX[o.tid]
 assert(td)
 local scale=o.scale
 local w=td.w*scale
 local h=td.h*scale
 local lx,rx=o.sx,o.sx+w-1
 local startx,endx,step=_S3AdjHbufIter(lx,rx)
 if not startx then return end
 for x=startx,endx,step do
  for y=o.sy,o.sy+h-1 do
   local t=_S3GetTexel(o.tid,(x-lx)//scale,
     (y-o.sy)//scale)
   if t>0 then
    pix(x,y,t)
    _S3StencilWrite(x,y)
   end
  end
 end
end
function _S3ProjBill(b)
 b.sx,b.sy,b.sz=S3Proj(b.x,b.y,b.z)
 b.sw=117.78*b.w/b.sz
 b.sh=117.78*b.h/b.sz
 b.slx,b.srx=S3Round(b.sx-0.5*b.sw),
   S3Round(b.sx+0.5*b.sw)
 b.sty,b.sby=S3Round(b.sy-0.5*b.sh),
   S3Round(b.sy+0.5*b.sh)
end
function _S3RendBills()
 local nclip,fclip=S3.NCLIP,S3.FCLIP
 local bills=S3.bills
 local r={}
 for i=1,#bills do
  local b=bills[i]
  b.vis=false
  _S3ProjBill(b)
  if b.slx<=S3.VP_R and b.srx>=S3.VP_L and
    b.sz>nclip and b.sz<fclip then
   _S3BillIns(r,b)  -- potentially visible
  end
 end
 for i=1,#r do
  _S3RendBill(r[i])
 end
 S3.zobills=r
end
function _S3BillIns(l,b)
 for i=1,#l do
  if l[i].sz>b.sz then table.insert(l,i,b) return end
 end
 table.insert(l,b)
end
function _S3LightF(sx,sz)
 local FOG_S,FOG_E=S3.FOG_S,S3.FOG_E
 local csx=120-sx -- centered sx
 local d2=csx*csx+sz*sz
 if S3.FLIC_AMP>0 then
  local f=sin(time()*S3.FLIC_FM)*S3.FLIC_AMP
  d2=d2+f
 end
 local f=d2<FOG_S and 1 or
   _S3Interp(FOG_S,1,FOG_E,0,d2)
 for i=1,#S3.flashes do
  local flash=S3.flashes[i]
  local d2f=(flash.sx-sx)*(flash.sx-sx)+
    (flash.sz-sz)*(flash.sz-sz)
  local int=_S3Interp(0,flash.int,flash.fod2,0,d2f)
  f=f+int
 end
 return f
end
function _S3RendTexCol(tid,x,ty,by,u,z,v0,v1,ck,
    wsten,clrO,cmt)
 ty=S3Round(ty)
 by=S3Round(by)
 local td=S3.TEX[tid]
 assert(td)
 local lf=_S3LightF(x,z)
 local aty,aby=max(ty,S3.VP_T),min(by,S3.VP_B)
 if lf<=0 then
  for y=aty,aby do
   if not _S3StencilRead(x,y) then pix(x,y,0) end
  end
  return false
 end
 v0,v1,ck=v0 or 0,v1 or 1,ck or -1
 local drew=false
 for y=aty,aby do
  if not _S3StencilRead(x,y) then
   local v=_S3Interp(ty,v0,by,v1,y)
   local clr=_S3TexSamp(tid,td,u,v)
   clr=(cmt and cmt[clr]) or clr
   if clr~=ck then
    if not clrO then
     clr=_S3ClrMod(clr,lf,x,y)
    end
    pix(x,y,clrO or clr)
    drew=true
    if wsten then _S3StencilWrite(x,y) end
   end
  end
 end
 return drew
end
function _S3PerspTexU(w,x)
 local us,ue=w.clifs,w.clife
 local a=_S3Interp(w.slx,us,w.srx,ue,x)
 local oma=1-a
 local u0,u1=us,ue
 local iz0,iz1=1/w.slz,1/w.srz
 local u=(oma*u0*iz0+a*u1*iz1)/(oma*iz0+a*iz1)
 return u
end
function _S3FlatFact(x,y)
 local z=3000/(y-68)  -- manually calculated
 return _S3LightF(x,z)
end
function _S3RendFlats(hbuf)
 local scrw,scrh=SCRW,SCRH
 local ceilC,floorC=S3.CEIL_CLR,S3.FLOOR_CLR
 local startx,endx,step=_S3AdjHbufIter(S3.VP_L,S3.VP_R)
 if not startx then return end
 for x=startx,endx,step do
  local cby=scrh//2 -- ceiling bottom y
  local fty=scrh//2+1 -- floor top y
  local hb=hbuf[x+1] -- hbuf is 1-indexed
  if hb.wall then
   cby=min(cby,hb.ty)
   fty=max(fty,hb.by)
  end
  for y=S3.VP_T,cby do
   if not _S3StencilRead(x,y) then pix(x,y,ceilC) end
  end
  for y=fty,S3.VP_B do
   if not _S3StencilRead(x,y) then
    pix(x,y,_S3ClrMod(floorC,_S3FlatFact(x,y),x,y))
   end
  end
 end
end
function S3PartsSpawn(cx,cy,cz,spec)
 assert(spec.count)
 assert(spec.minR)
 assert(spec.maxR)
 assert(spec.minSpd)
 assert(spec.maxSpd)
 assert(spec.fall)
 assert(spec.clr)
 assert(spec.ttl)
 assert(spec.size)
 local parts=S3.parts
 local pool=S3.partPool
 for i=1,spec.count do
  local r=spec.minR+(spec.maxR-spec.minR)*random()
  local phi=random()*6.28
  local theta=random()*6.28
  local p
  if #pool>0 then
   p=pool[#pool]
   table.remove(pool)
  else p={} end
  local ux,uy,uz=sin(theta)*cos(phi),
    sin(theta)*sin(phi),cos(theta)
  p.x,p.y,p.z=cx+ux*r,cy+uy*r,cz+uz*r
  local spd=spec.minSpd+
    (spec.maxSpd-spec.minSpd)*random()
  p.vx,p.vy,p.vz=ux*spd,uy*spd,uz*spd
  p.ax,p.ay,p.az=0,(spec.fall and -200 or 0),0
  if #spec.clr then
   p.clr=spec.clr[random(1,#spec.clr)]
  else
   p.clr=spec.clr
  end
  p.ttl=spec.ttl
  p.size=spec.size
  table.insert(parts,p)
 end
end
function _S3PartsUpdate()
 local parts=S3.parts
 local pool=S3.partPool
 local dt=S3.dt
 local floorY=S3.FLOOR_Y
 for i=#parts,1,-1 do
  local p=parts[i]
  p.ttl=p.ttl-dt
  p.vx,p.vy,p.vz=p.vx+p.ax*dt,p.vy+p.ay*dt,p.vz+p.az*dt
  p.x,p.y,p.z=p.x+p.vx*dt,p.y+p.vy*dt,p.z+p.vz*dt
  if p.ttl<0 or p.y<floorY then
   parts[i]=parts[#parts]
   table.remove(parts)
   table.insert(pool,p)
  end
 end
end
function _S3RendParts()
 local parts=S3.parts
 local vpL,vpT,vpR,vpB=S3.VP_L,S3.VP_T,S3.VP_R,S3.VP_B
 local nclip,fclip=S3.NCLIP,S3.FCLIP
 for i=1,#parts do
  local p=parts[i]
  local sx,sy,sz=S3Proj(p.x,p.y,p.z)
  if sx>vpL and sx+p.size<vpR and sy>=vpT and
    sy+p.size<vpB and sz>nclip and sz<fclip then
   if p.size==1 then pix(sx,sy,p.clr)
   else rect(sx,sy,p.size,p.size,p.clr) end
  end
 end
end
function S3Round(x) return floor(x+0.5) end
function S3Clamp(x,lo,hi)
 return x<lo and lo or (x>hi and hi or x)
end
function _S3Interp(x1,y1,x2,y2,x)
 if x2<x1 then
  x1,x2=x2,x1
  y1,y2=y2,y1
 end
 return x<=x1 and y1 or (x>=x2 and y2 or
   (y1+(y2-y1)*(x-x1)/(x2-x1)))
end
function _S3TexSamp(tid,td,u,v)
 local SX,SY=td.w,td.h
 local tx=floor(u*SX)%SX
 local ty=floor(v*SY)%SY
 return _S3GetTexel(tid,tx,ty)
end
function _S3GetTexel(tid,texx,texy)
 local spid=tid+(texy//8)*16+(texx//8)
 texx=texx%8
 texy=texy%8
 return peek4(0x8000+spid*64+texy*8+texx)
end
function S3Dot(ax,az,bx,bz)
 return ax*bx+az*bz
end
function S3Norm(x,z)
 return sqrt(x*x+z*z)
end
function S3Normalize(x,z)
 local l=S3Norm(x,z)
 return x/l,z/l
end
local D_INVULN=false
local D_SHOWFPS=false
local D_STARTGREN=nil
local D_HCL=nil
local D_HASKEY=false
local D_NOAWAKE=false
local D_CLEARPMEM=false
local TSIZE=50
local PLR_CS=20
local FLOOR_Y=S3.FLOOR_Y
local CEIL_Y=S3.CEIL_Y
local ORIG_PAL={
 [0]=0x140c1c, [1]=0x2c2c2c, [2]=0x716d69,
 [3]=0xaaaeaa, [4]=0x04ff04, [5]=0x04ce04,
 [6]=0x008100, [7]=0x004000, [8]=0x382800,
 [9]=0x693800, [10]=0x9d5500, [11]=0xc28900,
 [12]=0x00e6ff, [13]=0xbabe10, [14]=0xeaea5e,
 [15]=0xdeeed6,
}
local BTN={
 FWD=0, BACK=1, LEFT=2, RIGHT=3,
 FIRE=4, LOB=5,
 STRAFE=6, OPEN=7,
}
local PLR_ATK={
 {tid=TID.CBOW_D,t=0.2,fire=false},
 {tid=TID.CBOW_E,t=0.5,fire=true}
}
local MODE={
 TITLE=0,   -- title screen.
 LVLSEL=1,  -- level select screen.
 PREROLL=2, -- level name preroll.
 INSTRUX=3, -- instructions screen.
 PLAY=4,    -- playing level.
 DEAD=5,    -- player is dead.
 MINIMAP=6, -- showing minimap.
 EOL=7,     -- end of level.
 WIN=8,     -- beat entire game.
}
local MUS={
 KEEP=-2,   -- keep playing previous.
 NONE=-1,   -- no music.
 PLAY=0,    -- gameplay music.
 TITLE=1,   -- main title.
}
local MODEMUS={
 [MODE.TITLE]=MUS.TITLE,
 [MODE.LVLSEL]=MUS.KEEP,
 [MODE.PREROLL]=MUS.NONE,
 [MODE.INSTRUX]=MUS.NONE,
 [MODE.PLAY]=MUS.PLAY,
 [MODE.DEAD]=MUS.NONE,
 [MODE.MINIMAP]=MUS.KEEP,
 [MODE.EOL]=MUS.NONE,
 [MODE.WIN]=MUS.NONE,
}
local A={  -- A for "App"
 mode=MODE.TITLE,
 mclk=0,   -- time elapsed in current mode
 lftime=-1,  -- last frame time, -1 if none.
 sel=1,    -- current selection in menu
}
local G=nil  -- deep copied from G_INIT
local G_INIT={
 ex=350, ey=25, ez=350, yaw=30,
 lftime=-1,  -- last frame time
 clk=0, -- game clock, seconds
 lvlNo=0,
 lvl=nil,
 iwalls={},
 doorAnim=nil,
 PSPD=120,PASPD=2.0,
 ents={},
 hp=75,
 ammo=20,
 grens=D_STARTGREN or 5,
 lastGrenT=-999,
 justHurt=nil,
 weapOver=nil,
 atk=0,
 atke=0,
 msg="",
 msgCd=0,
 hasKey=D_HASKEY or false,
 flash=nil,
 focC=nil,focR=nil,
 minimapC=0,
 mmox,mmoy=0,0,
 mmseen={},
 otiles={},
 spawners={},
 trigdone={},
}
local T={
 VOID=0,     -- void tiles on map (player can't
 FLOOR=16,   -- floor tile on map (space where player
 TRIGGER=7,  -- trigger tile (triggers spawners)
 SPAWNER=6,  -- spawner (spawns entities)
}
local S={
 FLAG=240,
 META_0=241,
 HUD_KEY=230,
 LOCK=188,
 ARROW=187,
}
local E={
 ZOMB=32,
 POTION=48,
 AMMO=64,
 DEMON=49,
 KEY=65,
 SPITTER=50,
 GREN_BOX=66,
 PILLAR=51,
 TREE=67,
 PORTAL=80,
 FOUNT=81,
 BIGZOMB=82,
 ARROW=1000,
 FIREBALL=1001,
 GREN=1002,
}
local MMTILES={
 [T.FLOOR]=true,
 [E.PILLAR]=true,
 [E.TREE]=true,
 [E.PORTAL]=true,
 [E.KEY]=true,
}
local ANIM={
 ZOMBW={inter=0.2,tids={TID.CYC_W1,TID.CYC_W2}},
 POTION={inter=0.2,tids={TID.POTION_1,TID.POTION_2}},
 AMMO={inter=0.2,tids={TID.AMMO_1,TID.AMMO_2}},
 DEMON={inter=0.2,tids={TID.DEMON_1,TID.DEMON_2}},
 KEY={inter=0.2,tids={TID.KEY_1,TID.KEY_2}},
 SPITTER={inter=0.2,tids={TID.SPITTER_1,
  TID.SPITTER_2}},
 FIREBALL={inter=0.2,tids={TID.FIREBALL_1,
  TID.FIREBALL_2}},
 PORTAL={inter=0.2,tids={TID.PORTAL_1,TID.PORTAL_2,
  TID.PORTAL_3,TID.PORTAL_2}},
 FOUNT={inter=0.2,tids={TID.FOUNT_1,TID.FOUNT_2,TID.FOUNT_3}},
}
local SND={
 ARROW={sfx=63,note="C-4",dur=6,vol=15,spd=0},
 HIT={sfx=62,note="E-3",dur=6,vol=15,spd=0},
 KILL={sfx=62,note="C-2",dur=12,vol=15,spd=-2},
 BONUS={sfx=61,note="C-4",dur=6,vol=15,spd=-2},
 HURT={sfx=60,note="C-6",dur=6,vol=15,spd=-2},
 DOOR={sfx=59,note="C-2",dur=6,vol=15,spd=-1},
 DIE={sfx=58,note="E-2",dur=30,vol=15,spd=-1},
 BOOM={sfx=57,note="G-3",dur=30,vol=15,spd=-2},
 SPIT={sfx=56,note="C-2",dur=6,vol=15,spd=1},
 FAIL={sfx=55,note="C-2",dur=10,vol=15,spd=0},
 EOL={sfx=54,note="F-2",dur=30,vol=15,spd=-2},
}
local YANCH={
 FLOOR=0,   -- entity anchors to the floor
 CENTER=1,  -- entity is centered vertically
 CEIL=2,    -- entity anchors to the ceiling
}
local ECFG_DFLT={
 yanch=YANCH.FLOOR,
}
local ECFG={
 [E.ZOMB]={
  w=50,h=50,
  anim=ANIM.ZOMBW,
  pursues=true,
  idealDist2=2500,
  wanderTime=0.5,
  wanderOnHurt=true,
  speed=50,
  attacks=true,
  dmgMin=5,dmgMax=15,
  hp=20,
  vuln=true,
  solid=true,
  asleep=true,
  attseq={
   {t=0.3,tid=TID.CYC_PRE},
   {t=0.5,tid=TID.CYC_ATK,dmg=true},
   {t=0.8,tid=TID.CYC_W1},
  },
 },
 [E.BIGZOMB]={
  w=60,h=70,
  anim=ANIM.ZOMBW,
  cmt={[5]=14,[6]=11,[7]=10,[4]=14},
  pursues=true,
  idealDist2=2500,
  wanderTime=0.2,
  wanderOnHurt=true,
  speed=50,
  attacks=true,
  dmgMin=10,dmgMax=25,
  hp=100,
  vuln=true,
  solid=true,
  asleep=true,
  attseq={
   {t=0.3,tid=TID.CYC_PRE},
   {t=0.5,tid=TID.CYC_ATK,dmg=true},
   {t=0.8,tid=TID.CYC_W1},
  },
 },
 [E.DEMON]={
  w=20,h=20,
  yanch=YANCH.CENTER,
  anim=ANIM.DEMON,
  pursues=true,
  idealDist2=2500,
  wanderTime=1.2,
  speed=50,
  attacks=true,
  dmgMin=5,dmgMax=15,
  hp=20,
  asleep=true,
  vuln=true,
  solid=true,
  attseq={
   {t=0.3,tid=TID.DEMON_PRE},
   {t=0.5,tid=TID.DEMON_ATK,dmg=true},
   {t=0.8,tid=TID.DEMON_2},
  },
 },
 [E.SPITTER]={
  w=20,h=20,
  yanch=YANCH.CENTER,
  anim=ANIM.SPITTER,
  pursues=true,
  idealDist2=80000,
  wanderTime=4,
  speed=70,
  attacks=false,
  shoots=true,
  shot=E.FIREBALL,
  shotInt=2.0,
  shotSpd=200,
  shotSnd=SND.SPIT,
  hp=20,
  vuln=true,
  solid=true,
  asleep=true,
  attseq={
   {t=0.3,tid=TID.SPITTER_PRE},
   {t=0.5,tid=TID.SPITTER_ATK,dmg=true},
   {t=0.8,tid=TID.SPITTER_2},
  },
 },
 [E.ARROW]={
  w=8,h=8,
  ttl=2,
  tid=TID.ARROW,
  yanch=YANCH.CENTER,
 },
 [E.POTION]={
  w=16,h=16,
  anim=ANIM.POTION,
 },
 [E.AMMO]={
  w=16,h=16,
  anim=ANIM.AMMO,
 },
 [E.KEY]={
  w=16,h=8,
  anim=ANIM.KEY,
 },
 [E.FIREBALL]={
  w=8,h=8,
  anim=ANIM.FIREBALL,
  ttl=2,
  yanch=YANCH.CENTER,
  hurtsPlr=true, dmgMin=5, dmgMax=15,collRF=3,
  fragile=true,  -- can't go through solid tiles
 },
 [E.GREN]={
  w=8,h=8,
  tid=TID.GREN,
  yanch=YANCH.CENTER,
  falls=true,
  fallVy0=40,
 },
 [E.GREN_BOX]={
  w=16,h=16,
  tid=TID.GREN_BOX,
 },
 [E.PILLAR]={
  w=12,h=50,
  tid=TID.PILLAR,
  solid=true,
 },
 [E.PORTAL]={
  w=48,h=48,
  anim=ANIM.PORTAL,
 },
 [E.TREE]={
  w=20,h=40,
  tid=TID.TREE,
  solid=true,
 },
 [E.FOUNT]={
  w=30,h=30,
  anim=ANIM.FOUNT,
  solid=true,
 },
}
local TF={
 N=1,E=2,S=4,W=8,
 NSLD=0x10,
 DOOR=0x20,
 LOCKED=0x40,
 LEVER=0x80,
 GATE=0x100,
 PORTAL=0x200,
}
TF.INTEREST=TF.DOOR|TF.LEVER|TF.GATE|TF.PORTAL
local TD={
 [1]={f=TF.S|TF.E,tid=TID.STONE},
 [2]={f=TF.S,tid=TID.STONE},
 [3]={f=TF.S|TF.W,tid=TID.STONE},
 [17]={f=TF.E,tid=TID.STONE},
 [19]={f=TF.W,tid=TID.STONE},
 [33]={f=TF.N|TF.E,tid=TID.STONE},
 [34]={f=TF.N,tid=TID.STONE},
 [35]={f=TF.N|TF.W,tid=TID.STONE},
 [55]={f=TF.S|TF.E,tid=TID.WOOD},
 [56]={f=TF.S,tid=TID.WOOD},
 [57]={f=TF.S|TF.W,tid=TID.WOOD},
 [71]={f=TF.E,tid=TID.WOOD},
 [73]={f=TF.W,tid=TID.WOOD},
 [87]={f=TF.N|TF.E,tid=TID.WOOD},
 [88]={f=TF.N,tid=TID.WOOD},
 [89]={f=TF.N|TF.W,tid=TID.WOOD},
 [5]={f=TF.S|TF.DOOR,tid=TID.DOOR},
 [20]={f=TF.E|TF.DOOR,tid=TID.DOOR},
 [22]={f=TF.W|TF.DOOR,tid=TID.DOOR},
 [37]={f=TF.N|TF.DOOR,tid=TID.DOOR},
 [8]={f=TF.S|TF.DOOR|TF.LOCKED,tid=TID.LDOOR},
 [23]={f=TF.E|TF.DOOR|TF.LOCKED,tid=TID.LDOOR},
 [25]={f=TF.W|TF.DOOR|TF.LOCKED,tid=TID.LDOOR},
 [40]={f=TF.N|TF.DOOR|TF.LOCKED,tid=TID.LDOOR},
 [11]={f=TF.S|TF.LEVER,tid=TID.LEVER},
 [26]={f=TF.E|TF.LEVER,tid=TID.LEVER},
 [28]={f=TF.W|TF.LEVER,tid=TID.LEVER},
 [43]={f=TF.N|TF.LEVER,tid=TID.LEVER},
 [53]={f=TF.S|TF.GATE,tid=TID.GATE},
 [68]={f=TF.E|TF.GATE,tid=TID.GATE},
 [70]={f=TF.W|TF.GATE,tid=TID.GATE},
 [85]={f=TF.N|TF.GATE,tid=TID.GATE},
 [E.PORTAL]={f=TF.PORTAL|TF.NSLD},
}
local LVL={
 {
  name="The Dungeons",
  pg=0,pgw=1,pgh=2,
  floorC=9,ceilC=0,
 },
 {
  name="The Garden",
  pg=1,pgw=1,pgh=2,
  floorC=7,ceilC=0,
  wallCmt={
   [TID.STONE]={[2]=6},
  },
 },
 {
  name="The City",
  pg=2,pgw=1,pgh=2,
  floorC=2,ceilC=0,
 },
}
DEBUGS=nil
local PFX={
 KILL={
  count=30,minR=5,maxR=20,minSpd=40,maxSpd=100,
  fall=true,clr={4,5,6},ttl=2,size=2,
 },
 BLAST={
  count=50,minR=5,maxR=20,minSpd=150,maxSpd=200,
  fall=true,clr={14,15,11},ttl=2,size=4,
 },
}
function EntAdd(etype,x,z)
 local e=Overlay({},
   Overlay(ECFG_DFLT,ECFG[etype] or {}))
 e.x,e.z=x,z
 e.y=e.yanch==YANCH.FLOOR and FLOOR_Y+e.h*0.5
   or (e.yanch==YANCH.CEIL and CEIL_Y-e.h*0.5
   or (FLOOR_Y+CEIL_Y)*0.5)
 e.tid=e.anim and e.anim.tids[1] or e.tid
 e.etype=etype
 e.ctime=G.clk
 e.bill={x=e.x,y=e.y,z=e.z,w=e.w,h=e.h,
  tid=e.tid,ent=e,cmt=e.cmt}
 S3BillAdd(e.bill)
 table.insert(G.ents,e)
 return e
end
function CheckEntHits()
 local ents=G.ents
 for i=1,#ents do
  local e=ents[i]
  if e.etype==E.ARROW then CheckArrowHit(e)
  elseif e.etype==E.GREN then CheckGrenBlast(e)
  elseif e.etype==E.POTION or e.etype==E.AMMO or
    e.etype==E.KEY or e.etype==E.GREN_BOX then
   CheckPickUp(e)
  end
 end
end
function CalcHitTarget(proj)
 local ents=G.ents
 local zob=S3.zobills
 for i=1,#zob do
  local e=zob[i].ent
  if not e.dead and e.vuln and e.bill.vis and
     ProjHitEnt(proj,e) then
   return e
  end
 end
 return nil
end
function CheckArrowHit(arrow)
 local e=CalcHitTarget(arrow)
 if not e then return end
 arrow.dead=true
 local age=G.clk-arrow.ctime
 local dmg=max(1,S3Round(10-age*20))
 HurtEnt(e,dmg)
end
function HurtEnt(e,dmg)
 e.hp=e.hp-dmg
 e.hurtT=G.clk
 if e.hp<0 then
  e.dead=true
  Snd(SND.KILL)
  S3PartsSpawn(e.x,e.y,e.z,PFX.KILL)
 else
  Snd(SND.HIT)
  if e.wanderOnHurt then
   EntStartWander(e,0.3)
  end
 end
end
function CheckPickUp(item)
 if DistSqToPlr(item.x,item.z)<400 then
  if item.etype==E.POTION then
   G.hp=min(99,G.hp+15)
   Say("Healing potion +15")
   item.dead=true
   Snd(SND.BONUS)
  elseif item.etype==E.AMMO then
   G.ammo=min(50,G.ammo+5)
   Say("Arrows +5")
   item.dead=true
   Snd(SND.BONUS)
  elseif item.etype==E.KEY then
   G.hasKey=true
   Say("PICKED UP A KEY.")
   item.dead=true
   Snd(SND.BONUS)
  elseif item.etype==E.GREN_BOX then
   G.grens=min(G.grens+3,20)
   Say("Flame orbs +3")
   item.dead=true
   Snd(SND.BONUS)
  end
 end
end
function ProjHitEnt(p,e)
 local dt=G.dt
 local r2=0.25*e.w*e.w
 for u=0,100,25 do
  local px,pz=p.x-G.dt*p.vx*u*0.01,
   p.z-G.dt*p.vz*u*0.01
  if r2>DistSqXZ(px,pz,e.x,e.z) then return true end
 end
 return false
end
function UpdateEnts()
 local ents=G.ents
 UpdateFlash()
 for i=1,#ents do
  local e=ents[i]
  UpdateEnt(e)
  if not D_NOAWAKE then
   e.asleep=e.asleep and not e.bill.vis
  end
 end
 for i=#ents,1,-1 do
  if ents[i].dead then
   ents[i].bill.ent=nil  -- break cycle, help GC
   S3BillDel(ents[i].bill)
   ents[i]=ents[#ents]
   table.remove(ents)
  end
 end
end
function CheckGrenBlast(gren)
 local BLASTR2=30000  -- blast radius, squared
 local VBLASTR2=45000 -- visual blast radius, squared
 local solid=IsInSolidTile(gren.x,gren.z)
 local et=CalcHitTarget(gren)
 if not solid and not et and
   gren.y>FLOOR_Y then return end
 gren.dead=true
 if G.flash then S3FlashDel(G.flash) end
 G.flash=S3FlashAdd({x=gren.x,z=gren.z,
  int=10,fod2=VBLASTR2})
 for i=1,#G.ents do
  local e=G.ents[i]
  if e.vuln and e.bill.vis and e.hp then
   local d2=DistSqXZ(e.x,e.z,gren.x,gren.z)
   local dmg=(e==et and 40 or 10)
   if d2<BLASTR2 then HurtEnt(e,dmg) end
  end
 end
 Snd(SND.BOOM)
 S3PartsSpawn(gren.x,gren.y,gren.z,PFX.BLAST)
end
function UpdateFlash()
 local f=G.flash
 if not f then return end
 f.int=f.int-30*G.dt
 if f.int<0 then
  G.flash=nil
  S3FlashDel(f)
 end
end
function UpdateEnt(e)
 UpdateEntAnim(e)
 if not e.asleep then
  if e.pursues then EntBehPursues(e) end
  if e.attacks then EntBehAttacks(e) end
  if e.vx and e.vz then EntBehVel(e) end
  if e.shoots then EntBehShoots(e) end
  if e.hurtsPlr then EntBehHurtsPlr(e) end
  if e.falls then EntBehFalls(e) end
  if e.fragile then EntBehFragile(e) end
  if e.ttl then EntBehTtl(e) end
 end
 e.bill.x,e.bill.y,e.bill.z=e.x,e.y,e.z
 e.bill.w,e.bill.h=e.w,e.h
 e.bill.tid=e.tid
 e.bill.clrO=(e.hurtT and G.clk-e.hurtT<0.1) and
   14 or nil
end
function UpdateEntAnim(e)
 if e.anim then
  local frs=floor((G.clk-e.ctime)/e.anim.inter)
  e.tid=e.anim.tids[1+frs%#e.anim.tids]
 end
end
function EntBehFragile(e)
 if IsInSolidTile(e.x,e.z) then e.dead=true end
end
function EntBehPursues(e)
 if not e.speed then return end
 local ideald2=e.idealDist2 or 2500
 local dist2=DistSqXZ(e.x,e.z,G.ex,G.ez)
 if dist2>250000 then return end
 local dt=G.dt
 if e.pursueWcd then
  e.pursueWcd=e.pursueWcd-dt
  if e.pursueWcd<0 then e.pursueWcd=nil end
  local px,pz=e.x+e.pursueWvx*dt,
    e.z+e.pursueWvz*dt
  if IsPosValid(px,pz,e) then
   e.x,e.z=px,pz
   return
  end
  e.pursueWcd=nil
 end
 local bestx,bestz,bestd2,bestmx,bestmz=
   nil,nil,nil,nil,nil
 for mz=-1,1 do
  for mx=-1,1 do
   local px,pz=e.x+mx*e.speed*dt,
     e.z+mz*e.speed*dt
   if IsPosValid(px,pz,e) then
    local d2=DistSqToPlr(px,pz)
    if not bestd2 or
      abs(d2-ideald2)<abs(bestd2-ideald2) then
     bestx,bestz,bestd2,bestmx,bestmz=px,pz,d2,mx,mz
    end
   end
  end
 end
 if not bestx or (bestmx==0 and bestmz==0) then
  EntStartWander(e)
  return
 end
 e.x,e.z=bestx,bestz
end
function EntStartWander(e,time)
 e.pursueWcd=time or (e.wanderTime or 2)
 local phi=random()*6.28
 e.pursueWvx=e.speed*cos(phi)
 e.pursueWvz=e.speed*sin(phi)
end
function EntBehVel(e)
 e.x=e.x+e.vx*G.dt
 e.z=e.z+e.vz*G.dt
end
function EntBehTtl(e)
 e.ttl=e.ttl-G.dt
 if e.ttl<0 then e.dead=true end
end
function EntBehAttacks(e)
 if not e.att then
  local dist2=DistSqXZ(e.x,e.z,G.ex,G.ez)
  if dist2>3000 then return end -- too far.
  e.origAnim=e.anim
  e.att=1
  e.atte=0 -- elapsed
  e.anim=nil
 end
 e.atte=e.atte+G.dt
 if e.atte>e.attseq[e.att].t then
  e.att=e.att+1
  if e.att>#e.attseq then
   e.att=nil
   e.anim=e.origAnim
  elseif e.attseq[e.att].dmg then
   HurtPlr(random(e.dmgMin,e.dmgMax))
  end
 end
 if e.att then e.tid=e.attseq[e.att].tid end
end
function EntBehShoots(e)
 assert(e.shot)
 assert(e.shotInt)
 assert(e.shotSpd)
 e.shootC=(e.shootC or e.shotInt)-G.dt
 if e.shootC>0 then return end
 e.shootC=e.shotInt
 local vx,vz=V2Normalize(G.ex-e.x,G.ez-e.z)
 local shot=EntAdd(e.shot,e.x,e.z)
 shot.vx,shot.vz=vx*e.shotSpd,vz*e.shotSpd
 if e.shotSnd and DistSqToPlr(e.x,e.z)<80000 then
  Snd(e.shotSnd)
 end
end
function EntBehHurtsPlr(e)
 local d2=DistSqToPlr(e.x,e.z)
 local r=(e.collRF or 1)*e.w*0.5
 if d2<r*r then
  HurtPlr(random(e.dmgMin,e.dmgMax))
  e.dead=true
 end
end
function EntBehFalls(e)
 local gacc=e.fallAcc or -150
 local spd=(e.fallVy0 or 0)+gacc*(G.clk-e.ctime)
 e.y=e.y+spd*G.dt
end
function AddWalls(c,r,td)
 local s=TSIZE
 local xw,xe=c*s,(c+1)*s -- x of east and west
 local zn,zs=r*s,(r+1)*s -- z of north and south
 local interest=(0~=td.f&TF.DOOR) or
   (0~=td.f&TF.LEVER) or (0~=td.f&TF.GATE)
 if 0~=(td.f&TF.N) then
  AddWall({lx=xe,rx=xw,lz=zn,rz=zn,tid=td.tid},
   c,r,interest)
 end
 if 0~=(td.f&TF.S) then
  AddWall({lx=xw,rx=xe,lz=zs,rz=zs,tid=td.tid},
   c,r,interest)
 end
 if 0~=(td.f&TF.E) then
  AddWall({lx=xe,rx=xe,lz=zs,rz=zn,tid=td.tid},
   c,r,interest)
 end
 if 0~=(td.f&TF.W) then
  AddWall({lx=xw,rx=xw,lz=zn,rz=zs,tid=td.tid},
   c,r,interest)
 end
end
function AddWall(w,c,r,interest)
 S3WallAdd(w)
 if interest then IwallAdd(c,r,w) end
 if G.lvl.wallCmt then w.cmt=G.lvl.wallCmt[w.tid] end
end
function IwallAdd(c,r,w) G.iwalls[r*240+c]=w end
function IwallAt(c,r) return G.iwalls[r*240+c] end
function IwallDel(c,r) G.iwalls[r*240+c]=nil end
function DoorOpen(c,r)
 local w=IwallAt(c,r)
 if not w then return false end
 local t=LvlTile(c,r)
 if TD[t] and 0~=TD[t].f&TF.LOCKED and
   not G.hasKey then
  Say("***You need a key***")
  return false
 end
 G.doorAnim={w=w,phi=0,irx=w.rx,irz=w.rz}
 LvlTile(c,r,T.FLOOR)  -- becomes floor tile
 IwallDel(c,r)
 Snd(SND.DOOR)
 return true
end
function DoorAnimUpdate(dt)
 local anim=G.doorAnim
 if not anim then return end
 anim.phi=anim.phi+dt*1.5
 local phi=min(anim.phi,1.5)
 anim.w.rx,anim.w.rz=RotPoint(
  anim.w.lx,anim.w.lz,anim.irx,anim.irz,-phi)
 if anim.phi>1.5 then
  G.doorAnim=nil
  return
 end
end
function GetFocusTile()
 local fx,fz=PlrFwdVec(TSIZE)
 local c,r=
   floor((G.ex+fx)/TSIZE),floor((G.ez+fz)/TSIZE)
 local t=LvlTile(c,r)
 local td=TD[t]
 if not td then return nil,nil end
 if 0~=td.f&TF.INTEREST then return c,r
 else return nil,nil end
end
function UpdateFocusTile()
 G.focC,G.focR=GetFocusTile()
end
function Interact()
 if not G.focC then return end
 local td=TD[LvlTile(G.focC,G.focR)]
 if td.f&TF.DOOR~=0 then
  DoorOpen(G.focC,G.focR)
 elseif td.f&TF.LEVER~=0 then
  PullLever(G.focC,G.focR)
 end
end
function LoadLevel(lvlNo)
 PalSet()
 G=DeepCopy(G_INIT)
 G.lvlNo=lvlNo
 G.lvl=LVL[lvlNo]
 local lvl=G.lvl
 S3Reset()
 S3.FLOOR_CLR,S3.CEIL_CLR=lvl.floorC,lvl.ceilC
 G.ex=nil
 LoadSpawners()
 for r=0,lvl.pgh*17-1 do
  for c=0,lvl.pgw*30-1 do
   local cx,cz=(c+0.5)*TSIZE,(r+0.5)*TSIZE
   local t=LvlTile(c,r)
   local lbl=TileLabel(c,r)
   local td=TD[t]
   if td then AddWalls(c,r,td) end
   if t==S.FLAG then
    assert(lbl)
    if lbl==0 then
     G.ex,G.ez=cx,cz
    end
   end
   if not D_NOENTS and ECFG[t] then 
    EntAdd(t,cx,cz)
   end
  end
 end
 assert(G.ex,"Start pos flag not found.")
 G.weapOver=S3OverAdd({sx=84,sy=94,tid=460,scale=2})
end
function LoadSpawners()
 local cols,rows=LvlSize()
 G.spawners={}
 for r=0,rows-1 do
  for c=0,cols-1 do
   local t=LvlTile(c,r)
   if t==T.SPAWNER then LoadSpawner(c,r) end
  end
 end
end
function LoadSpawner(c0,r0)
 local lbl=TileLabel(c0,r0)
 assert(lbl)
 LvlTile(c0,r0,T.FLOOR) -- remove spawner from map
 if not G.spawners[lbl] then G.spawners[lbl]={} end
 for r=r0-1,r0+1 do
  for c=c0-1,c0+1 do
   local t=LvlTile(c,r)
   if ECFG[t] then
    LvlTile(c,r,T.FLOOR)
    local cx,cz=(c+0.5)*TSIZE,(r+0.5)*TSIZE
    table.insert(G.spawners[lbl],{x=cx,z=cz,eid=t})
   end
  end
 end
end
function CheckTriggers()
 local c,r=floor(G.ex/TSIZE),floor(G.ez/TSIZE)
 if LvlTile(c,r)~=T.TRIGGER then return end
 local lbl=TileLabel(c,r)
 if not lbl or G.trigdone[lbl] then return end
 G.trigdone[lbl]=true
 local spawner=G.spawners[lbl]
 if not spawner then return end
 for i=1,#spawner do
  local s=spawner[i]
  local ent=EntAdd(s.eid,s.x,s.z)
  ent.asleep=false
 end
end
function LvlTile(c,r,newval)
 local cols,rows=LvlSize()
 if c>=cols or r>=rows or c<0 or r<0 then
  return 0
 end
 local val=G.otiles[r*240+c]
 if not val then
  local c0,r0=MapPageStart(G.lvl.pg)
  val=mget(c0+c,r0+r)
 end
 if newval then G.otiles[r*240+c]=newval end
 return val
end
function LvlSize()
 return G.lvl.pgw*30,G.lvl.pgh*17
end
function LvlTileAtXz(x,z)
 local c,r=floor(x/TSIZE),floor(z/TSIZE)
 return LvlTile(c,r)
end
function PullLever(c,r)
 LvlTile(c,r,T.SOLID)
 local w=IwallAt(c,r)
 if w then w.tid=TID.LEVER_P end
 local cols,rows=LvlSize()
 local gatec,gater=nil,nil
 for r=0,rows-1 do
  for c=0,cols-1 do
   local t=LvlTile(c,r)
   if TD[t] and TD[t].f&TF.GATE~=0 then
    gatec,gater=c,r
    break
   end
  end
 end
 assert(gatec)
 local w=IwallAt(gatec,gater)
 assert(w)
 IwallDel(gatec,gater)
 S3WallDel(w)
 LvlTile(gatec,gater,T.FLOOR)
 Say("THE GATE OPENED!")
end
function GetInteractHint()
 local c,r=G.focC,G.focR
 if not c then return end
 local hint=nil
 local td=TD[LvlTile(c,r)]
 if td.f&TF.DOOR~=0 then
  if td.f&TF.LOCKED~=0 then
   if G.hasKey then
    return "Press S to unlock"
   else
    return "You need a key"
   end
  else
   return "Press S to open door"
  end
 elseif td.f&TF.LEVER~=0 then
  return "Press S to activate"
 elseif td.f&TF.GATE~=0 then
  return "Gate opens elsewhere!"
 elseif td.f&TF.PORTAL~=0 then
  return "Step into the portal!"
 end
 return nil
end
function CheckLevelEnd()
 local t=LvlTileAtXz(G.ex,G.ez)
 if TD[t] and TD[t].f&TF.PORTAL then
  SetMode(MODE.EOL)
  Snd(SND.EOL)
  MarkLvlDone(G.lvlNo)
 end
end
function PalSet(tint)
 tint=tint or {r=0,g=0,b=0,a=0}
 for c=0,15 do
  local origR=(ORIG_PAL[c]&0xff0000)>>16
  local origG=(ORIG_PAL[c]&0xff00)>>8
  local origB=(ORIG_PAL[c]&0xff)
  local r=_S3Interp(0,origR,255,tint.r,tint.a)
  local g=_S3Interp(0,origG,255,tint.g,tint.a)
  local b=_S3Interp(0,origB,255,tint.b,tint.a)
  poke(0x3fc0+3*c,clamp(S3Round(r),0,255))
  poke(0x3fc0+3*c+1,clamp(S3Round(g),0,255))
  poke(0x3fc0+3*c+2,clamp(S3Round(b),0,255))
 end
end
function Rend()
 S3SetCam(G.ex,G.ey,G.ez,G.yaw)
 S3Rend()
 RendHud(false)
 RendHint()
 if G.msgCd>0 then
  G.msgCd=G.msgCd-G.dt
  print(G.msg,8,100)
 end
 if DEBUGS then print(DEBUGS,4,12) end
end
function RendHud(full)
 local HUDY=120
 local BOXW,BOXH,BOXCLR=14,8,9
 local HPX,HPY=25,HUDY+6
 local AMMOX,AMMOY=65,HUDY+6
 local GRENX,GRENY=105,HUDY+6
 if full then
  local c0,r0=MapPageStart(63)
  map(c0,r0,30,2,0,HUDY)
  print("Hold S for",22*8,HUDY+4,9)
  print("map/help",22*8,HUDY+10,9)
 else
  rect(HPX,HPY,BOXW,BOXH,BOXCLR)
  rect(AMMOX,AMMOY,BOXW,BOXH,BOXCLR)
  rect(GRENX,GRENY,BOXW,BOXH,BOXCLR)
 end
 if G.hp>20 or Blink(0.3,0.2) then
  print(To2Dig(G.hp),HPX+2,HPY+1,
    G.hp>20 and 15 or 14,true)
 end
 print(To2Dig(G.ammo),AMMOX+2,AMMOY+1,15,true)
 print(To2Dig(G.grens),GRENX+2,GRENY+1,15,true)
 if G.justHurt then
  print("-"..G.justHurt.hp,100,10,15,true,2)
 end
 if G.hasKey and not G.paintedKey then
  spr(S.HUD_KEY,18*8,HUDY+8)
  G.paintedKey=true
 end
 if G.lvlNo==1 and G.clk<5 then
  rect(0,5,200,9,15)
  print("Z = shoot, X = throw flame orb",2,7,0)
 end
end
function RendHint()
 local hint=GetInteractHint()
 if hint then
  local X,Y,W,H=120,5,120,8
  rect(X,Y,W,H,15)
  print(hint,X+2,Y+2,0)
 end
end
function To2Dig(n)
 n=floor(n)
 return n<0 and "00" or
   (n<10 and "0"..n or ((n<100) and n or 99))
end
function IsPosValid(x,z,ent)
 local cs=ent and ent.w*0.4 or PLR_CS
 local solid=IsInSolidTile(x-cs,z-cs) or
   IsInSolidTile(x-cs,z+cs) or
   IsInSolidTile(x+cs,z-cs) or
   IsInSolidTile(x+cs,z+cs)
 if solid then return false end
 local ents=G.ents
 for i=1,#ents do
  local e=ents[i]
  if e~=ent and e.solid then
   local d2=DistSqXZ(e.x,e.z,x,z)
   if d2<0.25*(cs*cs+e.w*e.w) then
    return false
   end
  end
 end
 if ent and DistSqToPlr(x,z)<2500 then
  return false
 end
 return true
end
function IsInSolidTile(x,z)
 local c,r=floor(x/TSIZE),floor(z/TSIZE)
 local t=LvlTile(c,r)
 if t==T.VOID then return true end
 if t==T.FLOOR then return false end
 local td=TD[t]
 if not td then return false end
 return 0==td.f&TF.NSLD
end
function RotPoint(ox,oz,px,pz,alpha)
 local ux,uz=px-ox,pz-oz
 local c,s=cos(alpha),sin(alpha)
 return ox+ux*c-uz*s,oz+uz*c+ux*s
end
function Overlay(a,b)
 local result=DeepCopy(a)
 for k,v in pairs(b) do
  if result[k] and type(result[k])=="table" and
    type(v)=="table" then
   result[k]=Overlay(result[k],v)
  else
   result[k]=DeepCopy(v)
  end
 end
 return result
end
function DistSqXZ(x1,z1,x2,z2)
 return (x1-x2)*(x1-x2)+(z1-z2)*(z1-z2)
end
function DistXZ(x1,z1,x2,z2)
 return sqrt(DistSqXZ(x1,z1,x2,z2))
end
function DistSqToPlr(x,z)
 return DistSqXZ(x,z,G.ex,G.ez)
end
function DistToPlr(x,z)
 return DistXZ(x,z,G.ex,G.ez)
end
function PlrFwdVec(scale)
 scale=scale or 1
 return -sin(G.yaw)*scale,-cos(G.yaw)*scale
end
function V2Mag(x,z)
 return sqrt(x*x+z*z)
end
function V2Normalize(x,z)
 local mag=V2Mag(x,z)
 if mag>0.001 then return x/mag,z/mag
 else return 0,0 end
end
function DeepCopy(t)
 if type(t)~="table" then return t end
 local r={}
 for k,v in pairs(t) do
  if type(v)=="table" then
   r[k]=DeepCopy(v)
  else
   r[k]=v
  end
 end
 return r
end
function MapPageStart(pg)
 return (pg%8)*30,(pg//8)*17
end
function MetaValue(t)
 if t>=S.META_0 and t<=S.META_0+9 then
  return t-S.META_0
 end
end
function TileLabel(tc,tr)
 for c=tc-1,tc+1 do
  for r=tr-1,tr+1 do
   local mv=MetaValue(LvlTile(c,r))
   if mv then return mv end
  end
 end
 return nil
end
function Blink(ondur,offdur,phase)
 ondur=ondur or 0.2
 offdur=offdur or ondur
 phase=phase or 0
 return ondur>math.fmod(A.mclk,(ondur+offdur))
end
function GetDpad()
 local dx=btn(BTN.LEFT) and -1 or
   (btn(BTN.RIGHT) and 1 or 0)
 local dz=btn(BTN.FWD) and 1 or
   (btn(BTN.BACK) and -1 or 0)
 return dx,dz
end
function GetDpadP()
 local dx=btnp(BTN.LEFT) and -1 or
   (btnp(BTN.RIGHT) and 1 or 0)
 local dz=btnp(BTN.FWD) and 1 or
   (btnp(BTN.BACK) and -1 or 0)
 return dx,dz
end
function PrintC(text,cx,cy,color,fixed,scale)
 color=color or 15
 fixed=fixed or false
 scale=scale or 1
 local w,h=print(text,0,-10,color,fixed,scale),6
 print(text,cx-w*0.5,cy-h*0.5,color,fixed,scale)
end
function IsLvlLocked(l)
 local hcl=D_HCL or (pmem(0) or 0)
 return l>hcl+1
end
function MarkLvlDone(l)
 pmem(0,max(pmem(0) or 0,l))
end
function Boot()
 if D_CLEARPMEM then pmem(0,0) end
 S3Init()
 SetMode(MODE.TITLE)
end
function SetMode(m)
 local old=A.mode
 A.mode,A.mclk=m,0
 PalSet()
 local mus=MODEMUS[m] or MUS.KEEP
 if old==MODE.MINIMAP and m==MODE.PLAY then mus=MUS.KEEP end
 if mus~=MUS.KEEP then music(mus) end
end
function TIC()
 local stime=time()
 local dtmillis=A.lftime and (stime-A.lftime) or 16
 A.lftime=stime
 A.dt=dtmillis*.001 -- convert to seconds
 local dt=A.dt
 A.mclk=A.mclk+dt
 local f=TICF[A.mode]
 if f then f() end
 if D_SHOWFPS then
  print(S3Round(1000/(time()-stime)).."fps")
 end
end
function TICTitle()
 local c,r=MapPageStart(62)
 map(c,r,30,17)
 PrintC("3D first-person shooter",
   120,50,2)
 if Blink(0.3,0.2) then
  PrintC("- Press Z to play -",120,80)
 end
 if btnp(BTN.FIRE) then
  SetMode(IsLvlLocked(2) and
    MODE.INSTRUX or MODE.LVLSEL)
 end
end
function TICDead()
 Rend()
 rect(0,50,240,30,0)
 print("You died.",80,60,15,false,2)
 if A.mclk>5 then
  SetMode(MODE.TITLE)
  return
 end
end
function TICWin()
 cls(0)
 PrintC("The end!",120,60)
 PrintC("Thanks for playing!",120,70)
 if A.mclk>2 then SetMode(MODE.TITLE) end
end
function TICPreroll()
 cls(0)
 PrintC("LEVEL "..G.lvlNo,120,60,11)
 PrintC(G.lvl.name,120,70)
 if A.mclk>2 then EndPreroll() end
end
function EndPreroll()
 cls(0)
 SetMode(MODE.PLAY)
 RendHud(true)
end
function TICInstrux()
 local c,r=MapPageStart(61)
 cls(0)
 map(c,r,30,17)
 print("CONTROLS",100,10,8)
 local X=88
 local Y=32
 print("Strafe",X,Y,3)
 print("Open/Use",X,Y+16,3)
 print("Flame orb",X,Y+48,14)
 print("FIRE",X,Y+64,4)
 print("Move",168,96,15)
 if Blink(0.5) then
  print("- Press FIRE to continue -",50,124,4)
 end
 if btnp(BTN.FIRE) then StartLevel(1) end
end
function TICLvlSel()
 local mx,my=GetDpadP()
 A.sel=S3Clamp(A.sel-my,1,#LVL)
 local c,r=MapPageStart(62)
 cls(0)
 map(c,r+10,30,17,0,80)
 PrintC("Select level",120,10,15)
 local X,Y=40,20
 local RH=10
 for i=1,#LVL do
  local y=Y+RH*i
  local locked=IsLvlLocked(i)
  if locked then
   spr(S.LOCK,X+10,y-2)
  end
  print(i..": "..LVL[i].name,X+20,y,
   locked and 2 or (i==A.sel and 14 or 15))
 end
 spr(S.ARROW,X,A.sel*RH+Y)
 if btnp(BTN.FIRE) and not IsLvlLocked(A.sel) then
  StartLevel(A.sel)
 end
 if IsLvlLocked(A.sel) then
  PrintC("This level is locked",120,80,2)
 else
  if Blink(0.3,0.2) then
   PrintC("Press Z to select",120,80,4)
  end
 end
end
function StartLevel(lvlNo)
 LoadLevel(lvlNo) 
 SetMode(MODE.PREROLL)
end
function TICEol()
 cls(0)
 PrintC("Level clear!",120,60)
 if A.mclk>3 then
  if G.lvlNo<#LVL then
   StartLevel(G.lvlNo+1)
  else
   SetMode(MODE.WIN)
  end
 end
end
function TICPlay()
 G.dt=A.dt
 G.clk=G.clk+A.dt
 local PSPD=G.PSPD
 local dt=G.dt
 local mx,mz=GetDpad()
 local vx,vz=PlrFwdVec(mz)
 MovePlr(PSPD*dt,vx,vz)
 if btn(BTN.STRAFE) then
  vx=-math.sin(G.yaw-1.5708)*mx
  vz=-math.cos(G.yaw-1.5708)*mx
  MovePlr(PSPD*dt,vx,vz)
 else
  G.yaw=G.yaw-mx*G.PASPD*dt
 end
 if btnp(BTN.OPEN) then Interact() end
 G.minimapC=btn(BTN.OPEN) and G.minimapC+dt or 0
 if G.minimapC>0.5 then
  G.minimapC=0
  MinimapStart()
  return
 end
 DoorAnimUpdate(dt)
 CheckTriggers()
 UpdateFocusTile()
 UpdateJustHurt()
 UpdatePlrAtk()
 CheckEntHits()
 UpdateEnts()
 MinimapUpdateOff()
 CheckLevelEnd()
 Rend()
end
function TICMinimap() MinimapTick() end
function UpdateJustHurt()
 if not G.justHurt then return end
 G.justHurt.cd=G.justHurt.cd-G.dt
 if G.justHurt.cd<0 then
  PalSet()
  G.justHurt=nil
  return
 end
end
function UpdatePlrAtk()
 if G.atk==0 then
  if btnp(BTN.FIRE) then
   if G.ammo>0 then
    G.ammo=G.ammo-1
    G.atk=1
    G.atke=0
   else
    Say("No arrows left!")
    Snd(SND.FAIL)
   end
  end
 else
  G.atke=G.atke+G.dt
  if G.atke>PLR_ATK[G.atk].t then
   G.atk=(G.atk+1)%(#PLR_ATK+1)
   G.atke=0
   if G.atk>0 and PLR_ATK[G.atk].fire then
    local dx,dz=PlrFwdVec(4)
    local arrow=EntAdd(E.ARROW,G.ex+dx,G.ez+dz)
    arrow.y=G.ey-2
    arrow.vx,arrow.vz=dx*200,dz*200
    Snd(SND.ARROW)
   end
  end
 end
 if btnp(BTN.LOB) then
  if G.grens>0 and G.clk-G.lastGrenT>1 then
   G.lastGrenT=G.clk
   local dx,dz=PlrFwdVec(4)
   local gren=EntAdd(E.GREN,G.ex+dx,G.ez+dz)
   gren.y=G.ey-2
   gren.vx,gren.vz=dx*50,dz*50
   G.grens=G.grens-1
  elseif G.grens==0 then
   Say("No flame orbs left!")
   Snd(SND.FAIL)
  end
 end
 G.weapOver.tid=G.atk==0 and
   (G.ammo>0 and TID.CBOW_N or TID.CBOW_E) or
   PLR_ATK[G.atk].tid
end
function HurtPlr(hp)
 if D_INVULN then return end
 G.hp=max(G.hp-hp,0)
 if G.hp==0 then
  SetMode(MODE.DEAD)
  Snd(SND.DIE)
  PalSet({r=0,g=0,b=0,a=80})
  return
 end
 G.justHurt={hp=hp,cd=0.7}
 PalSet({r=255,g=0,b=0,a=40})
 Snd(SND.HURT)
end
function MovePlr(d,vx,vz)
 local STEP=1
 local ex,ez=G.ex,G.ez
 while d>0 do
  local l=min(d,STEP)  -- how much to move this step
  d=d-STEP
  local ax,az=ex+l*vx,ez+l*vz -- full motion
  local bx,bz=ex,ez+l*vz  -- move only in Z direction
  local cx,cz=ex+l*vx,ez  -- move only in X direction
  if IsPosValid(ax,az) then ex,ez=ax,az
  elseif IsPosValid(bx,bz) then ex,ez=bx,bz
  elseif IsPosValid(cx,cz) then ex,ez=cx,cz
  else break end  -- motion completely blocked
 end
 G.ex,G.ez=ex,ez
end
function Say(msg)
 G.msg=msg
 G.msgCd=1
end
function Snd(snd)
 assert(snd.sfx)
 sfx(snd.sfx,snd.note,snd.dur,0,snd.vol,snd.spd)
end
TICF={
 [MODE.TITLE]=TICTitle,
 [MODE.LVLSEL]=TICLvlSel,
 [MODE.PLAY]=TICPlay,
 [MODE.DEAD]=TICDead,
 [MODE.INSTRUX]=TICInstrux,
 [MODE.MINIMAP]=TICMinimap,
 [MODE.PREROLL]=TICPreroll,
 [MODE.WIN]=TICWin,
 [MODE.EOL]=TICEol,
}
Boot()
function MinimapStart()
 SetMode(MODE.MINIMAP)
 G.mmox,G.mmoy=90-8*G.ex/TSIZE,68-8*G.ez/TSIZE
end
function MinimapFromWorld(x,z)
 return G.mmox+8*x/TSIZE,G.mmoy+8*z/TSIZE
end
function MinimapUpdateOff()
 local seen=G.mmseen
 local c0,r0=floor(G.ex/TSIZE),floor(G.ez/TSIZE)
 for r=r0-3,r0+3 do
  for c=c0-3,c0+3 do
   seen[r*240+c]=true
  end
 end
end
function MinimapTick()
 local mx,my=GetDpad()
 G.mmox=G.mmox-mx
 G.mmoy=G.mmoy+my
 local c0,r0=MapPageStart(G.lvl.pg)
 local cols,rows=LvlSize()
 clip(S3.VP_L,S3.VP_T,S3.VP_R-S3.VP_L+1,
   S3.VP_B-S3.VP_T+1)
 cls(0)
 local startx,starty=MinimapFromWorld(0,0)
 map(c0,r0,cols,rows,S3Round(startx),
   S3Round(starty),0,1,MinimapRemap)
 if Blink(0.2,0.1) then
  local px,py=MinimapFromWorld(G.ex,G.ez)
  rect(px-1,py-1,3,3,4)
  local fx,fy=PlrFwdVec(8)
  line(px,py,px+fx,py+fy,6)
 end
 if btnp(BTN.OPEN) then
  SetMode(MODE.PLAY)
 end
 local IX,IY=170,0
 local IW,IH=240-IX,110
 local X0,Y0=IX+2,IY+2
 local R=7  -- row height
 rect(IX,IY,IW,IH,1)
 rectb(IX,IY,IW,IH,15)
 local y=Y0
 print("Buttons",X0,y,3)
 y=y+R
 print("Z",X0,y,4)
 print("fire",X0+10,y,6)
 y=y+R
 print("X",X0,y,14)
 print("throw orb",X0+10,y,11)
 y=y+R
 print("A",X0,y,3)
 print("strafe",X0+10,y,2)
 y=y+R
 print("S",X0,y,3)
 print("open",X0+10,y,2)
 y=y+2*R
 print("Flame orbs",X0,y,2)
 y=y+R
 print("are rare,",X0,y,2)
 y=y+R
 print("don't waste",X0,y,2)
 y=y+R
 print("them!",X0,y,2)
 y=y+2*R
 if G.hasKey then
  print("Use the key",X0,y,2)
  y=y+R
  print("to open the",X0,y,2)
  y=y+R
  print("locked door.",X0,y,2)
 else
  print("Find key to",X0,y,2)
  y=y+R
  print("open locked",X0,y,2)
  y=y+R
  print("door.",X0,y,2)
 end
 print("Press S to close map",2,110,2)
 print("Level "..G.lvlNo..": "..G.lvl.name,2,2,15)
 clip()
end
function MinimapRemap(t,c,r)
 local c0,r0=MapPageStart(G.lvl.pg)
 c,r=c-c0,r-r0
 if not G.mmseen[r*240+c] then return T.VOID end
 if TD[t] then return t end
 if MMTILES[t] then return t end
 return t==T.VOID and T.VOID or T.FLOOR
end
