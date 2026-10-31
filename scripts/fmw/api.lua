---- FIRING MODE WEAPON FRAMEWORK V8.4.1  ----
----    MUST BE INITIALIZED & LOADED    ----
---- MODAPIEXT IS A REQUIRED DEPENDENCY ---- 

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local atlaslib = require(path.."fmw/libs/ATLASlib")

local this = {}
local aFMWF = atlas_FiringModeWeaponFramework

aFM_WeaponTemplate = Skill:new{
	Name = "FM Weapon Template",
	Description = "",
	Class = "Any",
	aFM_ModeList = {},
	aFM_ModeSwitchDesc = ""
}

-- returns whether or not a pawn has an FM skill
-- p: pawn space or id
function this:HasSkill(p)
	if Board and Board:GetPawn(p) then
        local ret = false; 
    
		if Board:GetPawn(p):GetArmedWeaponId() == 50 and aFMWF.repair.aFM_ModeList[1] then
			return true
		end

		if Board:GetPawn(p):GetArmedWeaponId() == 0 and aFMWF.move.aFM_ModeList[1] then
			return true
		end

		local weapons = Board:GetPawn(p):GetPoweredWeaponTypes()
        
		for _, weapon in pairs(weapons) do
            if _G[weapon] and _G[weapon].aFM_ModeList then
                ret = true
            end
		end
	end

	return ret
end

-- checks if the skill at the specified index is an FM skill and returns its object
-- p: pawn space or id
-- weaponIdx: skill index (1, 2, 50 [repair], 0 [move])
function this:GetSkill(p, weaponIdx, onlyId)
	if Board and Board:GetPawn(p) then
		if weaponIdx == 50 and aFMWF.repair.aFM_ModeList[1] then
			return onlyId and "Skill_Repair" or aFMWF.repair
		elseif weaponIdx == 0 and aFMWF.move.aFM_ModeList[1] then
			return onlyId and "Move" or aFMWF.move
		end

		weapon = Board:GetPawn(p):GetPoweredWeaponTypes()[weaponIdx]

		if _G[weapon] and _G[weapon].aFM_ModeList then
			return onlyId and weapon or _G[weapon]
		end
	end

	return nil
end

-- checks if the skill at the specified index or object is an FM skill and returns its id
-- p: pawn space or id
-- weapon: skill index (1, 2, 50 [repair], 0 [move]) or skill object (table)
function this:GetSkillId(p, weapon)
	if type(weapon) == "table" then
		weaponIdx = this:GetSkillIdx(p, weapon)
	else
		weaponIdx = weapon
	end

	return this:GetSkill(p, weaponIdx, true)
end

-- checks if a pawn has the specified FM skill and returns its index
-- p: pawn space or id
-- weapon: skill object
function this:GetSkillIdx(p, weapon)
	for _, i in pairs({1, 2, 50, 0}) do
		if this:GetSkillId(p, i) == "Skill_Repair" then
			return 50
		elseif this:GetSkillId(p, i) == "Move" then
			return 0
		end

		if this:GetSkill(p, i) == weapon then
			return i
		end
	end
end

-- checks for powered FM passives
-- returns skill object, skill index, and owner (pawn object)
function this:GetActivePassive()
	if Board then
		for i, p in pairs(extract_table(Board:GetPawns(TEAM_MECH))) do
			for passiveIdx = 1, 2 do
				local p = Board:GetPawn(p)
				local passive = this:GetSkill(p:GetSpace(), passiveIdx)

				if passive and passive.Passive ~= "" then
					return passive, passiveIdx, p
				end
			end
		end
	end

	return nil
end

-- checks for armed FM weapons
-- returns skill object, skill index, and owner (pawn object)
function this:GetActiveWeapon()
	local Pawn = atlaslib:Pawn()

	if Pawn then
		local pSpace = Pawn:GetSpace()
		local armedId = Pawn:GetArmedWeaponId()

		if armedId == 50 and aFMWF.repair.aFM_ModeList[1] then
			return aFMWF.repair, armedId, Board:GetPawn(pSpace)
		elseif armedId == 0 and aFMWF.move.aFM_ModeList[1] then
			return aFMWF.move, armedId, Board:GetPawn(pSpace)
		end

		local weapon = this:GetSkill(pSpace, armedId)

		if weapon then
			return weapon, armedId, Board:GetPawn(pSpace)
		end
	end

	return nil
end

-- checks for armed FM weapons first, then FM passives
-- returns skill object, skill index, and owner (pawn object)
function this:GetActiveSkill()
	if this:GetActiveWeapon() then
		return this:GetActiveWeapon()
	else
		return this:GetActivePassive()
	end

	return nil
end

-- call this in the GetTargetArea function of your FM repair skill
-- modeList: table containing mode id's (strings)
-- modeSwitchDesc: description of mode switch button
function this:RegisterRepair(p, modeList, modeSwitchDesc)
    local m = GetCurrentMission();
    local pId = Board:GetPawn(p):GetId();
    
    if ( m.atlas_FMW.Curr[pId][50] == nil ) then            
        m.atlas_FMW.Curr[pId][50] = modeList[1];
        m.atlas_FMW.Limited[pId][50] = {};
        
        for j = 1, #modeList do
            local mode = modeList[j];
            m.atlas_FMW.Limited[pId][50][mode] = _G[mode].aFM_limited or -1;
        end
    end

    aFMWF.repair.aFM_ModeList = modeList
    aFMWF.repair.aFM_ModeSwitchDesc = modeSwitchDesc
