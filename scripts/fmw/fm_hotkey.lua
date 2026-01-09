local this = {}
local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local options
local aFMWF = atlas_FiringModeWeaponFramework

local api = require(path.."fmw/api")
local hotkey = require(path.."fmw/libs/hotkey")
local fm_ui = require(path .. "fmw/fm_ui")

function aFM_WeaponTemplate:FM_RegisterHK(p)
	local id = api:GetSkillId(p, self)

	aFMWF.hkRegistry[id] = options["fmw_mode_hotkey"].value
end

function this:getOptions()
	options = mod_loader.currentModContent[mod.id].options
end

function this:load()
	options = mod_loader.currentModContent[mod.id].options
	sdlext.addPreKeyDownHook(function(keycode)
		local weapon, weaponIdx, owner = api:GetActiveSkill()

		if weapon then
			local ownerSpace = owner:GetSpace()
			local hk = aFMWF.hkRegistry[api:GetSkillId(ownerSpace, weapon)]

			if hk ~= -1 then
				if keycode == hk and not weapon:FM_IsModeSwitchDisabled(ownerSpace) then
					if not fm_ui.modeSwitchPanel and not Board:IsBusy() then
						fm_ui:openModePanel()
					else
						fm_ui:closeModePanel()
					end

					return true
				elseif keycode == hk then
					Game:TriggerSound("/ui/general/button_invalid")
				end
			end

			if fm_ui.modeSwitchPanel then
				-- prevent weapon selection while panel is open
				for i = 1, 2 do
					if keycode == hotkey.keys[hotkey['WEAPON'..i]] then
						hotkey:suppress(hotkey['WEAPON'..i])
					end
				end

				if keycode == hotkey.keys[hotkey['REPAIR']] and not aFMWF.repair.aFM_ModeList[1] then
					hotkey:suppress(hotkey['REPAIR'])
				end

				for i, modeBtn in ipairs(fm_ui.modeBtns) do
					if keycode == modeBtn.hotkey and not modeBtn.mdisabled then
						if modeBtn.id ~= weapon:FM_GetMode(ownerSpace) then
							weapon:FM_OnModeSwitch(ownerSpace)
						end

						weapon:FM_SetMode(ownerSpace, modeBtn.id)
						fm_ui:closeModePanel()
					elseif keycode == modeBtn.hotkey then
						Game:TriggerSound("/ui/general/button_invalid")
					end
				end
			end
		end

		return false
	end)
end

return this
