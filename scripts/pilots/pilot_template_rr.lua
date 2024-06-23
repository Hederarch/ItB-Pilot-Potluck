local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
local repairApi = mod.libs.repairApi
--local pawnMove = self.libs.pawmMove
--local moveSkill = self.libs.moveSkill
--local taunt = mod.libs.taunt

local pilot = {
	Id = "",
	Personality = "",
	Name = "",
	Sex = SEX_MALE, --or other sex
	Skill = "",
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
	pilotSkill_tooltip.Add(pilot.Skill, PilotSkill("Name", "Description"))

	--Skill
	--Art and icons can go here

	--Weapon is Usually called Skill_Link where Skill is the Skill of the pilot
	-- i.e. NamesSkill_Link
	repairApi:SetRepairSkill{
		Weapon = "Skill_Link",
		Icon = "img/weapons/repair_template.png",
		IsActive = function(pawn)
			return pawn:IsAbility(pilot.Skill)
		end
	}

	--Put Weapon Defintion Here
	Skill_Link = Skill:new {
		Name = "",
		Description = "",
		TipImage = {
			Unit = Point(2,3),
		}
	}

	function SmartSkill_Link:GetTargetArea(point)
		local ret = PointList()
		ret:push_back(point)

		--Put Target Area Here

		return ret
	end

	function SmartSkill_Link:GetSkillEffect(p1,p2)
		local ret = SkillEffect()

		--Remove if fully replacing repair
		local damage = SpaceDamage(p1, -1)
		damage.iFire = EFFECT_REMOVE
		damage.iAcid = EFFECT_REMOVE
		ret:AddDamage(damage)

		--Put Skill Effect Here

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
return this
