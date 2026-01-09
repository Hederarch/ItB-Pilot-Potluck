local this = {}
local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local aFMWF = atlas_FiringModeWeaponFramework

local api = require(path.."fmw/api")
local Ui2 = require(path .."fmw/libs/ui/Ui2")
local cover = require(path.."fmw/libs/ui/cover2")
local clip = require(path .."fmw/libs/clip")
local atlaslib = require(path.."fmw/libs/ATLASlib")
local tlen = atlaslib.hashLen

local img_modeswitch_icon = sdlext.surface(path.."fmw/icon_mode_switch.png")
local img_hotkey_holder = sdlext.surface(path.."fmw/icon_hotkey_holder.png")

local font_hk = sdlext.font("fonts/JustinFont12.ttf", 11)
local font_limited = sdlext.font("fonts/JustinFont12Bold.ttf", 11)
local limited_textset = deco.textset(deco.colors.white, sdl.rgb(7, 10, 18), 1)

local modeSelectHotkeys = {[1] = 49, [2] = 50, [3] = 51, [4] = 52, [5] = 53, [6] = 54, [7] = 55, [8] = 56, [9] = 57, [10] = 48}
local modeButtonHotkeys = {[101] = "E", [102] = "F", [99]  = "C", [116] = "T", [-1]  = nil}

this.modeBtns = {}
this.modeSwitchButton = nil
this.modeSwitchPanel = nil

local function modeSelectionHKChar(p, weapon)
	local hk = aFMWF.hkRegistry[api:GetSkillId(p, weapon)]

	return modeButtonHotkeys[hk]
end

local function createHotkeyUi(parent, x, y, hk)
	if not hk then return end

	parent.hk = Ui2()
		:widthpx(18):heightpx(18)
		:decorate({
			DecoFrame(),
			DecoAlign(1, 0), DecoCAlignedText(hk, font_hk)
		})
		:addTo(parent)

	parent.hk.draw = function(uiself, screen)
		uiself:pospx(x, y)

		Ui2.draw(uiself, screen)
	end
end

local function getPos(p)
	local weapons = Board:GetPawn(p):GetPoweredWeaponTypes()
	local xOffset = 140 * (tlen(weapons) - 1)

	return Location['mech_box'].x + (330 + xOffset), Location['mech_box'].y - 90
end

function this:closeModePanel()
	if this.modeSwitchPanel then
		for _, btn in pairs(this.modeBtns) do
			btn.hk:detach(); btn:detach()
		end

		if this.modeSwitchPanel.hk then
			this.modeSwitchPanel.hk:detach()
		end

		this.modeSwitchPanel:detach()
		this.modeSwitchPanel = nil
		this.modeBtns = {}
	end
end

