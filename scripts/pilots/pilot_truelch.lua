--[[
TODO:
- FarLine trapped buildings are a bit too high
- truelch_RSTMode:

- Fix the bugs below:

BUGS:
- in test mode (but maybe also in regular mission), teleporting (detritus and candy) will cause this error:
.../mods/ItB-Pilot-Potluck-main-git/scripts/fmw/api.lua:171: attempt to index field '?' (a nil value)

- local EVENT_pawnKilled = function(mission, pawn)
I've fixed the issue, but it causes new issues:
[2025-12-31 09:52:42] [...LoaderExtensions/mods/modApiExt/scripts/internal.lua:43]: In mod id 'modApiExt',  A 'skillStartHooks' callback has failed:
./mods/ItB-WotP/scripts/globalAchievements.lua:371: attempt to index local 'pawn' (a nil value)
[2025-12-31 09:52:45] [./scripts/mod_loader/bootstrap/event.lua:243]: An event callback failed: ...sx_mods/mods/squads/mods/Labyrinth/scripts/pawns.lua:48: attempt to index local 'pawn' (a nil value)
- Subscribed at: 
    stack traceback:
        ./scripts/mod_loader/bootstrap/event.lua:126: in function 'subscribe'
        ...sx_mods/mods/squads/mods/Labyrinth/scripts/pawns.lua:53: in main chunk
        [C]: in function 'require'
        ...osx_mods/mods/squads/mods/Labyrinth/scripts/init.lua:80: in function 'init'
        ./scripts/mod_loader/mod_loader.lua:464: in function <./scripts/mod_loader/mod_loader.lua:462>
        [C]: in function 'xpcall'
        ./scripts/mod_loader/mod_loader.lua:461: in function 'initMod'
        ./scripts/mod_loader/mod_loader.lua:157: in function 'init'
        ./scripts/mod_loader/mod_loader.lua:781: in main chunk
        [C]: in function 'require'
        ./scripts/mod_loader/__scripts.lua:42: in main chunk
        [C]: in function 'require'
        scripts/modloader.lua:1: in main chunk
- Dispatched at: 
    stack traceback:
        ./scripts/mod_loader/bootstrap/event.lua:233: in function 'dispatch'
        ...oaderExtensions/mods/modApiExt/scripts/modApiExt.lua:143: in function 'hook'
        ...LoaderExtensions/mods/modApiExt/scripts/internal.lua:36: in function <...LoaderExtensions/mods/modApiExt/scripts/internal.lua:36>
        [C]: in function 'xpcall'
        ...LoaderExtensions/mods/modApiExt/scripts/internal.lua:34: in function 'fireSkillStartHooks'
        [string "line"]:1: in main chunk

MAYBE IN THE FUTURE:
- implement FMW's custom function I made in Hell Breachers (to hide unused modes)
- truelch_PinnacleMode:
	- special mine that freeze enemies but give a shield to friendlies?
- truelch_DetritusMode:
	- OR new logic: deploy conveyor belt?!

NOTE:
- You CAN have animated image mark! Example: crack is animated

- Nautilus:
[2025-12-27 23:34:50] [...LoaderExtensions/mods/modApiExt/scripts/internal.lua:43]: In mod id 'modApiExt',  A 'tileHighlightedHooks' callback has failed:
./mods/Nautilus/scripts/missions/incinerator.lua:149: attempt to index field 'Nautilus_Incinerator' (a nil value)

ISLAND NAMES:
Archive:    archive
R.S.T.:     rst
Pinnacle:   pinnacle
Detritus:   detritus

Meridia:    Meridia
Nautilus:   Nautilus_island_id
Candy:      tatu_Candy_Island

Farline:    FarLine
Watchtower: Watchtower
Vertex:     Vertex


EXAMPLE:
GAME.Potluck_Truelch_Memories["archive"] returns the stacks of Archive island.


CREDITS:
- The War Rig (art and pawn's stats and weapon's effects) were done by tosx
- The Rainbow effect (and Candy related stuff) were done by Tatu
- The Mine Layer weapon icon comes from Generic (that he himself took from Lemonymous' mine layer)

- Modded islands: Meridia (Lemonymous), Nautilus (a common effort of multiple modders), Candy (Tatu) and Far Line, Watchtower and Vertex (tosx).
]]

local this = {}

local mod = mod_loader.mods[modApi.currentMod]

local scriptPath = mod.scriptPath
local resourcePath = mod.resourcePath

local fmw = mod.libs.fmw

local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
local repairApi = mod.libs.repairApi

local personalities = require(resourcePath.."scripts/libs/personality")
local dialog = require(resourcePath.."scripts/pilots/dialog_truelch")

local pilot = {
	Id = "Pilot_Truelch",					-- id must be unique. Used to link to art assets.
	Personality = "truelch_personality",	-- must match the id for a personality you have added to the game.
	Name = "Truelch",
	Rarity = 1,
	Voice = "/voice/ralph",					-- audio. look in pilots.lua for more alternatives.
	Skill = "truelch_ability",				-- pilot's ability - Must add a tooltip for new skills.
}

local function isGame()
	return true
		and Game ~= nil
		and GAME ~= nil
end

local function isMission()
    local mission = GetCurrentMission()

    return true
        and isGame()
        and mission ~= nil
        and mission ~= Mission_Test
end

--unnecessary?
--also, is mission (in the hook params) the same as GetCurrentMission()?
local function missionData()
	local mission = GetCurrentMission()
	return mission
end

--Not local so that it can be used in AddScript (I hope that's what I needed to work...)
--[[local]] function getTrappedBuilding(health)

	local islandName = "final"

	--LOG("[TRUELCH] getTrappedBuilding -> Game:GetCorp().name: "..Game:GetCorp().name)

	if Game:GetCorp().name ~= "" then
		local islandIndex = easyEdit:getCurrentIslandSlot()
		islandName = easyEdit.world[islandIndex]["island"]
	end

	--[[
	if islandName == nil or islandName == "" then
		islandName = "final"
	end
	]]

	local name = islandName.."_trapped_"..tostring(health)

	return name
end

--[[
Helper function to see if the board currently has this pilots ability
--]]
local function BoardHasAbility()
	for id = 0, 2 do --doesn't work with my Hell Breachers passive. I should remove that passive anyway...
		if Board:GetPawn(id):IsAbility(pilot.Skill) then
			return true
		end
	end
end

function this:GetPilot()
	return pilot
end

---- IMAGES
--Can I move the stuff below inside init without breaking everything?
modApi:appendAsset("img/modes/icon_repair_mode.png",     mod.resourcePath.."img/modes/icon_repair_mode.png")

modApi:appendAsset("img/modes/icon_archive_mode.png",    mod.resourcePath.."img/modes/icon_archive_mode.png")
modApi:appendAsset("img/modes/icon_rst_mode.png",        mod.resourcePath.."img/modes/icon_rst_mode.png")
modApi:appendAsset("img/modes/icon_pinnacle_mode.png",   mod.resourcePath.."img/modes/icon_pinnacle_mode.png")
modApi:appendAsset("img/modes/icon_detritus_mode.png",   mod.resourcePath.."img/modes/icon_detritus_mode.png")

modApi:appendAsset("img/modes/icon_meridia_mode.png",    mod.resourcePath.."img/modes/icon_meridia_mode.png")
modApi:appendAsset("img/modes/icon_nautilus_mode.png",   mod.resourcePath.."img/modes/icon_nautilus_mode.png")
modApi:appendAsset("img/modes/icon_candy_mode.png",      mod.resourcePath.."img/modes/icon_candy_mode.png")

modApi:appendAsset("img/modes/icon_farline_mode.png",    mod.resourcePath.."img/modes/icon_farline_mode.png")
modApi:appendAsset("img/modes/icon_watchtower_mode.png", mod.resourcePath.."img/modes/icon_watchtower_mode.png")
modApi:appendAsset("img/modes/icon_vertex_mode.png",     mod.resourcePath.."img/modes/icon_vertex_mode.png")


---- PAWNS
--Final trapped buildings (almost forgot about it)
final_trapped_1 = Trapped_Building:new{
	Image = "final_trapped_1", --tmp
	SkillList = {"final_trapped_1_Explode"},
	Health = 1, --for single building tiles?
}
final_trapped_1_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "final_trapped_1"
	}
}

final_trapped_2 = Trapped_Building:new{
	Image = "final_trapped_2", --tmp
	SkillList = {"final_trapped_2_Explode"},
}
final_trapped_2_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "final_trapped_2"
	}
}


--Archive trapped buildings
archive_trapped_1 = Trapped_Building:new{
	Image = "archive_trapped_1", --test --archive_trapped_1 --naut_trapped_bldg
	SkillList = {"archive_trapped_1_Explode"},
	Health = 1, --for single building tiles?
}
archive_trapped_1_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "archive_trapped_1"
	}
}

archive_trapped_2 = Trapped_Building:new{
	Image = "archive_trapped_2",
	SkillList = {"archive_trapped_2_Explode"},
}
archive_trapped_2_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "archive_trapped_2"
	}
}


--RST trapped buildings
rst_trapped_1 = Trapped_Building:new{
	Image = "rst_trapped_1",
	SkillList = {"rst_trapped_1_Explode"},
	Health = 1, --for single building tiles?
}
rst_trapped_1_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "rst_trapped_1"
	}
}

rst_trapped_2 = Trapped_Building:new{
	--Image = "rst_trapped_2", --KEEP IT COMMENTED
	SkillList = {"rst_trapped_2_Explode"},
}
rst_trapped_2_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "rst_trapped_2"
	}
}


