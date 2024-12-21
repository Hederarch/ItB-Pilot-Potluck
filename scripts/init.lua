local descriptiontext = "A commemorative pilot pack celebrating the many modders of Into the Breach"
local pilot_init = "pilots/init"


local mod = {
	id = "PilotPotluck",
	name = "Pilot Potluck",
	version = "1.0.0",
	dependencies = {
		modApiExt = "1.22",
	  memedit = "1.1.5",
	--	easyEdit = "",
	},
	icon = "ItBPP.png",
	description = descriptiontext,
}

function mod:metadata()
	--[[
	modApi:addGenerationOption(
		"enable_pilot_traits", "Use Trait Icons",
		"Adds trait icons for some pilot abilities. May conflict with other mods that use custom trait icons.",
		{enabled = true}
	)
	--]]

	require(self.scriptPath..pilot_init):metadata()
end

function mod:init()
	self.libs = {}

	self.libs.pilotSkill_tooltip = require(mod.scriptPath .."libs/pilotSkill_tooltip")

	self.libs.repairApi = require(self.scriptPath.. "replaceRepair/api")
	self.libs.repairApi:init(self, modapiext)

	self.libs.pawmMove = require(self.scriptPath .."libs/pawnMoveSkill")
	self.libs.moveSkill = require(self.scriptPath .."libs/pilotSkill_move")

	self.libs.boardEvents = require(self.scriptPath.."libs/boardEvents")
	self.libs.taunt = require(self.scriptPath.."taunt/taunt")
	
	self.libs.status = require(self.scriptPath.."libs/status")

	--libs need to be added to folders if used
	--dialogs = require(self.scriptPath .."libs/dialogs")
	--require(self.scriptPath.."addTraits")

	require(self.scriptPath..pilot_init):init()
end

function mod:load(options,version)
	self.libs.repairApi:load(self, options, version)
	--require(self.scriptPath..pilot_init):load()
	--dialogs.load(modapiext)
end

return mod
