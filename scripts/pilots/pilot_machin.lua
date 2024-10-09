local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
--local repairApi = mod.libs.repairApi
--local pawnMove = self.libs.pawmMove
--local moveSkill = self.libs.moveSkill
--local taunt = mod.libs.taunt

local pilot = {
	Id = "Pilot_Machin",
	Personality = "Machin",
	Name = "Machin",
	Sex = SEX_MALE, --or other sex
	Skill = "MachinSkill",
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
	pilotSkill_tooltip.Add(pilot.Skill, PilotSkill("Flytrap's Roots", "Mech gains Boost each turn, but loses Boost after moving."))

	--Skill: A lot of the skill will probably just be hooks, which goes down below
	--But art and icons can go here

end

--[[  Skill Specfic Dialog and hooks
function this:load(modApiExt, options)
	modApiExt.dialog:addRuledDialog("Name", {
		Odds = 5,
		{ main = "Name" },
	})
end
--]]

-- Place hook functions here
-- Use BoardHasAbility to check if your pilot is on the Board
-- Or search all mech pawns to find the pawn with your skill
-- But DON'T apply effects to the board uncondtionally
local function HOOK_nextTurn(mission)
	if mission and Game:GetTeamTurn() == TEAM_PLAYER then
		for id = 0, 2 do
			local pawn = Board:GetPawn(id)
			if pawn:IsAbility(pilot.Skill) then
				pawn:SetBoosted(true)
			end
		end
	end
end

local function HOOK_skillEnd(mission, pawn, weaponId, p1, p2)
	if pawn and pawn:IsAbility(pilot.Skill) and weaponId == "Move" then
		pawn:SetBoosted(false)
	end
end

local function EVENT_onModsLoaded()
	modApi:addNextTurnHook(HOOK_nextTurn)
	modapiext:addSkillEndHook(HOOK_skillEnd)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

return this