--Pinnacle trapped buildings
pinnacle_trapped_1 = Trapped_Building:new{
	Image = "pinnacle_trapped_1",
	SkillList = {"pinnacle_trapped_1_Explode"},
	Health = 1, --for single building tiles?
}
pinnacle_trapped_1_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "pinnacle_trapped_1"
	}
}

pinnacle_trapped_2 = Trapped_Building:new{
	Image = "pinnacle_trapped_2",
	SkillList = {"pinnacle_trapped_2_Explode"},
}
pinnacle_trapped_2_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "pinnacle_trapped_2"
	}
}

--Detritus trapped buildings
detritus_trapped_1 = Trapped_Building:new{
	Image = "detritus_trapped_1",
	SkillList = {"detritus_trapped_1_Explode"},
	Health = 1, --for single building tiles?
}
detritus_trapped_1_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "detritus_trapped_1"
	}
}

detritus_trapped_2 = Trapped_Building:new{
	Image = "detritus_trapped_2",
	SkillList = {"detritus_trapped_2_Explode"},
}
detritus_trapped_2_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "detritus_trapped_2"
	}
}


--Meridia trapped buildings
Meridia_trapped_1 = Trapped_Building:new{
	Image = "Meridia_trapped_1",
	SkillList = {"Meridia_trapped_1_Explode"},
	Health = 1, --for single building tiles?
}
Meridia_trapped_1_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "Meridia_trapped_1"
	}
}

Meridia_trapped_2 = Trapped_Building:new{
	Image = "Meridia_trapped_2",
	SkillList = {"Meridia_trapped_2_Explode"},
}
Meridia_trapped_2_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "Meridia_trapped_2"
	}
}

--Nautilus trapped buildings
Nautilus_island_id_trapped_1 = Trapped_Building:new{
	Image = "Nautilus_island_id_trapped_1",
	SkillList = {"Nautilus_island_id_trapped_1_Explode"},
	Health = 1, --for single building tiles?
}
Nautilus_island_id_trapped_1_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "Nautilus_island_id_trapped_1"
	}
}

Nautilus_island_id_trapped_2 = Trapped_Building:new{
	Image = "Nautilus_island_id_trapped_2",
	SkillList = {"Nautilus_island_id_trapped_2_Explode"},
}
Nautilus_island_id_trapped_2_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "Nautilus_island_id_trapped_2"
	}
}


--Candy trapped buildings
tatu_Candy_Island_trapped_1 = Trapped_Building:new{
	Image = "tatu_Candy_Island_trapped_1",
	SkillList = {"tatu_Candy_Island_trapped_1_Explode"},
	Health = 1, --for single building tiles?
}
tatu_Candy_Island_trapped_1_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "tatu_Candy_Island_trapped_1"
	}
}

tatu_Candy_Island_trapped_2 = Trapped_Building:new{
	Image = "tatu_Candy_Island_trapped_2",
	SkillList = {"tatu_Candy_Island_trapped_2_Explode"},
}
tatu_Candy_Island_trapped_2_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "tatu_Candy_Island_trapped_2"
	}
}

--FarLine trapped buildings
FarLine_trapped_1 = Trapped_Building:new{
	Image = "FarLine_trapped_1",
	SkillList = {"FarLine_trapped_1_Explode"},
	Health = 1, --for single building tiles?
}
FarLine_trapped_1_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "FarLine_trapped_1"
	}
}

FarLine_trapped_2 = Trapped_Building:new{
	Image = "FarLine_trapped_2",
	SkillList = {"FarLine_trapped_2_Explode"},
}
FarLine_trapped_2_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "FarLine_trapped_2"
	}
}


--Watchtower trapped buildings
Watchtower_trapped_1 = Trapped_Building:new{
	Image = "Watchtower_trapped_1",
	SkillList = {"Watchtower_trapped_1_Explode"},
	Health = 1, --for single building tiles?
}
Watchtower_trapped_1_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "Watchtower_trapped_1"
	}
}

Watchtower_trapped_2 = Trapped_Building:new{
	Image = "Watchtower_trapped_2",
	SkillList = {"Watchtower_trapped_2_Explode"},
}
Watchtower_trapped_2_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "Watchtower_trapped_2"
	}
}


--Vertex trapped buildings
Vertex_trapped_1 = Trapped_Building:new{
	Image = "Vertex_trapped_1",
	SkillList = {"Vertex_trapped_1_Explode"},
	Health = 1, --for single building tiles?
}
Vertex_trapped_1_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "Vertex_trapped_1"
	}
}

Vertex_trapped_2 = Trapped_Building:new{
	Image = "Vertex_trapped_2",
	SkillList = {"Vertex_trapped_2_Explode"},
}
Vertex_trapped_2_Explode = Trapped_Explode:new{
	TipImage = {
		Unit       = Point(2, 2),
		Target     = Point(2, 2),
		Building   = Point(3, 2),
		Enemy      = Point(2, 1),
		Enemy2     = Point(2, 3),
		CustomPawn = "Vertex_trapped_2"
	}
}


--Ice Mine
truelch_IceMine = SnowmineAtk1:new{
	Icon = "weapons/truelch_ice_mines.png",
}

--What if the mine layer was actually controllable?
truelch_PinnacleAlly = Pawn:new{
	Name = "Pinnacle ally",
	Health = 1,
	MoveSpeed = 0,
	Image = "snowmine1",
	SkillList = { "truelch_IceMine" },  
	SoundLocation = "/enemy/snowmine_1/",
	DefaultTeam = TEAM_PLAYER,
	DefaultFaction = FACTION_BOTS,
	ImpactMaterial = IMPACT_METAL,
	IgnoreSmoke = true, --idk
	--Neutral = true,
	--AvoidingMines = true,
}
AddPawn("truelch_PinnacleAlly")

truelch_MeridiaWall = Pawn:new{
	Name = "Meridia's Vine",
	Health = 1,
	MoveSpeed = 0,
	Image = "truelch_meridia_wall",
	SoundLocation = "/support/rock/", --TODO
	DefaultTeam = TEAM_PLAYER, --so that Vek attempt to get rid of them
	ImpactMaterial = IMPACT_FLESH, --IMPACT_BLOB
	Neutral = true, --but we can't control them (nor are they displayed in the UI)
}
AddPawn("truelch_MeridiaWall")

truelch_WatchtowerAlly = Pawn:new{
	Name = "War Rig",
	Health = 2, --1, 2 or 3
	MoveSpeed = 3, --or 4?
	Armor = true, --Maybe?
	Image = "truelch_tosx_rig", --truelch_tosx_rig --tosx_rig1
	SkillList = { "truelch_WatchtowerAlly_Weapon" },  
	SoundLocation = "/support/vip_truck/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Neutral = true, --lmao
	AvoidingMines = true, --let's make it half smart
}
AddPawn("truelch_WatchtowerAlly")

truelch_WatchtowerAlly_Weapon = Skill:new{
	--Infos
	Name = "Engines",
	Description = "Charge in a line and slam into the target, pushing it."..
		"It'll avoid bump damage towards buildings!",
	Class = "Unique",

	--Art
	Icon = "weapons/truelch_tosx_rig_engine.png",
	Anim = "airpush_",
	LaunchSound = "/weapons/charge",
	ImpactSound = "/weapons/charge_impact",

	--Gameplay
	Damage = 1,
	PathSize = 7,

	--Tip image
	TipImage = {
		Unit = Point(2, 3),
		Enemy = Point(2, 1),
		Target = Point(2, 1),
		CustomPawn = "truelch_WatchtowerAlly",
	}
}

function truelch_WatchtowerAlly_Weapon:GetTargetScore(p1, p2)
	local score = -10

	local target = Board:GetPawn(p2)
	if target ~= nil and target:IsEnemy() then
		score = score + 50

		local forwardDir = GetDirection(p2 - p1)
		local behind = p2 + DIR_VECTORS[forwardDir]

		--What's the difference between IsGuarding() and (not) IsPushable()??
		if target:IsPushable() then
			local pawnBehind = Board:GetPawn(behind)
			if Board:IsBuilding(behind) then
				score = score -200 --I hope this will be enough to prevent bump damage toward buildings
			elseif pawnBehind ~= nil then
				if pawnBehind:IsEnemy() then
					score = score + 50
				else
					score = score - 25
				end
			end
		end
	end

	return score
end

function truelch_WatchtowerAlly_Weapon:GetTargetArea(point)
    local ret = PointList()

    for dir = DIR_START, DIR_END do
    	ret:push_back(point + DIR_VECTORS[dir])
    end

    return ret
end

function truelch_WatchtowerAlly_Weapon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	local pathing = Pawn:GetPathProf()

	local doDamage = true
	local target = GetProjectileEnd(p1, p2, pathing)
	local distance = p1:Manhattan(target)
	
	if not Board:IsBlocked(target, pathing) then -- dont attack an empty edge square, just run to the edge
		doDamage = false
		target = target + DIR_VECTORS[direction]
	end
	
	local damage = SpaceDamage(target, self.Damage, direction)
	damage.sAnimation = self.Anim..direction
	damage.sSound = self.ImpactSound
	
	if distance == 1 and doDamage then
		ret:AddMelee(p1, damage, NO_DELAY)
	else
		ret:AddCharge(Board:GetSimplePath(p1, target - DIR_VECTORS[direction]), FULL_DELAY)		
		if doDamage then
			ret:AddDamage(damage)
		end	
	end	

	return ret
end


-- FMW >>>>>>>>>>>>>>>>>>>>>>

