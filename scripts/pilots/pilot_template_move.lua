local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
--local repairApi = mod.libs.repairApi
local pawnMove = self.libs.pawmMove
local moveSkill = self.libs.moveSkill
--local taunt = mod.libs.taunt
--local boardEvents = mod.libs.boardEvents

local pilot = {
	Id = "",
	Personality = "",
	Name = "",
	Sex = SEX_MALE, --or other sex
	Skill = "",
	Voice = "/voice/archimedes", --or other voice
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	pilotSkill_tooltip.Add(pilot.Skill, PilotSkill("Name", "Description"))

	--Art and icons can go here

	--Move Skill
	--The skill name is usally named Move_Skill, where Move is replaced with the pilots name
	Move_Skill = {}
	moveskill.AddTargetArea(pilot.Personality, MoveSkill)
	moveskill.AddSkillEffect(pilot.Personality, MoveSkill)

	function MoveSkill:GetTargetArea(point)
		local ret = pawnMove.GetTargetArea(point)

		--If your move skill has aditional targets, put it here
		--Just like you would for a weapon skill

		return ret
	end

	function MoveSkill:GetSkillEffect(p1,p2)
		local mission = GetCurrentMission()
		if not mission then return end

		--If your move skill has additional effects, put it here
		--Just like you would for a weapon skill

		return pawnMove.GetSkillEffect(p1, p2)

		--[[
		-- Potentially helpful code to check if the move is within
		-- the normal move range

		local path = pawnMove.GetTargetArea(p1)
		if list_contains(extract_table(path), p2) then
			return pawnMove.GetSkillEffect(p1, p2)
		end

		]]
	end
end


--[[  Skill Specfic Dialog: Hooks also go here
function this:load(modApiExt, options)
	modApiExt.dialog:addRuledDialog("Pilot_Skill_AZ", {
		Odds = 5,
		{ main = "Pilot_Skill_AZ" },
	})
end
--]]
return this