end

-- call this in the GetTargetArea function of your FM move skill
-- modeList: table containing mode id's (strings)
-- modeSwitchDesc: description of mode switch button
function this:RegisterMove(modeList, modeSwitchDesc)
	aFMWF.move.aFM_ModeList = modeList
	aFMWF.move.aFM_ModeSwitchDesc = modeSwitchDesc
end

-- called whenever the current mode is switched out for a different mode
-- p: pawn space
function aFM_WeaponTemplate:FM_OnModeSwitch(p)
	-- do stuff
end

-- returns id (string) of current mode
-- p: pawn space or id
function aFM_WeaponTemplate:FM_GetMode(p)
	local m = GetCurrentMission()

	local pId = Board:GetPawn(p):GetId()

	-- check if this is being called from a tip image
	if not m or not modapiext.pawn:getSavedataTable(pId) then
		return self.aFM_ModeList[1]
	end

	local weaponIdx = this:GetSkillIdx(p, self)
    
	return m.atlas_FMW.Curr[pId][weaponIdx]
end

-- sets current mode to specified mode
-- p: pawn space or id
-- mode: mode id (string)
function aFM_WeaponTemplate:FM_SetMode(p, mode)
	local m = GetCurrentMission()
	local pId = Board:GetPawn(p):GetId()
	local weaponIdx = this:GetSkillIdx(p, self)

	Game:TriggerSound("/ui/general/button_confirm")
	m.atlas_FMW.Curr[pId][weaponIdx] = mode

	if self.Passive == "" then
		-- selecting a new mode while the weapon has a target highlighted will not update the weapon
		-- forcing the weapon to fire on a point not in its GetTargetArea will
		Board:GetPawn(p):FireWeapon(Point(400, 400), weaponIdx)
	end
end

-- checks if mode switch button is disabled
-- p: pawn space or id
function aFM_WeaponTemplate:FM_IsModeSwitchDisabled(p)
	local m = GetCurrentMission()
	local pId = Board:GetPawn(p):GetId()
	local weaponIdx = this:GetSkillIdx(p, self)

	return m.atlas_FMW.Disabled[pId][weaponIdx]
end

-- disables/enables (true, false) mode switch button
-- p: pawn space or id
-- b: boolean
function aFM_WeaponTemplate:FM_SetModeSwitchDisabled(p, b)
	local m = GetCurrentMission()
	local pId = Board:GetPawn(p):GetId()
	local weaponIdx = this:GetSkillIdx(p, self)

	m.atlas_FMW.Disabled[pId][weaponIdx] = b
end

-- enables mode switch button
-- p: pawn space or id
function aFM_WeaponTemplate:FM_EnableModeSwitch(p)
	self:FM_SetModeSwitchDisabled(p, false)
end

-- disables mode switch button
-- p: pawn space or id
function aFM_WeaponTemplate:FM_DisableModeSwitch(p)
	self:FM_SetModeSwitchDisabled(p, true)
end

-- returns # of uses specified mode has left
-- p: pawn space or id
-- mode: mode id (string)
function aFM_WeaponTemplate:FM_GetUses(p, mode)
	local m = GetCurrentMission()
	local pId = Board:GetPawn(p):GetId()

	if not m or not modapiext.pawn:getSavedataTable(pId) then
		return -1
	end

	local weaponIdx = this:GetSkillIdx(p, self)

	return m.atlas_FMW.Limited[pId][weaponIdx][mode]
end

-- sets # of uses of specified mode to 'i'
-- p: pawn space or id
-- mode: mode id (string)
function aFM_WeaponTemplate:FM_SetUses(p, mode, i)
	local m = GetCurrentMission()
	local weaponIdx = this:GetSkillIdx(p, self)
	local pId = Board:GetPawn(p):GetId()

	if not m or not modapiext.pawn:getSavedataTable(pId) then
		return
	end

	m.atlas_FMW.Limited[pId][weaponIdx][mode] = i
end

-- adds # of uses of specified mode by 'i'
-- p: pawn space or id
-- mode: mode id (string)
function aFM_WeaponTemplate:FM_AddUses(p, mode, i)
	local limited = self:FM_GetUses(p, mode) + i

	self:FM_SetUses(p, mode, limited)
end

-- subtracts # of uses of specified mode by 'i'
-- p: pawn space or id
-- mode: mode id (string)
function aFM_WeaponTemplate:FM_SubUses(p, mode, i)
	self:FM_AddUses(p, mode, -i)
end

-- identical to self:FM_SetUses(p, mode, 0)
-- p: pawn space or id
-- mode: mode id (string)
function aFM_WeaponTemplate:FM_DisableMode(p, mode)
	self:FM_SetUses(p, mode, 0)
end

-- identical to self:FM_SetUses(p, mode, -1)
-- p: pawn space or id
-- mode: mode id (string)
function aFM_WeaponTemplate:FM_EnableMode(p, mode)
	self:FM_SetUses(p, mode, -1)
end

-- checks if the specified mode is disabled
-- p: pawn space or id
-- mode: mode id (string)
function aFM_WeaponTemplate:FM_ModeDisabled(p, mode)
	return self:FM_GetUses(p, mode) == 0
end

-- checks if the current mode is not nil and not disabled
-- p: pawn space or id
function aFM_WeaponTemplate:FM_CurrentModeReady(p)
	local currentMode = self:FM_GetMode(p)

	return currentMode and self:FM_GetUses(p, currentMode) ~= 0
end

return this
