local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
local repairApi = mod.libs.repairApi
--local pawnMove = mod.libs.pawnMove
--local moveSkill = mod.libs.moveSkill
--local taunt = mod.libs.taunt
--local boardEvents = mod.libs.boardEvents
local path2 = mod_loader.mods[modApi.currentMod].resourcePath
local personalities = require(path2 .."scripts/libs/personality")
local dialog = require(path2 .."scripts/pilots/dialog_metalocif")

local pilot = {
	Id = "Pilot_Metalocif",
	Personality = "metalocif_personality",
	Name = "Metalocif",
	Sex = SEX_MALE, --or other sex
	Skill = "MetalocifSkill",
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

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	pilotSkill_tooltip.Add(pilot.Skill, PilotSkill("Enfeeble", "When repairing, also weakens adjacent enemies."))

	--Skill
	--Art and icons can go here

	--Weapon is Usually called Skill_Link where Skill is the Skill of the pilot
	-- i.e. NamesSkill_Link
	repairApi:SetRepairSkill{
		Weapon = "MetalocifSkill_Link",
		Icon = "img/weapons/repair_metalocif.png",
		IsActive = function(pawn)
			return pawn:IsAbility(pilot.Skill)
		end
	}

	--Put Weapon Definition Here
	MetalocifSkill_Link = Skill:new {
		Name = "Enfeeble",
		Description = "Surrounding enemies permanently deal N less damage, where N is 1 + this pilot's level.",
		TipImage = {
			Unit = Point(2,3),
			Enemy = Point(2,2),
			Enemy2 = Point(3,3),
		}
	}

	function MetalocifSkill_Link:GetTargetArea(point)
		local ret = PointList()
		ret:push_back(point)
		return ret
	end

	function MetalocifSkill_Link:GetSkillEffect(p1,p2)
		local ret = SkillEffect()

		--Remove if fully replacing repair
		local damage = SpaceDamage(p1, -1)
		damage.iFire = EFFECT_REMOVE
		damage.iAcid = EFFECT_REMOVE
		ret:AddDamage(damage)

		local weakenAmount = 1
		if GetCurrentMission() ~= nil then DoSaveGame() end
		
		if GameData ~= nil and GameData.current["pilot"..Board:GetPawn(p1):GetId()] ~= nil then 
			weakenAmount = weakenAmount + GameData.current["pilot"..Board:GetPawn(p1):GetId()].level
		end
		for i = DIR_START, DIR_END do
			local curr = p1 + DIR_VECTORS[i]
			local pawn = Board:GetPawn(curr)
			if pawn and pawn:GetTeam() == TEAM_ENEMY and pawn:GetWeaponCount() > 0 then
				ret:AddScript(string.format("Status.ApplyWeaken(%s, %s)", pawn:GetId(), weakenAmount))
			end
		
		end

		return ret
	end
end

--[[  Skill Specfic Dialog and hooks
function this:load(modApiExt, options)
	modApiExt.dialog:addRuledDialog("Name", {
		Odds = 5,
		{ main = "Name" },
	})
end
--]]
-- add personality.
local personality = personalities:new{ Label = "Metalocif" }

-- add dialog to personality.
personality:AddDialog(dialog)

-- add personality to game - notice how the id is the same as pilot.Personality
Personality["metalocif_personality"] = personality


return this
