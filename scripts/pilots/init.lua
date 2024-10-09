local this = {}
local mod = mod_loader.mods[modApi.currentMod]
local scriptPath = mod.scriptPath
local pilotPath = scriptPath.."pilots/"

local pilotnames = {
	["Pilot_Names"] = "________",
	--["Pilot_Hedera"] = "Hedera",
  ["Pilot_Djinn"] = "Djinn"
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


function this:init()
  modApi:appendAssets("img/portraits/pilots/","img/portraits/pilots/")
  modApi:appendAssets("img/weapons/","img/weapons/")

	local options = getModOptions(mod)
	for id, name in pairs(pilotnames) do
		if getOption(options, "enable_"..string.lower(id)) then
			self[id] = require(pilotPath .. string.lower(id))
			self[id]:init(mod)
		end
	end
end

function this:metadata()
  for id, name in pairs(pilotnames) do
		modApi:addGenerationOption(
			"enable_" .. string.lower(id), "Pilot: "..name,
			"Enable this pilot.",
			{enabled = true}
		)
    end
end

return this
