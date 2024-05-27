local mod = mod_loader.mods[modApi.currentMod]
local scriptPath = mod.scriptPath
local taunt = require(scriptPath .. "/taunt/taunt")

Taunt_Torrent = Skill:new{
	Name = "Taunt Torent",
	Description = "Taunts all units in a single direction.",
	Class = "",
	PowerCost = 0,
	Icon = "weapons/support_wind.png",
	Rarity = 3,
	--LaunchSound = "/weapons/titan_fist",
	LaunchSound = "",
	Range = 1,
	Damage = 1,
	Taunt = true,

	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(3,2),
		Enemy3 = Point(0,2),
		Mountain = Point(3,1),
		Friendly = Point(1,2),
		Target = Point(3,2),
	}
}

function Taunt_Torrent:GetTargetZone(piOrigin, p)
	local targets = self:GetTargetArea()
	local ret = PointList()
	for i = 1, targets:size() do
		if p == targets:index(i) then
			local start_index = math.floor((i-1) / 4)*4 + 1
			--LOG("Found target. Index = "..i.." Group index starts at "..start_index.."\n")
			for j = start_index, start_index + 3 do
				ret:push_back(targets:index(j))
			end
			return ret
		end
	end
	return ret
end

function Taunt_Torrent:GetTargetArea(point)

	local ret = PointList()
	
	ret:push_back(Point(1,3))
	ret:push_back(Point(1,4))
	ret:push_back(Point(2,3))
	ret:push_back(Point(2,4))
	
	ret:push_back(Point(5,3))
	ret:push_back(Point(5,4))
	ret:push_back(Point(6,3))
	ret:push_back(Point(6,4))
	
	ret:push_back(Point(3,1))
	ret:push_back(Point(3,2))
	ret:push_back(Point(4,1))
	ret:push_back(Point(4,2))
	
	ret:push_back(Point(3,5))
	ret:push_back(Point(3,6))
	ret:push_back(Point(4,5))
	ret:push_back(Point(4,6))
	
	return ret
end
	
function Taunt_Torrent:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = DIR_NONE
	
	if p2.x == 1 or p2.x == 2 then dir = DIR_LEFT
	elseif p2.x == 5 or p2.x == 6 then dir = DIR_RIGHT
	elseif p2.y == 1 or p2.y == 2 then dir = DIR_UP
	elseif p2.y == 5 or p2.y == 6 then dir = DIR_DOWN end
	
	
	--ret:AddEmitter(Point(3,3),"Emitter_Wind_"..dir)
	--ret:AddEmitter(Point(4,4),"Emitter_Wind_"..dir)
	local board_size = Board:GetSize()
	for i = 0, 7 do
		for j = 0, 7  do
			local point = Point(i,j) -- DIR_LEFT
			--[[
			if dir == DIR_RIGHT then
				point = Point(7 - i, j)
			elseif dir == DIR_UP then
				point = Point(j,i)
			elseif dir == DIR_DOWN then
				point = Point(j,7-i)
			end
			]]--
			
			if Board:IsPawnSpace(point) then
				local pawn = Board:GetPawn(point)
				local id = pawn:GetId()
				taunt.addTauntEffectEnemy(ret, id, point+DIR_VECTORS[dir])
				-- ret:AddDamage(SpaceDamage(point, 0, dir))
				--ret:AddDelay(0.2)
			end
		end
	end
	
	return ret
	
end