function this:openModePanel()
	local root = sdlext.getUiRoot()
	local weapon, _, owner = api:GetActiveSkill()

	local ownerSpace = owner:GetSpace()

	local width = (50 * #weapon.aFM_ModeList) + 20

	Game:TriggerSound("/ui/general/button_confirm")

	this.modeSwitchPanel = Ui2()
		:widthpx(width):heightpx(80)
		:decorate({ DecoFrame() })
		:addTo(root)

		cover {
			align = {x = -5, y = -5},
			size = {w = width, h = 80}
		}:addTo(this.modeSwitchPanel)

		createHotkeyUi(this.modeSwitchPanel, width - 20, 59, modeSelectionHKChar(ownerSpace, weapon))

	this.modeSwitchPanel.draw = function(uiself, screen)
		local x, y = getPos(ownerSpace)
		uiself:pospx(x, y)

		if uiself.hk then
			uiself.hk:pospx(width - 20, 59)
		end

		clip(Ui2, uiself, screen)
	end

	for i, mode in ipairs(weapon.aFM_ModeList) do
		local tt = string.format("%s\n\n%s", _G[mode].aFM_name, _G[mode].aFM_desc)
		local icon = sdlext.surface(_G[mode].aFM_icon)

		local modeBtn = Ui2()
			:widthpx(36):heightpx(60)
			:decorate({
				DecoButton(),
				DecoAlign(-8, -2), DecoSurface(icon),
				DecoAlign(-23, -15), DecoCAlignedText('', font_limited),
			})
			:settooltip(tt)
			:addTo(this.modeSwitchPanel)

			createHotkeyUi(modeBtn, 11, 35, i)

		modeBtn.id = mode
		modeBtn.mdisabled = false
		modeBtn.hotkey = modeSelectHotkeys[i] or nil

		modeBtn.draw = function(uiself, screen)
			uiself:pospx(10 + 50 * (i - 1), 8)

			Ui2.draw(uiself, screen)
		end

		modeBtn.clicked = function(uiself, button)
			if button == 1 and not uiself.mdisabled then
				if mode ~= weapon:FM_GetMode(ownerSpace) then
					weapon:FM_OnModeSwitch(ownerSpace)
				end

				weapon:FM_SetMode(ownerSpace, mode)
				this.closeModePanel()
			elseif button == 1 then
				Game:TriggerSound("/ui/general/button_invalid")
			end
		end

		local buttonColour = deco.colors.button
		local borderColour = deco.colors.buttonborder
		local limited = weapon:FM_GetUses(ownerSpace, mode)

		if _G[mode].aFM_limited then
			modeBtn.decorations[5] = DecoCAlignedText(limited, font_limited, limited_textset)
		end

		if limited == 0 then
			modeBtn.mdisabled = true
			buttonColour = deco.colors.buttondisabled
			borderColour = deco.colors.buttonborderdisabled
		end

		if mode == weapon:FM_GetMode(ownerSpace) then
			borderColour = deco.colors.buttonborderhl
		end

		modeBtn.decorations[1] = DecoButton(buttonColour, borderColour)

		table.insert(this.modeBtns, modeBtn)
	end
end

function this:closeModeSwitchButton()
	if this.modeSwitchButton then
		this.modeSwitchButton:detach()

		if this.modeSwitchButton.hk then
			this.modeSwitchButton.hk:detach()
		end

		this.modeSwitchButton = nil
	end
end

function this:openModeSwitchButton()
	local root = sdlext.getUiRoot()
	local weapon, _, owner = api:GetActiveSkill()

	local ownerSpace = owner:GetSpace()
	local currentMode = weapon:FM_GetMode(ownerSpace)

	local tt = string.format("%s\n\n%s", weapon.aFM_ModeSwitchDesc, _G[currentMode].aFM_desc)
	local icon = sdlext.surface(_G[currentMode].aFM_icon)

	local limited = weapon:FM_GetUses(ownerSpace, currentMode)
	local hk = modeSelectionHKChar(ownerSpace, weapon)

	this.modeSwitchButton = Ui2()
		:widthpx(44):heightpx(80)
		:decorate({
			DecoButton(sdl.rgb(34, 34, 42)),
			DecoAlign(-4, 0), DecoSurface(img_modeswitch_icon),
			DecoAlign(-36, -13), DecoSurface(icon),
			DecoAlign(-23, -13), DecoCAlignedText('', font_limited)
		})
		:addTo(root)

		cover {
			align = {x = -5, y = -5},
			size = {w = 44, h = 80}
		}:addTo(this.modeSwitchButton)

		createHotkeyUi(this.modeSwitchButton, 19, 55, hk)

		this.modeSwitchButton:settooltip(tt)

	if limited == 0 or weapon:FM_IsModeSwitchDisabled(ownerSpace) then
		this.modeSwitchButton.decorations[1] = DecoButton(deco.colors.buttondisabled, deco.colors.buttonborderdisabled)
	end

	if _G[currentMode].aFM_limited then
		this.modeSwitchButton.decorations[7] = DecoCAlignedText(limited, font_limited, limited_textset)
	else
		this.modeSwitchButton.decorations[7] = DecoCAlignedText('', font_limited)
	end

	this.modeSwitchButton.draw = function(uiself, screen)
		local weapon, _, owner = api:GetActiveSkill()

		if weapon then
			local ownerSpace = owner:GetSpace()

			local x, y = getPos(ownerSpace)
			uiself:pospx(x, y)
		end

		clip(Ui2, uiself, screen)
	end

	this.modeSwitchButton.clicked = function(uiself, button)
		local weapon, _, owner = api:GetActiveSkill()
		local ownerSpace = owner:GetSpace()

		if button == 1 and not Board:IsBusy() then
			if not weapon:FM_IsModeSwitchDisabled(ownerSpace) then
				this.openModePanel()
			else
				Game:TriggerSound("/ui/general/button_invalid")
			end
		end
	end
end

return this
