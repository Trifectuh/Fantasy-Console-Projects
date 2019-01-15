-- title:  Raycast Lua
-- author: jwash
-- desc:   a raycast engine in lua
-- script: lua

screen = {
	width = 240,
	height = 136
}

worldMap = {
	{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 3, 0, 3, 0, 3, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 2, 2, 0, 2, 2, 0, 0, 0, 0, 3, 0, 3, 0, 3, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 0, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 0, 0, 0, 0, 5, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 0, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 0, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
}

p1 = {
	pos = {
		x = 22,
		y = 11
	},
	dir = {
		x = -1,
		y = 0
	},
	cam = {
		x = 0,
		y = 0.66
	},
	mapPos = {
		x = 22,
		y = 11
	},
	screen = {
		xStart = 0,
		xEnd = 119
	},
	moveSpeed = 5,
	rotationSpeed = 3, 
	zBuffer = {},
	spriteOffset = 0,
	getCameraX = 
		function (x)
			return (2 * x) / 120 - 1
		end,
}

p2 = {
	pos = {
		x = 15,
		y = 11
	},
	dir = {
		x = -1,
		y = 0
	},
	cam = {
		x = 0,
		y = 0.66
	},
	mapPos = {
		x = 22,
		y = 11
	},
	screen = {
		xStart = 121,
		xEnd = 240
	},
	moveSpeed = 5,
	rotationSpeed = 3,
	zBuffer = {},
	spriteOffset = 32,
	getCameraX = 
		function (x)
			return (2 * x - 120) / 120 - 2
		end,
}

timer = {
	current = 0,
	old = 0,
	lastFrame = 0
}

ray = {
	dir = {
		x = 0,
		y = 0
	},
	dist = {
		x = 0,
		y = 0,
		dx = 0,
		dy = 0,
		perp = 0
	},
	step = {
		x = 1,
		y = 1
	},
	mapPos = {
		x = 22,
		y = 11
	},
	wall = {
		hit = false,
		side = 1
	}
}

column = {
	top = 0,
	height = 0,
	bottom = 0,
	color = 0
}

function TIC()
	cls()
	drawBackground()

	drawWorld(p1)
	drawOpponent(p1, p2)

	drawWorld(p2)
	drawOpponent(p2, p1)

	updateFpsCounter()
	movePlayer(p1)
end

function drawBackground()
	rect(0, 0, 240, 68, 13)
	rect(0, 69, 240, 136, 12)
	line(120, 0, 120, 136, 0)
end

function drawWorld(player)
	for x = player.screen.xStart, player.screen.xEnd, 1 do
		createRay(x, player)

		setPlayerMapPosition(player)
		setRayMapPosition(player)
		calculateRayDistance()
		calculateRayStepSize(player)

		ray.wall.hit = false
		while (ray.wall.hit == false) do
			findWall()
		end

		calculateWallDistance(player)
		updateZBuffer(player, x)
		calculateColumnHeight()
		drawColumn(x)
	end
end

function drawOpponent(player, opponent)
	local spriteX = opponent.pos.x - player.pos.x
	local spriteY = opponent.pos.y - player.pos.y

	local invDet = 1 / (player.cam.x * player.dir.y - player.dir.x * player.cam.y)

	local transformX = 2 * (invDet * (player.dir.y * spriteX - player.dir.x * spriteY))
	local transformY = invDet * (-player.cam.y * spriteX + player.cam.x * spriteY)

	local spriteScreenX = math.floor((120 / 2) * (1 + transformX / transformY))

	local spriteHeight = math.abs(math.floor(136 / transformY) * 0.75)
	local drawStartY = -spriteHeight / 2 + 136 / 2 + spriteHeight / 4
	local yOffset = 0

	if (drawStartY < 0) then
		yOffset = math.abs(drawStartY)
		drawStartY = 0
	end

	local drawEndY = spriteHeight / 2 + 136 / 2 + spriteHeight / 4
	if (drawEndY >= 136) then drawEndY = 136 end

	local spriteWidth = math.abs(math.floor(136 / transformY) * 0.75)
	local drawStartX = math.floor(0.5 * (-spriteWidth + spriteScreenX)) + 30
	local xOffset = 0

	if (drawStartX < player.screen.xStart) then
		xOffset = math.abs(drawStartX)
		drawStartX = player.screen.xStart
	end

	local drawEndX = math.floor(0.5 * (spriteWidth + spriteScreenX)) + 30
	if (drawEndX >= player.screen.xEnd) then drawEndX = player.screen.xEnd end

	for stripe = drawStartX, drawEndX-1, 1 do
		local texX = math.floor((32 * (stripe - drawStartX + xOffset)) / spriteWidth) + opponent.spriteOffset
		if (transformY > player.screen.xStart and stripe >= player.screen.xStart and stripe <= player.screen.xEnd and transformY < player.zBuffer[stripe]) then
			for y = drawStartY, drawEndY-1, 1 do
				local texY = math.floor((32 * (y - drawStartY + yOffset)) / spriteHeight);
				local color = sget(texX, texY);
				if (color ~= 15) then pix(stripe, y, color); end
			end
		end
	end
end

function sget(x,y)
	local addr=0x4000+(x//8+y//8*16)*32 -- get sprite address
	return peek4(addr*2+x%8+y%8*8) -- get sprite pixel
end

function createRay(x, player)
	local cameraX = player.getCameraX(x)
	ray.dir.x = player.dir.x + player.cam.x * cameraX
	ray.dir.y = player.dir.y + player.cam.y * cameraX
end

function setPlayerMapPosition(player)
	player.mapPos.x = math.floor(player.pos.x)
	player.mapPos.y = math.floor(player.pos.y)
end

function setRayMapPosition(player)
	ray.mapPos.x = math.floor(player.pos.x)
	ray.mapPos.y = math.floor(player.pos.y)
end

function calculateRayDistance()
	ray.dist.dx = math.abs(1 / ray.dir.x)
	ray.dist.dy = math.abs(1 / ray.dir.y)
end

function calculateRayStepSize(player)
	if (ray.dir.x < 0) then
		ray.step.x = -1
		ray.dist.x = (player.pos.x - player.mapPos.x) * ray.dist.dx
	else
		ray.step.x = 1
		ray.dist.x = (player.mapPos.x + 1.0 - player.pos.x) * ray.dist.dx
	end
	if (ray.dir.y < 0) then
		ray.step.y = -1
		ray.dist.y = (player.pos.y - player.mapPos.y) * ray.dist.dy
	else
		ray.step.y = 1
		ray.dist.y = (player.mapPos.y + 1.0 - player.pos.y) * ray.dist.dy
	end
end

function findWall()
	if (ray.dist.x < ray.dist.y) then
		ray.dist.x = ray.dist.x + ray.dist.dx
		ray.mapPos.x = ray.mapPos.x + ray.step.x
		ray.wall.side = 0
	else
		ray.dist.y = ray.dist.y + ray.dist.dy
		ray.mapPos.y = ray.mapPos.y + ray.step.y
		ray.wall.side = 1
	end

	if (worldMap[ray.mapPos.x][ray.mapPos.y] > 0) then
		ray.wall.hit = true
		return
	end
end

function calculateWallDistance(player)
	if (ray.wall.side == 0) then
		ray.dist.perp = (ray.mapPos.x - player.pos.x + (1 - ray.step.x) / 2) / ray.dir.x
	else
		ray.dist.perp = (ray.mapPos.y - player.pos.y + (1 - ray.step.y) / 2) / ray.dir.y
	end
end

function updateZBuffer(player, x)
	player.zBuffer[x] = ray.dist.perp
end

function calculateColumnHeight()
	column.height = screen.height / ray.dist.perp

	column.top = -column.height / 2 + screen.height / 2
	if (column.top < 0) then
		column.top = 0
	end

	column.bottom = column.height / 2 + screen.height / 2
	if (column.bottom >= screen.height) then
		column.bottom = screen.height - 1
	end
end

function drawColumn(x)
	column.color = worldMap[ray.mapPos.x][ray.mapPos.y]

	if (ray.wall.side == 1) then
		column.color = column.color + 5
	end

	line(x, column.top, x, column.bottom, column.color)
end

function updateFpsCounter()
	timer.old = timer.current
	timer.current = time()
	timer.lastFrame = (timer.current - timer.old) / 1000.0
	print(math.floor(1.0 / timer.lastFrame))
end

function movePlayer(player)
	local moveSpeedDelta = timer.lastFrame * player.moveSpeed
	local rotationSpeedDelta = timer.lastFrame * player.rotationSpeed

	if (btn(0)) then
		if (worldMap[math.floor(player.pos.x + player.dir.x * moveSpeedDelta)][math.floor(player.pos.y)] == 0) then
			player.pos.x = player.pos.x + (player.dir.x * moveSpeedDelta)
		end
		if (worldMap[math.floor(player.pos.x)][math.floor(player.pos.y + player.dir.y * moveSpeedDelta)] == 0) then
			player.pos.y = player.pos.y + (player.dir.y * moveSpeedDelta)
		end
	end

	if (btn(1)) then
		if (worldMap[math.floor(player.pos.x - player.dir.x * moveSpeedDelta)][math.floor(player.pos.y)] == 0) then
			player.pos.x = player.pos.x - (player.dir.x * moveSpeedDelta)
		end
		if (worldMap[math.floor(player.pos.x)][math.floor(player.pos.y - player.dir.y * moveSpeedDelta)] == 0) then
			player.pos.y = player.pos.y - (player.dir.y * moveSpeedDelta)
		end
	end

	if (btn(2)) then
		local oldDirX = player.dir.x
		player.dir.x = player.dir.x * math.cos(rotationSpeedDelta) - player.dir.y * math.sin(rotationSpeedDelta)
		player.dir.y = oldDirX * math.sin(rotationSpeedDelta) + player.dir.y * math.cos(rotationSpeedDelta)

		local oldPlaneX = player.cam.x
		player.cam.x = player.cam.x * math.cos(rotationSpeedDelta) - player.cam.y * math.sin(rotationSpeedDelta)
		player.cam.y = oldPlaneX * math.sin(rotationSpeedDelta) + player.cam.y * math.cos(rotationSpeedDelta)
	end

	if (btn(3)) then
		local oldDirX = player.dir.x
		player.dir.x = player.dir.x * math.cos(-rotationSpeedDelta) - player.dir.y * math.sin(-rotationSpeedDelta)
		player.dir.y = oldDirX * math.sin(-rotationSpeedDelta) + player.dir.y * math.cos(-rotationSpeedDelta)

		local oldPlaneX = player.cam.x
		player.cam.x = player.cam.x * math.cos(-rotationSpeedDelta) - player.cam.y * math.sin(-rotationSpeedDelta)
		player.cam.y = oldPlaneX * math.sin(-rotationSpeedDelta) + player.cam.y * math.cos(-rotationSpeedDelta)
	end
end

-- <TILES>
-- 000:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 001:fffff228ffff2222ffff277affff2777ffff2222ffff2222fffff212fff22112
-- 002:888fffff2288ffffaaa8ffffaaa8ffff2888ffff2222ffff288fffff288888ff
-- 003:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 004:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 005:fffff66cffff6666ffff677affff6777ffff6666ffff6666fffff616fff66116
-- 006:cccfffff66ccffffaaacffffaaacffff6cccffff6666ffff6ccfffff6cccccff
-- 007:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 016:fffffffffffffffffffffffffffffffffffffff2fffffff2fffffff2fffffff2
-- 017:ff222222f22222222222222222228222222882222288222222282222767a2222
-- 018:2822288f22222288222222282221222822212222222212222222812222228122
-- 019:ffffffffffffffffffffffff8fffffff8fffffff8fffffff8fffffff8fffffff
-- 020:fffffffffffffffffffffffffffffffffffffff6fffffff6fffffff6fffffff6
-- 021:ff666666f6666666666666666666c666666cc66666cc6666666c66667b7a6666
-- 022:6c666ccf666666cc6666666c6661666c66616666666616666666c1666666c166
-- 023:ffffffffffffffffffffffffcfffffffcfffffffcfffffffcfffffffcfffffff
-- 032:fffffff3fffffff3ffffffffffffffffffffffffffffffffffffffffffffffff
-- 033:7767a33637003a363000072233003322f3333222fff22221fff22221fff22221
-- 034:6777a1226777a1182222811822228813222228332222283f2222283f222228ff
-- 035:ffffffffffffffff7fffffff7fffffff7fffffffffffffffffffffffffffffff
-- 036:fffffff3fffffff3ffffffffffffffffffffffffffffffffffffffffffffffff
-- 037:77b7a33237003a323000076633003366f3333666fff66661fff66661fff66661
-- 038:2777a1662777a11c6666c11c6666cc1366666c3366666c3f66666c3f66666cff
-- 039:ffffffffffffffff7fffffff7fffffff7fffffffffffffffffffffffffffffff
-- 048:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 049:fff22211ffff2211ffff2211fffff221fffff221fffff731ffff7731ffff7331
-- 050:222228ff122288ff12228fff12228fff22228fff17aaffff77aaafff7333afff
-- 051:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 052:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 053:fff66611ffff6611ffff6611fffff661fffff661fffff731ffff7731ffff7331
-- 054:66666cff1666ccff1666cfff1666cfff6666cfff17aaffff77aaafff7333afff
-- 055:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- </TILES>

-- <SPRITES>
-- 000:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 001:fffff228ffff2222ffff277affff2777ffff2222ffff2222fffff212fff22112
-- 002:888fffff2288ffffaaa8ffffaaa8ffff2888ffff2222ffff288fffff288888ff
-- 003:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 004:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 005:fffff66cffff6666ffff677affff6777ffff6666ffff6666fffff616fff66116
-- 006:cccfffff66ccffffaaacffffaaacffff6cccffff6666ffff6ccfffff6cccccff
-- 007:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 016:fffffffffffffffffffffffffffffffffffffff2fffffff2fffffff2fffffff2
-- 017:ff222222f22222222222222222228222222882222288222222282222767a2222
-- 018:2822288f22222288222222282221222822212222222212222222812222228122
-- 019:ffffffffffffffffffffffff8fffffff8fffffff8fffffff8fffffff8fffffff
-- 020:fffffffffffffffffffffffffffffffffffffff6fffffff6fffffff6fffffff6
-- 021:ff666666f6666666666666666666c666666cc66666cc6666666c66667b7a6666
-- 022:6c666ccf666666cc6666666c6661666c66616666666616666666c1666666c166
-- 023:ffffffffffffffffffffffffcfffffffcfffffffcfffffffcfffffffcfffffff
-- 032:fffffff3fffffff3ffffffffffffffffffffffffffffffffffffffffffffffff
-- 033:7767a33637003a363000072233003322f3333222fff22221fff22221fff22221
-- 034:6777a1226777a1182222811822228813222228332222283f2222283f222228ff
-- 035:ffffffffffffffff7fffffff7fffffff7fffffffffffffffffffffffffffffff
-- 036:fffffff3fffffff3ffffffffffffffffffffffffffffffffffffffffffffffff
-- 037:77b7a33237003a323000076633003366f3333666fff66661fff66661fff66661
-- 038:2777a1662777a11c6666c11c6666cc1366666c3366666c3f66666c3f66666cff
-- 039:ffffffffffffffff7fffffff7fffffff7fffffffffffffffffffffffffffffff
-- 048:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 049:fff22211ffff2211ffff2211fffff221fffff221fffff731ffff7731ffff7331
-- 050:222228ff122288ff12228fff12228fff22228fff17aaffff77aaafff7333afff
-- 051:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 052:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 053:fff66611ffff6611ffff6611fffff661fffff661fffff731ffff7731ffff7331
-- 054:66666cff1666ccff1666cfff1666cfff6666cfff17aaffff77aaafff7333afff
-- 055:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- </SPRITES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa99a1c2e6343434deeed6
-- </PALETTE>
