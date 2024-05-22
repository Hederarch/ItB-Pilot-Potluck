local descriptiontext = "HEDERA/TODO"

local mod = {
	id = "PilotPotluck",
	name = "Pilot Potluck",
	version = "0.0.0", --BETA
	dependencies = {
		modApiExt = "1.22",
	--	memedit = "",
	--	easyEdit = "",
	},
	icon = "ItBPP.png",
	description = descriptiontext,
}

local function getModOptions(mod)
    return mod_loader:getModConfig()[mod.id].options
end

local function getOption(options, name, defaultVal)
	if options and options[name] then
		return options[name].enabled
	end
	if defaultVal then return defaultVal end
	return true
end

local pilotnames = {
	--["Pilot_Names"] = "Names",
}

function mod:metadata()
	--[[
	modApi:addGenerationOption(
		"enable_pilot_traits", "Use Trait Icons",
		"Adds trait icons for some pilot abilities. May conflict with other mods that use custom trait icons.",
		{enabled = true}
	)
	--]]
	for id, name in pairs(pilotnames) do
		modApi:addGenerationOption(
			"enable_" .. string.lower(id), "Pilot: "..name,
			"Enable this pilot.",
			{enabled = true}
		)
    end
end

function mod:init()
	self.libs = {}
	self.libs.repairApi = require(self.scriptPath.. "replaceRepair/api")
	self.libs.repairApi:init(self, modapiext)

	--libs need to be added to folders if used
	--dialogs = require(self.scriptPath .."libs/dialogs")
	--require(self.scriptPath.."addTraits")

	modApi:appendAssets("img/portraits/pilots/","img/portraits/pilots/")

	local options = getModOptions(mod)
	for id, name in pairs(pilotnames) do
		if getOption(options, "enable_"..string.lower(id)) then
			self[id] = require(self.scriptPath .. string.lower(id))
			self[id]:init(self)
		end
	end
end

function mod:load(options,version)
	self.libs.repairApi:load(self, options, version)
	--dialogs.load(modapiext)
end

return mod
