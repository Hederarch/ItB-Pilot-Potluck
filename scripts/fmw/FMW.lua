---- todo
-----> ui code looks meh
-----> fix ui for when player has fm movement and fm passive

atlas_FiringModeWeaponFramework = atlas_FiringModeWeaponFramework or {vers, hkRegistry = {}, repair = {}, move = {}}
local aFMWF = atlas_FiringModeWeaponFramework

local this = {vers = "8.4.1"}
local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local resources = mod.resourcePath

local api = require(path.."fmw/api")
local hotkey = require(path.."fmw/libs/hotkey")
local fm_hotkey = require(path.."fmw/fm_hotkey")
local fm_ui = require(path .. "fmw/fm_ui")
local atlaslib = require(path.."fmw/libs/ATLASlib")

local configTitle = mod.FMW_hotkeyConfigTitle or "Mode Selection Hotkey"
local configDesc = mod.FMW_hotkeyConfigDesc or "Hotkey used to open and close firing mode selection."

aFMWF.repair = aFM_WeaponTemplate:new{
	aFM_ModeList = nil,
	aFM_ModeSwitchDesc = nil
}

aFMWF.move = aFM_WeaponTemplate:new{
	aFM_ModeList = nil,
	aFM_ModeSwitchDesc = nil
}

local function initializeFMStates(m)
	for _, p in pairs(extract_table(Board:GetPawns(TEAM_MECH))) do
		local p = Board:GetPawn(p)
		local pId = p:GetId()

		if api:HasSkill(pId) then
			m.atlas_FMW.Curr[pId] = {}
		    m.atlas_FMW.Limited[pId] = {{}, {}}
		    m.atlas_FMW.Disabled[pId] = {false, false, [50] = false, [0] = false}

		    for i = 1, 2 do
		        local weapon = api:GetSkill(pId, i)
                
				if weapon then
					weapon:FM_RegisterHK(pId)
					m.atlas_FMW.Curr[pId][i] = weapon.aFM_ModeList[1]

					for j = 1, #weapon.aFM_ModeList do
						local mode = weapon.aFM_ModeList[j]
						m.atlas_FMW.Limited[pId][i][mode] = _G[mode].aFM_limited or -1
					end
				end
			end
		end
	end
end

function this:init()
	if not aFMWF.vers or modApi:isVersion(aFMWF.vers, this.vers) then
		aFMWF.vers = this.vers
	end

	modApi:appendAsset("img/icon_mode_switch.png", path.."fmw/icon_mode_switch.png")
	modApi:appendAsset("img/icon_hotkey_holder.png", path.."fmw/icon_hotkey_holder.png")

	modApi:addGenerationOption(
		"fmw_mode_hotkey",
		configTitle,
		configDesc,
		{
			strings = {"E", "F", "C", "T", "Disabled"},
			values = {101, 102, 99, 116, -1},
			value = 101
		}
	)
end

function this:load()
	require(path .. "fmw/libs/menu"):load()

	fm_hotkey:getOptions()

	modApi:addModsLoadedHook(function()
		atlas_FMW_Loaded = false
	end)

	if not atlas_FMW_Loaded and modApi:isVersion(aFMWF.vers, this.vers) then
		fm_hotkey:load()

		modApi:addMissionNextPhaseCreatedHook(function(prevM, nextM)
			nextM.atlas_FMW = {Curr = {}, Limited = {}, Disabled = {}}
			fm_ui:closeModePanel()
			fm_ui:closeModeSwitchButton()
            modApi:runLater(function() initializeFMStates(nextM) end)
		end)

		modApi:addMissionStartHook(function(m)
			m.atlas_FMW = {Curr = {}, Limited = {}, Disabled = {}}
			modApi:runLater(function() initializeFMStates(m) end)
		end)

		modApi:addTestMechEnteredHook(function(m)
			m.atlas_FMW = {Curr = {}, Limited = {}, Disabled = {}}
			modApi:runLater(function() initializeFMStates(m) end)
		end)

		modApi:addTestMechExitedHook(function(m)
			fm_ui:closeModeSwitchButton()
			fm_ui:closeModePanel()
		end)

		modApi.events.onMainMenuEntered:subscribe(function(screen, wasHangar, wasGame)
			fm_ui:closeModeSwitchButton()
			fm_ui:closeModePanel()
		end)

		modApi:addMissionUpdateHook(function(m)
			local Pawn = atlaslib:Pawn()
			local weapon, _, owner = api:GetActiveSkill()
			local visible = weapon and owner:IsSelected() and owner:IsActive() and not fm_ui.modeSwitchPanel

			if not Pawn or Pawn:GetArmedWeaponId() ~= 50 and aFMWF.repair.aFM_ModeList[1] then
				fm_ui:closeModePanel()
				aFMWF.repair.aFM_ModeList = nil
				aFMWF.repair.aFM_ModeSwitchDesc = nil
			end

			if not Pawn or Pawn:GetArmedWeaponId() ~= 0 and aFMWF.move.aFM_ModeList[1] then
				fm_ui:closeModePanel()
				aFMWF.move.aFM_ModeList = nil
				aFMWF.move.aFM_ModeSwitchDesc = nil
			end

			if not weapon then
				fm_ui:closeModePanel()
			end

			if visible and not fm_ui.modeSwitchButton then
				fm_ui:openModeSwitchButton()
			end

			if not visible and fm_ui.modeSwitchButton then
				fm_ui:closeModeSwitchButton()
			end

			if not fm_ui.modeSwitchPanel then
				hotkey:unsuppress(hotkey.WEAPON1)
				hotkey:unsuppress(hotkey.WEAPON2)
				hotkey:unsuppress(hotkey.REPAIR)
			end
		end)

		modapiext:addSkillStartHook(function(m, pawn, weapon, p1, p2)
			if type(weapon) == 'table' then
    			weapon = weapon.__Id
			end

			local wpn = _G[weapon]

			if weapon == "Skill_Repair" then wpn = aFMWF.repair end
			if weapon == "Move"         then wpn = aFMWF.move end

			if wpn.aFM_ModeList and wpn.aFM_ModeList[1] then
				local mode = wpn:FM_GetMode(p1)

				if _G[mode].aFM_handleLimited == nil or _G[mode].aFM_handleLimited and wpn:FM_GetUses(p1, mode) > 0 then
					wpn:FM_SubUses(p1, mode, 1)
				end
			end
		end)

		atlas_FMW_Loaded = true
	end
end

return this
