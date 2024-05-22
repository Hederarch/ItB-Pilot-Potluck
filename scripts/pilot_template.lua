local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
--local pawnMove = require(path .."libs/pawnMoveSkill")
--local moveskill = require(path .."libs/pilotSkill_move")
--local repairApi = mod.libs.repairApi

local pilot = {
	Id = "",
	Personality = "",
	Name = "",
	Sex = SEX_MALE, --SEX_FEMALE
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
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Name", "Description"))

	--Skill

end

--[[  Skill Specfic Dialog and hooks
function this:load(modApiExt, options)
	modApiExt.dialog:addRuledDialog("Name", {
		Odds = 5,
		{ main = "Name" },
	})
end
--]]

local function EVENT_onModsLoaded()

end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

return this