-- SIMPLE REPAIR MODE --
truelch_RepairMode = {
	aFM_name = "Mech Repair", -- required
	aFM_desc = "Repair 1 damage and remove Fire, Ice, and A.C.I.D.", -- required
	aFM_icon = "img/modes/icon_repair_mode.png", -- required (if you don't have an image an empty string will work)
	-- aFM_limited = 2, -- optional (FMW will automatically handle uses for repair skills)
	-- aFM_handleLimited = false -- optional (FMW will no longer automatically handle uses for this mode if set) 
}

CreateClass(truelch_RepairMode)

function truelch_RepairMode:targeting(point)
	local points = {}
	points[#points+1] = point
	return points
end

function truelch_RepairMode:fire(p1, p2, se)
	local damage = SpaceDamage(p2, -1)
	damage.iFire = EFFECT_REMOVE
	damage.iAcid = EFFECT_REMOVE
	se:AddDamage(damage)
end

-- ARCHIVE MODE --
--Add proper preview damage mark
truelch_ArchiveMode = truelch_RepairMode:new {
	aFM_name = "Archive", -- required
	aFM_desc = "Calls-in an air strike, killing anything in a cross-shaped area after the Vek turn.", --Maybe it should cost 2 charges?
	aFM_icon = "img/modes/icon_archive_mode.png", -- required (if you don't have an image an empty string will work)
	aFM_limited = 4, --1

	Island = "archive",
}

function truelch_ArchiveMode:targeting(point)
	local points = {}
	
	for j = 0, 7 do
		for i = 0, 7 do
			local curr = Point(i, j)
			points[#points+1] = curr
		end
	end

	return points
end


-- ARCHIVE MODE --
--from mission_airstrike.lua
local function GetAttackArea(space)
	local ret = { space }
	for dir = DIR_START, DIR_END do
		ret[#ret+1] = space + DIR_VECTORS[dir]
	end

	return ret
end

function truelch_ArchiveMode:fire(p1, p2, se)
	local damage = SpaceDamage(p2, 0)
	damage.sImageMark = "combat/icons/icon_truelch_bomb.png"
	se:AddDamage(damage)
	for dir = DIR_START, DIR_END do
		damage.loc = p2 + DIR_VECTORS[dir]
		se:AddDamage(damage)
	end

	if IsTestMechScenario() then
		se:AddScript(string.format([[Board:AddAlert(%s, "AFTER ENEMY TURN")]], p1:GetString()))

		se:AddDelay(1)
		
		se:AddSound("/props/airstrike")
		se:AddAirstrike(p2, "units/mission/bomber_1.png")
		
		local spaces = GetAttackArea(p2)
		
		local damage = SpaceDamage(Point(0, 0), DAMAGE_DEATH)
		damage.sAnimation = "ExploArt2"
		damage.sSound = "/props/airstrike_explosion"
		
		for i, v in ipairs(spaces) do
			damage.loc = v
			se:AddDamage(damage)
			se:AddBounce(v, 6)
		end

		return
	end

	se:AddScript([[
		local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
		modapiext.dialog:triggerRuledDialog("Truelch_Airstrike_Requested", cast)
	]])

	se:AddScript([[
		local p = ]]..p2:GetString()..[[;
		GetCurrentMission().Potluck_Truelch_Archive = p;
	]])
end


-- RST MODE --
truelch_RSTMode = truelch_RepairMode:new{
	aFM_name = "R.S.T.",
	aFM_desc = "Evacuate a building. Next turn, it becomes a trapped building.", 
	aFM_icon = "img/modes/icon_rst_mode.png",
	aFM_limited = 4, --1

	Island = "rst",
}

function truelch_RSTMode:targeting(point)
	local points = {}
	
	for j = 0, 7 do
		for i = 0, 7 do
			local curr = Point(i, j)
			if Board:IsBuilding(curr) and not Board:IsUniqueBuilding(curr) and Board:IsPowered(curr) then
				points[#points+1] = curr
			end
		end
	end

	return points
end

function truelch_RSTMode:fire(p1, p2, se)
	local damage = SpaceDamage(p2, 0)
	damage.sImageMark = "combat/icons/icon_truelch_evacuate.png"
	se:AddDamage(damage)
	se:AddSound("/support/helicopter/move")
	se:AddReverseAirstrike(p2, "effects/truelch_evac_heli.png")

	if IsTestMechScenario() then
		se:AddScript([[
			local p = ]]..p2:GetString()..[[;
			Board:SetPopulated(false, p);
			Board:Ping(p, GL_Color(255,255,255,1));
			Game:TriggerSound("/ui/battle/population_points");
		]])

		se:AddDelay(1)

		se:AddScript(string.format([[Board:AddAlert(%s, "NEXT TURN")]], p1:GetString()))

		se:AddSound("/support/helicopter/move")

		se:AddAirstrike(p2, "effects/truelch_evac_heli.png")

		local health = Board:GetHealth(p2)

		if health < 1 then health = 1 end --in test mode, the building will not lose its last hp since everything happen in one go
		if health > 2 then health = 2 end

		local pawnName = getTrappedBuilding(tostring(health))

		se:AddSound("/impact/generic/grapple")

		se:AddScript([[
			Board:SetTerrain(]]..p2:GetString()..[[, TERRAIN_ROAD)
			Board:AddAlert(]]..p2:GetString()..[[, "BUILDING TRAPPED!")

			local pawnName = getTrappedBuilding(]]..tostring(health)..[[)
			if pawnName ~= nil and pawnName ~= "" then
				Board:AddPawn("]]..pawnName..[[", ]]..p2:GetString()..[[)
			else
				Board:AddPawn("Trapped_Building", ]]..p2:GetString()..[[)
			end
		]])

		return
	end

	LOG("[TRUELCH] truelch_RSTMode:fire -> Game:GetCorp().name: "..Game:GetCorp().name)

	if Game:GetCorp().name == "" then
		LOG("[TRUELCH] FINAL")
		--Final island
		se:AddScript([[
			local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
			modapiext.dialog:triggerRuledDialog("Truelch_Trap_Final_Requested", cast)
		]])
	else
		LOG("[TRUELCH] REGULAR")
		--Regular island
		se:AddScript([[
			local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
			modapiext.dialog:triggerRuledDialog("Truelch_Trap_Requested", cast)
		]])
	end
	

	--Stolen, I mean stronly inspired from Lemonymous' weapon_apc.lua
	se:AddScript([[
		local p = ]]..p2:GetString()..[[;
		Board:SetPopulated(false, p);
		Board:Ping(p, GL_Color(255,255,255,1));
		Game:TriggerSound("/ui/battle/population_points");
		GetCurrentMission().Potluck_Truelch_RST = p;
	]])
end


-- PINNACLE MODE --
truelch_PinnacleMode = truelch_RepairMode:new{
	aFM_name = "Pinnacle",
	aFM_desc = "Deploy a friendly robot that deploys freezing mines. You have control of it.", 
	aFM_icon = "img/modes/icon_pinnacle_mode.png",
	aFM_limited = 4, --1

	Island = "pinnacle",
}

function truelch_PinnacleMode:targeting(point)
	local points = {}
	
	for j = 0, 7 do
		for i = 0, 7 do
			local curr = Point(i, j)
			if not Board:IsBlocked(curr, PATH_PROJECTILE) then
				points[#points+1] = curr
			end
		end
	end

	return points
end

function truelch_PinnacleMode:fire(p1, p2, se)
	local damage = SpaceDamage(p2, 0)

	damage.sPawn = "truelch_PinnacleAlly"

	se:AddSound("/props/factory_launch")

	se:AddArtillery(damage, "effects/shotup_robot.png", FULL_DELAY)

	se:AddSound("/impact/generic/mech")

	if not IsTestMechScenario() then
		se:AddScript([[
			local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
			modapiext.dialog:triggerRuledDialog("Truelch_PinnacleBot_Launched", cast)
		]])
	end
end

-- DETRITUS MODE --
truelch_DetritusMode = truelch_RepairMode:new{
	aFM_name = "Detritus",
	aFM_desc = "Free action.\nSwap position with another unit.\nApply A.C.I.D. around the new position.",
	aFM_icon = "img/modes/icon_detritus_mode.png",
	aFM_limited = 4, --1

	Island = "detritus",
}

function truelch_DetritusMode:targeting(point)
	local points = {}
	
	for _, id in ipairs(extract_table(Board:GetPawns(TEAM_ANY))) do
		local pawn = Board:GetPawn(id)
		if not pawn:IsGuarding() and pawn:GetSpace() ~= point then
			points[#points+1] = pawn:GetSpace()
		end
	end

	return points
end

function truelch_DetritusMode:fire(p1, p2, se)
	--Swap with target
	se:AddSound("/weapons/force_swap")
	se:AddTeleport(p1, p2, NO_DELAY)
	se:AddTeleport(p2, p1, FULL_DELAY)

	--se:AddDelay(1)

	--Apply A.C.I.D. to nearby tiles
	for dir = DIR_START, DIR_END do
		local curr = p2 + DIR_VECTORS[dir]
		local damage = SpaceDamage(curr, 0)
		damage.iAcid = EFFECT_CREATE
		se:AddDamage(damage)
	end

	if not IsTestMechScenario() then
		se:AddScript([[
			local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
			modapiext.dialog:triggerRuledDialog("Truelch_Detritus_Used", cast)
		]])
	end
end


-- MERIDIA MODE --
truelch_MeridiaMode = truelch_RepairMode:new{
	aFM_name = "Meridia",
	aFM_desc = "Surround a target with entraving vines.", 
	aFM_icon = "img/modes/icon_meridia_mode.png",
	aFM_limited = 4, --1

	Island = "Meridia",
}

function truelch_MeridiaMode:targeting(point)
	local points = {}
	
	for j = 0, 7 do
		for i = 0, 7 do
			local curr = Point(i, j)
			if Board:IsBlocked(curr, PATH_PROJECTILE) then --You can entrave an enemy, an ally, a building, or even a mountain!
				points[#points+1] = curr
			end
		end
	end

	return points
end

function truelch_MeridiaMode:fire(p1, p2, se)
	for dir = DIR_START, DIR_END do
		local curr = p2 + DIR_VECTORS[dir]
		--Check to not spawn in water, lava, etc.?
		if not Board:IsBlocked(curr, PATH_PROJECTILE) then
			local damage = SpaceDamage(curr, 0)
			damage.sPawn = "truelch_MeridiaWall"
			se:AddDamage(damage)
		end
	end

	se:AddSound("/enemy/shared/crawl_out")

	if not IsTestMechScenario() then
		se:AddScript([[
			local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
			modapiext.dialog:triggerRuledDialog("Truelch_Meridia_Used", cast)
		]])
	end
end


-- NAUTILUS MODE --
truelch_NautilusMode = truelch_RepairMode:new{
	aFM_name = "Nautilus",
	aFM_desc = "Crack all emerge points and force a Vek to emerge.",
	aFM_icon = "img/modes/icon_nautilus_mode.png",
	aFM_limited = 4, --1

	Island = "Nautilus_island_id",
}

function truelch_NautilusMode:targeting(point)
	local points = {}

	if isMission() then
        local mission = GetCurrentMission()
        for j = 0, 7 do
            for i = 0, 7 do
                local curr = Point(i, j)
                local spawn = GetCurrentMission():GetSpawnPointData(curr)
                if spawn ~= nil and not Board:IsBlocked(curr, PATH_PROJECTILE) then
                    points[#points+1] = curr
                end
            end
        end
    end

	return points
end

function truelch_NautilusMode:fire(p1, p2, se)
	--How could I make something playable in test mech mode??

	se:AddScript([[
    	local spawn = GetCurrentMission():GetSpawnPointData(]]..p2:GetString()..[[)
        Board:AddPawn(spawn.type, ]]..p2:GetString()..[[)
        if Board:GetPawn(]]..p2:GetString()..[[) ~= nil then
        	LOG("[TRUELCH] SUCCESS - should play emerge animation")
            Board:GetPawn(]]..p2:GetString()..[[):SpawnAnimation()
        end
        GetCurrentMission():RemoveSpawnPoint(]]..p2:GetString()..[[)
    ]])

    se:AddDelay(1)

    for j = 0, 7 do
        for i = 0, 7 do
            local curr = Point(i, j)
            local spawn = GetCurrentMission():GetSpawnPointData(curr)
            if spawn ~= nil then
	            local damage = SpaceDamage(curr, 0)
		        damage.iCrack = EFFECT_CREATE
		        se:AddDamage(damage)
        	end
        end
    end

    local damage = SpaceDamage(p2, 0)
    damage.sImageMark = "combat/icons/icon_truelch_emerge.png"
    se:AddDamage(damage)

    se:AddScript([[
		local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
		modapiext.dialog:triggerRuledDialog("Truelch_Nautilus_Used", cast)
	]])
end


-- CANDY MODE --
truelch_CandyMode = truelch_RepairMode:new{
	aFM_name = "Candy",
	aFM_desc = "Free action.\nSwitch position with the first aligned unit, confusing it.", 
	aFM_icon = "img/modes/icon_candy_mode.png",
	aFM_limited = 4, --1

	Island = "tatu_Candy_Island",
}

function truelch_CandyMode:targeting(point)
	local points = {}

	for dir = DIR_START, DIR_END do
		for i = 1, 7 do
			local curr = point + DIR_VECTORS[dir]*i
			local pawn = Board:GetPawn(curr)
			if pawn ~= nil and not pawn:IsGuarding() then
				points[#points+1] = curr
				break
			end

			if not Board:IsValid(curr) then
				break
			end
		end
	end

	return points
end

--Swap with (first) aligned unit.
--TODO: when weapon is armed, display a rainbow animation
--I should do a "yeet" animation instead of teleportation, but I'm lazy
function truelch_CandyMode:fire(p1, p2, se)

	local damage = SpaceDamage(p2, 0, DIR_FLIP) --p1 or p2??
	se:AddDamage(damage)

	local damage = SpaceDamage(p1, 0, DIR_FLIP) --p1 or p2??
	se:AddDamage(damage)

	--Swap
	se:AddSound("/weapons/force_swap")
	se:AddTeleport(p1, p2, NO_DELAY)
	se:AddTeleport(p2, p1, FULL_DELAY)

	local damage = SpaceDamage(p1, 0)
	damage.sImageMark = "combat/icons/icon_truelch_flip_teleport.png"
	se:AddDamage(damage)

	if not IsTestMechScenario() then
		--Free action
		se:AddDelay(0.1)
		se:AddScript("Board:GetPawn("..p2:GetString().."):SetActive(true)") --p2 and not p1 because the Mech ends up there

		se:AddScript([[
			local cast = { main = ]]..Board:GetPawn(p2):GetId()..[[ }
			modapiext.dialog:triggerRuledDialog("Truelch_Candy_Used", cast)
		]])
	end
end


-- FARLINE MODE --
truelch_FarlineMode = truelch_RepairMode:new{
	aFM_name = "Far Line",
	aFM_desc = "Calls-in a tsunami from a side that goes through the battlefield until it detects an obstacle.", 
	aFM_icon = "img/modes/icon_farline_mode.png",
	aFM_limited = 4, --1

	Island = "FarLine",
}

function truelch_FarlineMode:targeting(point)
	local points = {}

	for i = 1, 6 do
		points[#points+1] = Point(0, i)
		points[#points+1] = Point(Board:GetSize().x - 1, i)
		points[#points+1] = Point(i, 0)
		points[#points+1] = Point(i, Board:GetSize().y - 1)
	end

	return points
end

local function canBeFlooded(point)
	return Board:IsValid(point) and not Board:IsBlocked(point, PATH_PROJECTILE) and Board:GetTerrain(point) ~= TERRAIN_CHASM
end

function truelch_FarlineMode:fire(p1, p2, se)
	local wavePoints = {}
	local dir = 0
	local max = 0 --for the for loop. Should usually be 8 (reminder, for the for loop, it goes from 1 -> 8, not 0 -> 7)

	if p2.x == 0 then
		dir = DIR_RIGHT
		max = Board:GetSize().x
		for i = 0, Board:GetSize().y - 1 do
			wavePoints[#wavePoints+1] = Point(0, i)
		end

	elseif p2.x == Board:GetSize().x - 1 then
		dir = DIR_LEFT
		max = Board:GetSize().x
		for i = 0, Board:GetSize().y - 1 do
			wavePoints[#wavePoints+1] = Point(Board:GetSize().x - 1, i)
		end

	elseif p2.y == 0 then
		--dir = DIR_UP
		dir = DIR_DOWN --this doesn't make any sense
		max = Board:GetSize().y
		for i = 0, Board:GetSize().x - 1 do
			wavePoints[#wavePoints+1] = Point(i, 0)
		end

	elseif p2.y == Board:GetSize().y - 1 then
		--dir = DIR_DOWN
		dir = DIR_UP --this doesn't make any sense
		max = Board:GetSize().y
		for i = 0, Board:GetSize().x - 1 do
			wavePoints[#wavePoints+1] = Point(i, Board:GetSize().y - 1)
		end

	else
		LOG("Unexpected p2: "..p2:GetString())
		--return
	end

	--effect:AddSound("/props/tide_flood_last")
	--effect:AddSound("/props/tide_flood")
	--effect:AddBounce(floodAnim.loc, -6)

	local occ = 0
	loopContinue = true

	while loopContinue do
		local okAmount = 0

		for i = 1, max do
			local start = wavePoints[i]
			if start ~= nil then
				local curr = start + DIR_VECTORS[dir]*occ
				if canBeFlooded(curr) then
					okAmount = okAmount + 1
					local floodAnim = SpaceDamage(curr, 0)
					floodAnim.iTerrain = TERRAIN_WATER
					floodAnim.sImageMark = "combat/icons/icon_water.png"
					if Board:GetTerrain(curr) == TERRAIN_MOUNTAIN then
						floodAnim.iDamage = DAMAGE_DEATH
					end
					se:AddDamage(floodAnim)
					se:AddBounce(curr, -6)
					se:AddSound("/props/tide_flood")
				else
					wavePoints[i] = nil
				end
			end
		end

		if okAmount == 0 then
			se:AddSound("/props/tide_flood_last")
			loopContinue = false
			break
		end

		--Safety
		occ = occ + 1
		if occ > 8 then
			loopContinue = false
		end

		se:AddDelay(0.2)
	end

	if not IsTestMechScenario() then
		se:AddScript([[
			local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
			modapiext.dialog:triggerRuledDialog("Truelch_Farline_Used", cast)
		]])
	end
end


-- WATCHTOWER MODE --
truelch_WatchtowerMode = truelch_RepairMode:new{
	aFM_name = "Watchtower",
	aFM_desc = "Deploy a friendly but uncontrollable War Rig.", 
	aFM_icon = "img/modes/icon_watchtower_mode.png",
	aFM_limited = 4, --1

	Island = "Watchtower",
}

function truelch_WatchtowerMode:targeting(point)
	local points = {}

	for dir = DIR_START, DIR_END do
		local curr = point + DIR_VECTORS[dir]

		--Check for water, lava, etc.?
		if not Board:IsBlocked(curr, PATH_PROJECTILE) then
			points[#points+1] = curr
		end
	end

	return points
end

function truelch_WatchtowerMode:fire(p1, p2, se)
	--Note: in test mech mode, this uncontrollable ally will do nothing
	local damage = SpaceDamage(p2, 0)
	damage.sPawn = "truelch_WatchtowerAlly"
	se:AddDamage(damage)

	se:AddSound("/mech/prime/bottlecap_mech/move")

	--Maybe after a delay?
	--se:AddDelay(1)
	--local pawn = Board:GetPawn(p2)
	--if pawn ~= nil then
		--LOG("[TRUELCH] YEAH")
		--pawn:Fall(0) --doesn't work
		--pawn:SpawnAnimation() --there's no emerge anim
	--end

	if not IsTestMechScenario() then
		se:AddScript([[
			local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
			modapiext.dialog:triggerRuledDialog("Truelch_Watchtower_Used", cast)
		]])
	end

end


-- VERTEX MODE --
truelch_VertexMode = truelch_RepairMode:new{
	aFM_name = "Vertex",
	aFM_desc = "Free action.\nAll units that dies during this turn (also during enemy turn) will shoot crystals in all directions, damaging the first non-building obstacle hit. Allies are healed instead.\nNote: the projectiles are launched from the position the unit received the lethal damage, not the position where it ends up dying.",
	aFM_icon = "img/modes/icon_vertex_mode.png",
	aFM_limited = 4, --1

	Island = "Vertex",
}

function truelch_VertexMode:targeting(point)
	local points = {}

	local stacks = GAME.Potluck_Truelch_Memories["Vertex"]
	
	for j = 0, 7 do
		for i = 0, 7 do
			local curr = Point(i, j)
			local pawn = Board:GetPawn(curr)
			if curr == point then
				points[#points+1] = curr
			end
		end
	end

	return points
end

function truelch_VertexMode:fire(p1, p2, se)
	local pawn = Board:GetPawn(p2)

	if p2 == p1 then
		--Crystal shards on death effect
		se:AddScript([[
			GetCurrentMission().Potluck_Truelch_Vertex = true
			Board:AddAlert(]]..p1:GetString()..[[, "CRYSTAL PROJECTILES")
			Board:Ping(]]..p1:GetString()..[[, GL_Color(255, 55, 0, 1))
		]])

		se:AddSound("/props/freezing")

		if not IsTestMechScenario() then
			--Free action
			se:AddDelay(0.1)
			se:AddScript("Board:GetPawn("..p1:GetString().."):SetActive(true)")
			se:AddScript([[
				local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
				modapiext.dialog:triggerRuledDialog("Truelch_Vertex_OnDeathShards", cast)
			]])
		end
	else
		LOG("Unexpected target.")
	end
end


-- FMWeapon --
TruelchSkillFMW_Link = aFM_WeaponTemplate:new{
	Name = "Traveler's Nostalgia",
	Description = "Spending time on an island increase popularity points that can be spent to ask for help.\nClick on the repair button to see all the support powers.",
	--I'm lazy
	--[[
	TipImage = {

	}
	]]
}

function TruelchSkillFMW_Link:GetTargetArea(point)
	local pl = PointList()

	-- required
	fmw:RegisterRepair(point,
		{
			"truelch_RepairMode", --let's have a regular repair!
			"truelch_ArchiveMode", "truelch_RSTMode", "truelch_PinnacleMode", "truelch_DetritusMode", --vanilla islands
			"truelch_MeridiaMode", "truelch_NautilusMode", "truelch_CandyMode", --modded islands
			"truelch_FarlineMode", "truelch_WatchtowerMode", "truelch_VertexMode" --tosx islands
		}, -- mode list
		"Click to ask help of a different island." --mode switch button description
	)

	--Assign limited uses here (for all modes, not only currentMode)
	if not IsTestMechScenario() then
		self:FM_SetUses(point, "truelch_ArchiveMode",    GAME.Potluck_Truelch_Memories["archive"])
		self:FM_SetUses(point, "truelch_RSTMode",        GAME.Potluck_Truelch_Memories["rst"])
		self:FM_SetUses(point, "truelch_PinnacleMode",   GAME.Potluck_Truelch_Memories["pinnacle"])
		self:FM_SetUses(point, "truelch_DetritusMode",   GAME.Potluck_Truelch_Memories["detritus"])

		self:FM_SetUses(point, "truelch_MeridiaMode",    GAME.Potluck_Truelch_Memories["Meridia"])
		self:FM_SetUses(point, "truelch_NautilusMode",   GAME.Potluck_Truelch_Memories["Nautilus_island_id"])
		self:FM_SetUses(point, "truelch_CandyMode",      GAME.Potluck_Truelch_Memories["tatu_Candy_Island"])

		self:FM_SetUses(point, "truelch_FarlineMode",    GAME.Potluck_Truelch_Memories["FarLine"])
		self:FM_SetUses(point, "truelch_WatchtowerMode", GAME.Potluck_Truelch_Memories["Watchtower"])
		self:FM_SetUses(point, "truelch_VertexMode",     GAME.Potluck_Truelch_Memories["Vertex"])
	else
		self:FM_SetUses(point, "truelch_ArchiveMode",    -1)
		self:FM_SetUses(point, "truelch_RSTMode",        -1)
		self:FM_SetUses(point, "truelch_PinnacleMode",   -1)
		self:FM_SetUses(point, "truelch_DetritusMode",   -1)

		self:FM_SetUses(point, "truelch_MeridiaMode",    -1)
		self:FM_SetUses(point, "truelch_NautilusMode",   -1)
		self:FM_SetUses(point, "truelch_CandyMode",      -1)

		self:FM_SetUses(point, "truelch_FarlineMode",    -1)
		self:FM_SetUses(point, "truelch_WatchtowerMode", -1)
		self:FM_SetUses(point, "truelch_VertexMode",     -1)
	end
	
	local currentMode = self:FM_GetMode(point)

	if self:FM_CurrentModeReady(point) then
		local points = _G[currentMode]:targeting(point)
		for _, p in ipairs(points) do
			pl:push_back(p)
		end
	end

	return pl
end

function TruelchSkillFMW_Link:GetSkillEffect(p1, p2)
	local se = SkillEffect()

	local currentMode = self:FM_GetMode(p1)

	if self:FM_CurrentModeReady(p1) then
		_G[currentMode]:fire(p1, p2, se)
	end

	if _G[currentMode].Island ~= nil and not IsTestMechScenario() then
		se:AddScript([[GAME.Potluck_Truelch_Memories[_G["]]..currentMode..[["].Island] = GAME.Potluck_Truelch_Memories[_G["]]..currentMode..[["].Island] - 1]])
		--self:FM_SetUses also here?
	end
	
	return se
end

-- <<<<<<<<<<<<<<<<<<<<<< FMW


function this:init(mod)
	CreatePilot(pilot)
	pilotSkill_tooltip.Add("truelch_ability", PilotSkill("Nostalgic Traveler", "Every mission passed on an island increase stacks that can be used for island support powers."))

	--Effects
	modApi:appendAsset("img/effects/truelch_shot_shard_R.png", mod.resourcePath.."img/effects/truelch_shot_shard_R.png")
	modApi:appendAsset("img/effects/truelch_shot_shard_U.png", mod.resourcePath.."img/effects/truelch_shot_shard_U.png")
	modApi:appendAsset("img/effects/truelch_evac_heli.png",    mod.resourcePath.."img/effects/truelch_evac_heli.png")

	--Skill: A lot of the skill will probably just be hooks, which goes down below
	--But art and icons can go here
	modApi:appendAsset("img/weapons/repair_truelch.png", mod.resourcePath.."img/weapons/repair_truelch.png")
	modApi:appendAsset("img/weapons/truelch_ice_mines.png", mod.resourcePath.."img/weapons/truelch_ice_mines.png") --stolen from Generic's Sentient Weapons

	--evacuate
	modApi:appendAsset("img/combat/icons/icon_truelch_evacuate.png", mod.resourcePath.."img/combat/icons/icon_truelch_evacuate.png")
		Location["combat/icons/icon_truelch_evacuate.png"] = Point(-17, 6)

	--force emerge (+ crack)
	modApi:appendAsset("img/combat/icons/icon_truelch_emerge.png", mod.resourcePath.."img/combat/icons/icon_truelch_emerge.png")
		Location["combat/icons/icon_truelch_emerge.png"] = Point(-14, 0)

	--bombing run
	modApi:appendAsset("img/combat/icons/icon_truelch_flip_teleport.png", mod.resourcePath.."img/combat/icons/icon_truelch_flip_teleport.png")
		Location["combat/icons/icon_truelch_flip_teleport.png"] = Point(-14, -10)

	--flip + teleport (candy)
	modApi:appendAsset("img/combat/icons/icon_truelch_bomb.png", mod.resourcePath.."img/combat/icons/icon_truelch_bomb.png")
		Location["combat/icons/icon_truelch_bomb.png"] = Point(-13, 0)

	--tosx' War Rig
	--Sprites made by tosx.
	--I'm putting truelch in the prefix to specify that it's used by my pilot.
	--I also don't know what would happen if two images with the exact same name end up at the same path.
	modApi:appendAsset("img/weapons/truelch_tosx_rig_engine.png", mod.resourcePath.."img/weapons/truelch_tosx_rig_engine.png")

	modApi:appendAsset("img/units/truelch_tosx_rig.png",    mod.resourcePath.."img/units/truelch_tosx_rig.png")
	modApi:appendAsset("img/units/truelch_tosx_rig_ns.png", mod.resourcePath.."img/units/truelch_tosx_rig_ns.png")
	modApi:appendAsset("img/units/truelch_tosx_riga.png",   mod.resourcePath.."img/units/truelch_tosx_riga.png")
	modApi:appendAsset("img/units/truelch_tosx_rigd.png",   mod.resourcePath.."img/units/truelch_tosx_rigd.png")

	ANIMS["truelch_tosx_rig"]    = ANIMS.BaseUnit:new{Image = "units/truelch_tosx_rig.png", PosX = -16, PosY = 7}
	ANIMS["truelch_tosx_riga"]   = ANIMS["truelch_tosx_rig"]:new{Image = "units/truelch_tosx_riga.png", NumFrames = 2, Time = 0.5}
	ANIMS["truelch_tosx_rigd"]   = ANIMS["truelch_tosx_rig"]:new{Image = "units/truelch_tosx_rigd.png", PosX = -19, PosY = 5, NumFrames = 11, Time = 0.12, Loop = false }
	ANIMS["truelch_tosx_rig_ns"] = ANIMS["truelch_tosx_rig"]:new{Image = "units/truelch_tosx_rig_ns.png"}

	--Meridia's vine wall
	modApi:appendAsset("img/units/truelch_meridia_wall.png",    mod.resourcePath.."img/units/truelch_meridia_wall.png")
	modApi:appendAsset("img/units/truelch_meridia_wall_ns.png", mod.resourcePath.."img/units/truelch_meridia_wall_ns.png")
	modApi:appendAsset("img/units/truelch_meridia_walla.png",   mod.resourcePath.."img/units/truelch_meridia_walla.png")
	modApi:appendAsset("img/units/truelch_meridia_walld.png",   mod.resourcePath.."img/units/truelch_meridia_walld.png")

	ANIMS["truelch_meridia_wall"]    = ANIMS.BaseUnit:new{Image = "units/truelch_meridia_wall.png", PosX = -29, PosY = -16}
	ANIMS["truelch_meridia_walla"]   = ANIMS["truelch_meridia_wall"]:new{Image = "units/truelch_meridia_walla.png", NumFrames = 1, Time = 0.5}
	ANIMS["truelch_meridia_walld"]   = ANIMS["truelch_meridia_wall"]:new{Image = "units/truelch_meridia_walld.png", PosX = -29, PosY = -16, NumFrames = 4, Time = 0.12, Loop = false }
	ANIMS["truelch_meridia_wall_ns"] = ANIMS["truelch_meridia_wall"]:new{Image = "units/truelch_meridia_wall_ns.png"}

	--Trapped buildings
	--final
	modApi:appendAsset("img/units/mission/final_trapped_1.png",  mod.resourcePath.."img/units/mission/final_trapped_1.png")
	modApi:appendAsset("img/units/mission/final_trapped_1d.png", mod.resourcePath.."img/units/mission/final_trapped_1d.png")
	ANIMS.final_trapped_1  = ANIMS.trapped_bldg:new {Image = "units/mission/final_trapped_1.png"}
	ANIMS.final_trapped_1d = ANIMS.trapped_bldgd:new{Image = "units/mission/final_trapped_1d.png"}

	modApi:appendAsset("img/units/mission/final_trapped_2.png",  mod.resourcePath.."img/units/mission/final_trapped_2.png")
	modApi:appendAsset("img/units/mission/final_trapped_2d.png", mod.resourcePath.."img/units/mission/final_trapped_2d.png")
	ANIMS.final_trapped_2  = ANIMS.trapped_bldg:new {Image = "units/mission/final_trapped_2.png"}
	ANIMS.final_trapped_2d = ANIMS.trapped_bldgd:new{Image = "units/mission/final_trapped_2d.png"}

	--archive
	modApi:appendAsset("img/units/mission/archive_trapped_1.png",  mod.resourcePath.."img/units/mission/archive_trapped_1.png")
	modApi:appendAsset("img/units/mission/archive_trapped_1d.png", mod.resourcePath.."img/units/mission/archive_trapped_1d.png")
	ANIMS.archive_trapped_1  = ANIMS.trapped_bldg:new {Image = "units/mission/archive_trapped_1.png"}
	ANIMS.archive_trapped_1d = ANIMS.trapped_bldgd:new{Image = "units/mission/archive_trapped_1d.png"}

	modApi:appendAsset("img/units/mission/archive_trapped_2.png",  mod.resourcePath.."img/units/mission/archive_trapped_2.png")
	modApi:appendAsset("img/units/mission/archive_trapped_2d.png", mod.resourcePath.."img/units/mission/archive_trapped_2d.png")
	ANIMS.archive_trapped_2  = ANIMS.trapped_bldg:new {Image = "units/mission/archive_trapped_2.png"}
	ANIMS.archive_trapped_2d = ANIMS.trapped_bldgd:new{Image = "units/mission/archive_trapped_2d.png"}

	--rst
	modApi:appendAsset("img/units/mission/rst_trapped_1.png",  mod.resourcePath.."img/units/mission/rst_trapped_1.png")
	modApi:appendAsset("img/units/mission/rst_trapped_1d.png", mod.resourcePath.."img/units/mission/rst_trapped_1d.png")
	ANIMS.rst_trapped_1  = ANIMS.trapped_bldg:new {Image = "units/mission/rst_trapped_1.png"}
	ANIMS.rst_trapped_1d = ANIMS.trapped_bldgd:new{Image = "units/mission/rst_trapped_1d.png"}

	--RST 2 buildings trapped already exists in vanilla

	--pinnacle
	modApi:appendAsset("img/units/mission/pinnacle_trapped_1.png",  mod.resourcePath.."img/units/mission/pinnacle_trapped_1.png")
	modApi:appendAsset("img/units/mission/pinnacle_trapped_1d.png", mod.resourcePath.."img/units/mission/pinnacle_trapped_1d.png")
	ANIMS.pinnacle_trapped_1  = ANIMS.trapped_bldg:new {Image = "units/mission/pinnacle_trapped_1.png"}
	ANIMS.pinnacle_trapped_1d = ANIMS.trapped_bldgd:new{Image = "units/mission/pinnacle_trapped_1d.png"}

	modApi:appendAsset("img/units/mission/pinnacle_trapped_2.png",  mod.resourcePath.."img/units/mission/pinnacle_trapped_2.png")
	modApi:appendAsset("img/units/mission/pinnacle_trapped_2d.png", mod.resourcePath.."img/units/mission/pinnacle_trapped_2d.png")
	ANIMS.pinnacle_trapped_2  = ANIMS.trapped_bldg:new {Image = "units/mission/pinnacle_trapped_2.png"}
	ANIMS.pinnacle_trapped_2d = ANIMS.trapped_bldgd:new{Image = "units/mission/pinnacle_trapped_2d.png"}

	--detritus
	modApi:appendAsset("img/units/mission/detritus_trapped_1.png",  mod.resourcePath.."img/units/mission/detritus_trapped_1.png")
	modApi:appendAsset("img/units/mission/detritus_trapped_1d.png", mod.resourcePath.."img/units/mission/detritus_trapped_1d.png")
	ANIMS.detritus_trapped_1  = ANIMS.trapped_bldg:new {Image = "units/mission/detritus_trapped_1.png"}
	ANIMS.detritus_trapped_1d = ANIMS.trapped_bldgd:new{Image = "units/mission/detritus_trapped_1d.png"}

	modApi:appendAsset("img/units/mission/detritus_trapped_2.png",  mod.resourcePath.."img/units/mission/detritus_trapped_2.png")
	modApi:appendAsset("img/units/mission/detritus_trapped_2d.png", mod.resourcePath.."img/units/mission/detritus_trapped_2d.png")
	ANIMS.detritus_trapped_2  = ANIMS.trapped_bldg:new {Image = "units/mission/detritus_trapped_2.png"}
	ANIMS.detritus_trapped_2d = ANIMS.trapped_bldgd:new{Image = "units/mission/detritus_trapped_2d.png"}

	--Meridia
	modApi:appendAsset("img/units/mission/Meridia_trapped_1.png",  mod.resourcePath.."img/units/mission/Meridia_trapped_1.png")
	modApi:appendAsset("img/units/mission/Meridia_trapped_1d.png", mod.resourcePath.."img/units/mission/Meridia_trapped_1d.png")
	ANIMS.Meridia_trapped_1  = ANIMS.trapped_bldg:new {Image = "units/mission/Meridia_trapped_1.png"}
	ANIMS.Meridia_trapped_1d = ANIMS.trapped_bldgd:new{Image = "units/mission/Meridia_trapped_1d.png"}

	modApi:appendAsset("img/units/mission/Meridia_trapped_2.png",  mod.resourcePath.."img/units/mission/Meridia_trapped_2.png")
	modApi:appendAsset("img/units/mission/Meridia_trapped_2d.png", mod.resourcePath.."img/units/mission/Meridia_trapped_2d.png")
	ANIMS.Meridia_trapped_2  = ANIMS.trapped_bldg:new {Image = "units/mission/Meridia_trapped_2.png"}
	ANIMS.Meridia_trapped_2d = ANIMS.trapped_bldgd:new{Image = "units/mission/Meridia_trapped_2d.png"}

	--Nautilus_island_id
	modApi:appendAsset("img/units/mission/Nautilus_island_id_trapped_1.png",  mod.resourcePath.."img/units/mission/Nautilus_island_id_trapped_1.png")
	modApi:appendAsset("img/units/mission/Nautilus_island_id_trapped_1d.png", mod.resourcePath.."img/units/mission/Nautilus_island_id_trapped_1d.png")
	ANIMS.Nautilus_island_id_trapped_1  = ANIMS.trapped_bldg:new {Image = "units/mission/Nautilus_island_id_trapped_1.png"}
	ANIMS.Nautilus_island_id_trapped_1d = ANIMS.trapped_bldgd:new{Image = "units/mission/Nautilus_island_id_trapped_1d.png"}

	modApi:appendAsset("img/units/mission/Nautilus_island_id_trapped_2.png",  mod.resourcePath.."img/units/mission/Nautilus_island_id_trapped_2.png")
	modApi:appendAsset("img/units/mission/Nautilus_island_id_trapped_2d.png", mod.resourcePath.."img/units/mission/Nautilus_island_id_trapped_2d.png")
	ANIMS.Nautilus_island_id_trapped_2  = ANIMS.trapped_bldg:new {Image = "units/mission/Nautilus_island_id_trapped_2.png"}
	ANIMS.Nautilus_island_id_trapped_2d = ANIMS.trapped_bldgd:new{Image = "units/mission/Nautilus_island_id_trapped_2d.png"}

	--tatu_Candy_Island
	modApi:appendAsset("img/units/mission/tatu_Candy_Island_trapped_1.png",  mod.resourcePath.."img/units/mission/tatu_Candy_Island_trapped_1.png")
	modApi:appendAsset("img/units/mission/tatu_Candy_Island_trapped_1d.png", mod.resourcePath.."img/units/mission/tatu_Candy_Island_trapped_1d.png")
	ANIMS.tatu_Candy_Island_trapped_1  = ANIMS.trapped_bldg:new {Image = "units/mission/tatu_Candy_Island_trapped_1.png"}
	ANIMS.tatu_Candy_Island_trapped_1d = ANIMS.trapped_bldgd:new{Image = "units/mission/tatu_Candy_Island_trapped_1d.png"}

	modApi:appendAsset("img/units/mission/tatu_Candy_Island_trapped_2.png",  mod.resourcePath.."img/units/mission/tatu_Candy_Island_trapped_2.png")
	modApi:appendAsset("img/units/mission/tatu_Candy_Island_trapped_2d.png", mod.resourcePath.."img/units/mission/tatu_Candy_Island_trapped_2d.png")
	ANIMS.tatu_Candy_Island_trapped_2  = ANIMS.trapped_bldg:new {Image = "units/mission/tatu_Candy_Island_trapped_2.png"}
	ANIMS.tatu_Candy_Island_trapped_2d = ANIMS.trapped_bldgd:new{Image = "units/mission/tatu_Candy_Island_trapped_2d.png"}

	--FarLine
	modApi:appendAsset("img/units/mission/FarLine_trapped_1.png",  mod.resourcePath.."img/units/mission/FarLine_trapped_1.png")
	modApi:appendAsset("img/units/mission/FarLine_trapped_1d.png", mod.resourcePath.."img/units/mission/FarLine_trapped_1d.png")
	ANIMS.FarLine_trapped_1  = ANIMS.trapped_bldg:new {Image = "units/mission/FarLine_trapped_1.png"}
	ANIMS.FarLine_trapped_1d = ANIMS.trapped_bldgd:new{Image = "units/mission/FarLine_trapped_1d.png"}

	modApi:appendAsset("img/units/mission/FarLine_trapped_2.png",  mod.resourcePath.."img/units/mission/FarLine_trapped_2.png")
	modApi:appendAsset("img/units/mission/FarLine_trapped_2d.png", mod.resourcePath.."img/units/mission/FarLine_trapped_2d.png")
	ANIMS.FarLine_trapped_2  = ANIMS.trapped_bldg:new {Image = "units/mission/FarLine_trapped_2.png"}
	ANIMS.FarLine_trapped_2d = ANIMS.trapped_bldgd:new{Image = "units/mission/FarLine_trapped_2d.png"}

	--Watchtower
	modApi:appendAsset("img/units/mission/Watchtower_trapped_1.png",  mod.resourcePath.."img/units/mission/Watchtower_trapped_1.png")
	modApi:appendAsset("img/units/mission/Watchtower_trapped_1d.png", mod.resourcePath.."img/units/mission/Watchtower_trapped_1d.png")
	ANIMS.Watchtower_trapped_1  = ANIMS.trapped_bldg:new {Image = "units/mission/Watchtower_trapped_1.png"}
	ANIMS.Watchtower_trapped_1d = ANIMS.trapped_bldgd:new{Image = "units/mission/Watchtower_trapped_1d.png"}

	modApi:appendAsset("img/units/mission/Watchtower_trapped_2.png",  mod.resourcePath.."img/units/mission/Watchtower_trapped_2.png")
	modApi:appendAsset("img/units/mission/Watchtower_trapped_2d.png", mod.resourcePath.."img/units/mission/Watchtower_trapped_2d.png")
	ANIMS.Watchtower_trapped_2  = ANIMS.trapped_bldg:new {Image = "units/mission/Watchtower_trapped_2.png"}
	ANIMS.Watchtower_trapped_2d = ANIMS.trapped_bldgd:new{Image = "units/mission/Watchtower_trapped_2d.png"}

	--Vertex
	modApi:appendAsset("img/units/mission/Vertex_trapped_1.png",  mod.resourcePath.."img/units/mission/Vertex_trapped_1.png")
	modApi:appendAsset("img/units/mission/Vertex_trapped_1d.png", mod.resourcePath.."img/units/mission/Vertex_trapped_1d.png")
	ANIMS.Vertex_trapped_1  = ANIMS.trapped_bldg:new {Image = "units/mission/Vertex_trapped_1.png"}
	ANIMS.Vertex_trapped_1d = ANIMS.trapped_bldgd:new{Image = "units/mission/Vertex_trapped_1d.png"}

	modApi:appendAsset("img/units/mission/Vertex_trapped_2.png",  mod.resourcePath.."img/units/mission/Vertex_trapped_2.png")
	modApi:appendAsset("img/units/mission/Vertex_trapped_2d.png", mod.resourcePath.."img/units/mission/Vertex_trapped_2d.png")
	ANIMS.Vertex_trapped_2  = ANIMS.trapped_bldg:new {Image = "units/mission/Vertex_trapped_2.png"}
	ANIMS.Vertex_trapped_2d = ANIMS.trapped_bldgd:new{Image = "units/mission/Vertex_trapped_2d.png"}
	

	--Weapon is Usually called Skill_Link where Skill is the Skill of the pilot
	-- i.e. NamesSkill_Link
	mod.libs.repairApi:SetRepairSkill{
		Weapon = "TruelchSkillFMW_Link",
		Icon = "img/weapons/repair_truelch.png",
		IsActive = function(pawn)
			return pawn:IsAbility(pilot.Skill)
		end
	}
end


function this:load(options, version)
	modapiext.dialog:addRuledDialog("Truelch_Airstrike_Requested", {Odds = 50,{main = "Truelch_Airstrike_Requested"},})
	modapiext.dialog:addRuledDialog("Truelch_Trap_Requested",      {Odds = 50,{main = "Truelch_Trap_Requested"},})
	modapiext.dialog:addRuledDialog("Truelch_Trap_Incoming",       {Odds = 50,{main = "Truelch_Trap_Incoming"},})
	modapiext.dialog:addRuledDialog("Truelch_Trap_Final_Requested",{Odds = 50,{main = "Truelch_Trap_Final_Requested"},})
	modapiext.dialog:addRuledDialog("Truelch_Trap_Final_Incoming", {Odds = 50,{main = "Truelch_Trap_Final_Incoming"},})
	modapiext.dialog:addRuledDialog("Truelch_PinnacleBot_Launched",{Odds = 50,{main = "Truelch_PinnacleBot_Launched"},})
	modapiext.dialog:addRuledDialog("Truelch_Detritus_Used",       {Odds = 50,{main = "Truelch_Detritus_Used"},})
	modapiext.dialog:addRuledDialog("Truelch_Meridia_Used",        {Odds = 50,{main = "Truelch_Meridia_Used"},})
	modapiext.dialog:addRuledDialog("Truelch_Nautilus_Used",       {Odds = 50,{main = "Truelch_Nautilus_Used"},})
	modapiext.dialog:addRuledDialog("Truelch_Candy_Used",          {Odds = 15,{main = "Truelch_Candy_Used"},})
	modapiext.dialog:addRuledDialog("Truelch_Farline_Used",        {Odds = 50,{main = "Truelch_Farline_Used"},})
	modapiext.dialog:addRuledDialog("Truelch_Watchtower_Used",     {Odds = 50,{main = "Truelch_Watchtower_Used"},})
	modapiext.dialog:addRuledDialog("Truelch_Vertex_OnDeathShards",{Odds = 35,{main = "Truelch_Vertex_OnDeathShards"},})
end

-- add personality.
local personality = personalities:new{ Label = "Truelch" }

-- add dialog to personality.
personality:AddDialog(dialog)

-- add personality to game - notice how the id is the same as pilot.Personality
Personality["truelch_personality"] = personality


-- EVENTS, HOOKS AND STUFF --

local function incrementTruelchMemory()
	--LOG("[TRUELCH] incrementTruelchMemory -> Game:GetCorp().name: "..Game:GetCorp().name)
	if BoardHasAbility() and Game:GetCorp().name ~= "" and Game:GetTeamTurn() == TEAM_PLAYER then
		local islandIndex = easyEdit:getCurrentIslandSlot()
		local islandName = easyEdit.world[islandIndex]["island"]
		if GAME.Potluck_Truelch_Memories[islandName] ~= nil then
			GAME.Potluck_Truelch_Memories[islandName] = GAME.Potluck_Truelch_Memories[islandName] + 1
		else
			GAME.Potluck_Truelch_Memories[islandName] = 1
		end
		--LOG("Memories: "..tostring(GAME.Potluck_Truelch_Memories[islandName]).." of island: "..islandName)
	end
end

local function archiveEffect(p)
	if p == nil then return end

	--Find the correct mech for dialog
	local index = 0 --in the weird case that Truelch doesn't exist, the first pilot will bark
	for id = 0, 2 do --doesn't work with my Hell Breachers passive. I should remove that passive anyway...
		if Board:GetPawn(id):IsAbility(pilot.Skill) then
			index = id
			break
		end
	end

	--Effect
	local effect = SkillEffect()
	effect:AddScript([[
		local cast = { main = ]]..Board:GetPawn(index):GetId()..[[ }
		modapiext.dialog:triggerRuledDialog("Truelch_Airstrike_Incoming", cast)
	]])
	
	effect:AddDelay(0.75)
	effect:AddSound("/props/airstrike")
	effect:AddAirstrike(p,"units/mission/bomber_1.png")
	
	local damage = SpaceDamage(Point(0, 0), DAMAGE_DEATH)
	damage.sAnimation = "ExploArt2"
	damage.sSound = "/props/airstrike_explosion"
	
	local spaces = GetAttackArea(p)
	for i, v in ipairs(spaces) do
		damage.loc = v
		effect:AddDamage(damage)
		effect:AddBounce(v, 6)
	end

	Board:AddEffect(effect)
end

local function rstEffect(p)
	if p == nil then return end

	--Find the correct mech for dialog
	local index = 0 --in the weird case that Truelch doesn't exist, the first pilot will bark
	for id = 0, 2 do --doesn't work with my Hell Breachers passive. I should remove that passive anyway...
		if Board:GetPawn(id):IsAbility(pilot.Skill) then
			index = id
			break
		end
	end

	--Effect
	local effect = SkillEffect()

	local health = Board:GetHealth(p)
	--LOG("[TRUELCH] health: "..tostring(health))

	if health >= 1 then
		--LOG("[TRUELCH] health >= 1")
		effect:AddSound("/support/helicopter/move")

		effect:AddAirstrike(p, "effects/truelch_evac_heli.png")

		if health > 2 then health = 2 end

		local pawnName = getTrappedBuilding(tostring(health))

		effect:AddSound("/impact/generic/grapple")

		effect:AddScript([[
			Board:SetTerrain(]]..p:GetString()..[[, TERRAIN_ROAD)
			Board:AddAlert(]]..p:GetString()..[[, "BUILDING TRAPPED!")

			local pawnName = getTrappedBuilding(]]..tostring(health)..[[)
			if pawnName ~= nil and pawnName ~= "" then
				Board:AddPawn("]]..pawnName..[[", ]]..p:GetString()..[[)
			else
				Board:AddPawn("Trapped_Building", ]]..p:GetString()..[[)
			end
		]])

		--Dialog
		if Game:GetCorp().name == ""  then
			--Final island
			effect:AddScript([[
				local cast = { main = ]]..Board:GetPawn(index):GetId()..[[ }
				modapiext.dialog:triggerRuledDialog("Truelch_Trap_Final_Incoming", cast)
			]])
		else
			--Regular island
			effect:AddScript([[
				local cast = { main = ]]..Board:GetPawn(index):GetId()..[[ }
				modapiext.dialog:triggerRuledDialog("Truelch_Trap_Incoming", cast)
			]])
		end
		Board:AddEffect(effect)
	end
end

local EVENT_NextTurn = function(mission)
	if Game:GetTeamTurn() == TEAM_PLAYER then
		--Copy data (from next turn data to reset turn data)
		--It seems that the stuff below does a copy by reference and not a copy by value...
		--missionData().Potluck_Truelch_Archive_Reset = missionData().Potluck_Truelch_Archive
		--missionData().Potluck_Truelch_RST = missionData().Potluck_Truelch_RST_Reset

		--life is pain... au chocolat
		if missionData().Potluck_Truelch_Archive ~= nil then
			missionData().Potluck_Truelch_Archive_Reset = Point(missionData().Potluck_Truelch_Archive.x, missionData().Potluck_Truelch_Archive.y)
		--else
		--	LOG("[TRUELCH] Bug prevented for Archive point!")
		end

		if missionData().Potluck_Truelch_RST ~= nil then			
			missionData().Potluck_Truelch_RST_Reset = Point(missionData().Potluck_Truelch_RST.x, missionData().Potluck_Truelch_RST.y)
		--else
		--	LOG("[TRUELCH] Bug prevented for RST point!")
		end

		--Compute
		archiveEffect(missionData().Potluck_Truelch_Archive)
		rstEffect(missionData().Potluck_Truelch_RST)

		--Clear data
		missionData().Potluck_Truelch_Archive = nil
		missionData().Potluck_Truelch_RST = nil

		if missionData().Potluck_Truelch_Vertex == true then
			missionData().Potluck_Truelch_Vertex = nil --or false?
		end
	else
		--Clear reset data
		missionData().Potluck_Truelch_Archive_Reset = nil
		missionData().Potluck_Truelch_RST_Reset = nil
	end
end

local EVENT_ResetTurn = function(mission)
	--I think I should do that too?
	if missionData().Potluck_Truelch_Vertex == true then
		missionData().Potluck_Truelch_Vertex = nil --or false?
	end

	--Compute
	modApi:scheduleHook(550, function()
		archiveEffect(missionData().Potluck_Truelch_Archive_Reset)
		rstEffect(missionData().Potluck_Truelch_RST_Reset)
	end)
end

--Should I increase memories at mission start or end?
local function EVENT_MissionEnd(mission)
	incrementTruelchMemory()
end

local function EVENT_GameStart()
	--Initialize memories
	GAME.Potluck_Truelch_Memories = {}

	--I still need to do that for the set use
	GAME.Potluck_Truelch_Memories["archive"] = 0
	GAME.Potluck_Truelch_Memories["rst"] = 0
	GAME.Potluck_Truelch_Memories["pinnacle"] = 0
	GAME.Potluck_Truelch_Memories["detritus"] = 0

	GAME.Potluck_Truelch_Memories["Meridia"] = 0
	GAME.Potluck_Truelch_Memories["Nautilus_island_id"] = 0
	GAME.Potluck_Truelch_Memories["tatu_Candy_Island"] = 0

	GAME.Potluck_Truelch_Memories["FarLine"] = 0
	GAME.Potluck_Truelch_Memories["Watchtower"] = 0
	GAME.Potluck_Truelch_Memories["Vertex"] = 0
end

local HOOK_onMissionUpdate = function(mission)
    if not isMission() then return end

	if missionData().Potluck_Truelch_Archive ~= nil then
		local active = false --TODO, but I'm lazy

		local point = missionData().Potluck_Truelch_Archive
		Board:MarkSpaceImage(point, "combat/tile_icon/tile_airstrike.png", GL_Color(255,226,88,0.75))
		Board:MarkSpaceDesc(point, "air_strike", EFFECT_DEADLY)
		if active then
			Board:MarkSpaceImage(point, "combat/tile_icon/tile_airstrike.png", GL_Color(255,150,150,0.75))
		end

		for dir = DIR_START, DIR_END do
			local curr = point + DIR_VECTORS[dir]
			Board:MarkSpaceImage(curr, "combat/tile_icon/tile_airstrike.png", GL_Color(255,226,88,0.75))
			Board:MarkSpaceDesc(curr, "air_strike", EFFECT_DEADLY)
			if active then
				Board:MarkSpaceImage(curr, "combat/tile_icon/tile_airstrike.png", GL_Color(255,150,150,0.75))
			end
		end
	end
end

local function EVENT_onModsLoaded()
	modApi:addMissionUpdateHook(HOOK_onMissionUpdate)
end

local EVENT_pawnKilled = function(mission, pawn)
	
	if not isMission() or missionData().Potluck_Truelch_Vertex ~= true then return end

	--LOG("[TRUELCH] "..pawn:GetMechName().." was killed!")
	local effect = SkillEffect()
	local p1 = pawn:GetSpace()
	--LOG("p1: "..p1:GetString())

	effect:AddSound("/props/freezing") --test, I hope it won't get too loud!

	for dir = DIR_START, DIR_END do
		local p2 = p1 + DIR_VECTORS[dir]
		--LOG("p2: "..p2:GetString())
		if Board:IsValid(p2) then
			local projEnd = GetProjectileEnd(p1, p2)
			--LOG("projEnd: "..projEnd:GetString())
			if not Board:IsBuilding(projEnd) then

				local tgtPawn = Board:GetPawn(projEnd)

				if tgtPawn ~= nil and not tgtPawn:IsEnemy() then
					local damage = SpaceDamage(projEnd, -1)
					effect:AddProjectile(p1, damage, "effects/truelch_shot_shard", NO_DELAY)
				else
					local damage = SpaceDamage(projEnd, 1)
					effect:AddProjectile(p1, damage, "effects/truelch_shot_shard", NO_DELAY)
					--This causes addSkillStartHook to trigger and some assume that pawn exist, while it does not
					--Which causes some errors in the console (though harmless)
				end
			end
		end
	end
	Board:AddAlert(p1, "CRYSTAL SHARDS")
	Board:AddEffect(effect)
end

modapiext.events.onPawnKilled:subscribe(EVENT_pawnKilled)
modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)
modapiext.events.onResetTurn:subscribe(EVENT_ResetTurn) --Without it, reseting a turn will "undo" traps. (I guess also airstrikes?)
modApi.events.onNextTurn:subscribe(EVENT_NextTurn) --to apply effects (air strike, buildings' traps...)
modApi.events.onMissionEnd:subscribe(EVENT_MissionEnd) --to increase stacks
modApi.events.onPostStartGame:subscribe(EVENT_GameStart) --initialize stacks in the Game Data

return this