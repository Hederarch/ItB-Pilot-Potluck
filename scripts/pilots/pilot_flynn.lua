local this = {}
local currentGrid = -1

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
--local repairApi = mod.libs.repairApi
--local pawnMove = self.libs.pawmMove
--local moveSkill = self.libs.moveSkill
--local taunt = mod.libs.taunt
--local boardEvents = mod.libs.boardEvents

local path2 = mod_loader.mods[modApi.currentMod].resourcePath
local personalities = require(path2 .."scripts/libs/personality")
local dialog = require(path2 .."scripts/pilots/dialog_flynn")
--I just made a new path variable because the other one wasn't formatted the same way as mine. It worked. Fuck it, it's too late in the evening for this shit, it works, I'm turning it in.
--Thank you Hedera for putting up with the duct tape

local pilot = {
	Id = "Pilot_Flynn",					-- id must be unique. Used to link to art assets.
	Personality = "flynn_personality",	-- must match the id for a personality you have added to the game.
	Name = "Flynn",
	Rarity = 1,
	Voice = "/voice/ralph",					-- audio. look in pilots.lua for more alternatives.
	Skill = "flynn_ability",				-- pilot's ability - Must add a tooltip for new skills.
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
		if Board:GetPawn(id) and Board:GetPawn(id):IsAbility(pilot.Skill) then
			return true
		end
	end
end

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	pilotSkill_tooltip.Add("flynn_ability", PilotSkill("Gambler's Facts", "Increases Grid Defense upon Grid loss."))

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
local flynn_hook = function(mission)
	if (BoardHasAbility()) then
		if (currentGrid == -1) then
			currentGrid = Game:GetPower():GetValue()
		end
		if (Game:GetPower():GetValue() < currentGrid) then
			LOG("Grid Defense should be increasing here.")
			LOG(Game:SetResist(Game:GetResist() + 3))
		end
		currentGrid = Game:GetPower():GetValue()
	end
end
-- Use BoardHasAbility to check if your pilot is on the Board
-- Or search all mech pawns to find the pawn with your skill
-- But DON'T apply effects to the board uncondtionally

local function EVENT_onModsLoaded()
	modApi:addMissionUpdateHook(flynn_hook)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

-- add personality.
local personality = personalities:new{ Label = "Flynn" }

-- add dialog to personality.
personality:AddDialog(dialog)

-- add personality to game - notice how the id is the same as pilot.Personality
Personality["flynn_personality"] = personality

return this
