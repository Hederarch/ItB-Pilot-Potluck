local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
local repairApi = mod.libs.repairApi
--local pawnMove = self.libs.pawmMove
--local moveSkill = self.libs.moveSkill
--local taunt = mod.libs.taunt
--local boardEvents = mod.libs.boardEvents

local pilot = {
	Id = "Pilot_Nico",
	Personality = "NicoGeneric",
	Name = "Nico",
	Sex = SEX_MALE, --or other sex
	Skill = "NicoRemote",
	Voice = "/voice/archimedes", --or other voice
}

--[[
Helper function to see if it's the tip image
--]]
local function IsTipImage()
	return Board:GetSize() == Point(6,6)
end

--[[
Helper function to see if the board currently has this pilots ability
--]]
local function BoardHasAbility()
	for id = 0, 2 do
		if Board:GetPawn(id):IsAbility(pilot.Skill) then
			return true
		end
	end
end

--[[
Helper function to get unoccupied spaces
--]]
function getUnoccupiedSpaces(count, point, size)
	local choices = {}
	local point = point or Point(0,0)
	local size = size or Board:GetSize()
	for i = point.x, point.x + size.x - 1 do
		for j = point.y, point.x + size.y - 1  do
			if not Board:IsBlocked(Point(i,j),PATH_GROUND) then
				choices[#choices+1] = Point(i,j)
			end
		end
	end

	local ret = {}
	while count > 0 and #choices > 0 do
		ret[#ret] = random_removal(choices)
		count = count - 1
	end

	return ret
end


function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	pilotSkill_tooltip.Add(pilot.Skill, PilotSkill("Nico's Remote", "Deploy a bot for each mission, and heal an ally when repairing."))

	modApi:appendAsset("img/weapons/pilot_nico_repair.png", mod.resourcePath.."img/weapons/pilot_nico_repair.png")
	modApi:appendAsset("img/effects/nicobot_dropper.png", mod.resourcePath .."img/effects/nicobot_dropper.png")
	modApi:appendAsset("img/units/mission/nicobot.png", mod.resourcePath .."img/units/nicobot.png")
	modApi:appendAsset("img/units/mission/nicobot_a.png", mod.resourcePath .."img/units/nicobot_a.png")

	ANIMS.BaseUnit = Animation:new { Image = "units/player/mech_punch_1.png", PosX = -19, PosY = -4, Loop = true, Time = 0.3 }
	ANIMS.nicobot = ANIMS.BaseUnit:new{ Image = "units/mission/nicobot.png", PosX = -18, PosY = -9 }
	ANIMS.nicobota = ANIMS.nicobot:new{ Image = "units/mission/nicobot_a.png", NumFrames = 4 }

	ANIMS.Radio_Burst = Animation:new{
		Image = "combat/icons/radio_animate.png",
		PosX = -16, PosY = -8,
		NumFrames = 3,
		Time = 0.25,
		Loop = false
	}

	--Skill
	--Art and icons can go here

	--Weapon is Usually called Skill_Link where Skill is the Skill of the pilot
	-- i.e. NamesSkill_Link
	repairApi:SetRepairSkill{
		Weapon = "NicoRemote_Link",
		Icon = "img/weapons/pilot_nico_repair.png",
		IsActive = function(pawn)
			return pawn:IsAbility(pilot.Skill)
		end
	}

	--Put Weapon Defintion Here
	NicoRemote_Link = Skill:new {
		Name = "Nico's Remote",
		Description = "Heals an ally anywhere on the board.",
		TipImage = {
			Unit = Point(1,2),
			Friendly = Point(4,2),
			Target = Point(4,2)
		}
	}

	function NicoRemote_Link:GetTargetArea(point)
		local ret = PointList()

		local board_size = Board:GetSize()
		for i = 0, board_size.x - 1 do
			for j = 0, board_size.y - 1  do
				local p = Point(i,j)
				if Board:IsPawnSpace(p) and p ~= point and Board:IsPawnTeam(p,TEAM_PLAYER) then
					ret:push_back(p)
				end
			end
		end

		return ret
	end

	function NicoRemote_Link:GetSkillEffect(p1,p2)
		local ret = SkillEffect()

		local vfx = SpaceDamage(p1,0)
		vfx.sAnimation = "Radio_Burst"
		ret:AddDamage(vfx)

		local damage = SpaceDamage(p2, -1)
		damage.iFire = EFFECT_REMOVE
		damage.iAcid = EFFECT_REMOVE
		ret:AddDamage(damage)


		return ret
	end


	Deploy_NicoBot = Pawn:new{
	Name = "Nico-Bot",
	Health = 1,
	Image = "nicobot",
	MoveSpeed = 4,
	DefaultTeam = TEAM_PLAYER,
	SkillList = {"Ranged_ScatterShot"},
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/mech/brute/tank",
	Corpse = false,
	}
	AddPawn("Deploy_NicoBot")


end

-- Pawns -------------------------------------------------------------------------------------------------------------------------------------------------



-- Hooks -------------------------------------------------------------------------------------------------------------------------------------------------
local function GetUser()
	for i = 0,2 do
		local mech = Board:GetPawn(i)
		if mech then
			if mech:IsAbility(pilot.Skill) then
				return Board:GetPawn(i)
			end
		end
	end
	return nil
end

local function PawnKilled(mission, pawn)
  if pawn:GetType() == "Deploy_NicoBot" then
    Board:AddAnimation(pawn:GetSpace(),"ExploAir2",ANIM_DELAY)
  end
end

local function DeployNicobot(p1)
	LOG("DEPLOYING! PHASE 3")
	local ret = SkillEffect()

	local targets = extract_table(general_DiamondTarget(p1, 3))
	LOG("DEPLOYING! PHASE 3.5!")
    local i = 1
        while Board:IsBlocked(targets[i], PATH_GROUND) do
            i = i + 1
        end
    local deploy = SpaceDamage(targets[i],0)
	--if target == nil then return ret end
	LOG("DEPLOYING! PHASE 4")
    local deploy = SpaceDamage(targets[i],0)
	LOG("DEPLOYING! PHASE 5")
	ret:AddDelay(0.4)
	deploy.sPawn = "Deploy_NicoBot"
	deploy.sAnimation = "ExploAir2"
	ret:AddDropper(deploy,"effects/nicobot_dropper.png")
	LOG("DEPLOYING! PHASE 6")
	return ret
end

local function DelayEffect()
modApi:conditionalHook(
	function()
		if BoardHasAbility() then
			return Board:GetTurn() == 1
		end
		return false
	end,
	function()
		LOG("DEPLOYING! PHASE 2")
		Board:AddEffect(DeployNicobot(GetUser():GetSpace()))
	end
)
end

local HOOK_onMissionStarted = function(mission)
	if BoardHasAbility() then
		LOG("DEPLOYING! PHASE 1")
		DelayEffect()
	end
end


local function EVENT_onModsLoaded()
  modApi:addMissionStartHook(function(mission) HOOK_onMissionStarted(mission) end)
end


modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

--[[  Skill Specfic Dialog and hooks
function this:load(modApiExt, options)
	modApiExt.dialog:addRuledDialog("Name", {
		Odds = 5,
		{ main = "Name" },
	})
end
--]]
return this
