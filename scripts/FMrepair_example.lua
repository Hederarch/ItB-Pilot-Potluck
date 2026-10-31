local this = {}
local path = mod_loader.mods[modApi.currentMod].scriptPath
local resources = mod_loader.mods[modApi.currentMod].resourcePath

modApi:appendAsset("img/icon_repair_self.png", resources.."img/icon_repair_self.png")
modApi:appendAsset("img/icon_repair_allies.png", resources.."img/icon_repair_allies.png")

local fmw = require(path.."fmw/api") 

atlas_RepairMode_Self = {
	aFM_name = "Repair Self", 										 -- required
	aFM_desc = "Repair 1 damage and remove Fire, Ice, and A.C.I.D.", -- required
	aFM_icon = "img/icon_repair_self.png",							 -- required (if you don't have an image an empty string will work) 
	-- aFM_limited = 2, 								 			 -- optional (FMW will automatically handle uses for repair skills)
	-- aFM_handleLimited = false 									 -- optional (FMW will no longer automatically handle uses for this mode if set) 
	target = "self" 
}

atlas_RepairMode_Allies = {
	aFM_name = "Repair Allies",
	aFM_desc = "Repair an allied unit for 1 damage. Does not remove Fire, Ice, or A.C.I.D.", 
	aFM_icon = "img/icon_repair_allies.png",
	aFM_limited = 2,
	target = "allies"
}

atlas_NewRepair = aFM_WeaponTemplate:new{
	Name = "Variable Repair",
	Description = "Either repair self or allies.",
}

function atlas_NewRepair:GetTargetArea(point)
	local pl = PointList()

	--LOG("atlas_NewRepair:GetTargetArea(point)")
	
	-- required
	fmw:RegisterRepair(point, --oh we were missing this
		{"atlas_RepairMode_Self", "atlas_RepairMode_Allies"}, -- mode list 
		"Click to change Repair target." 					  -- mode switch button description
	)

	--LOG("[TRUELCH] A")
	
	local currentMode = self:FM_GetMode(point)

	--LOG("[TRUELCH] B")

	LOG("currentMode: "..tostring(currentMode))

	--LOG("[TRUELCH] C")

	if self:FM_CurrentModeReady(point) then
		if _G[currentMode].target == "self" then
			--LOG("[TRUELCH] self")
			pl:push_back(point)
		elseif _G[currentMode].target == "allies" then
			--LOG("[TRUELCH] allies")
			for _, v in pairs(extract_table(Board:GetPawns(TEAM_PLAYER))) do

				--v is a point, not a pawn
				--[[
				if v ~= nil then
					LOG("v: "..v:GetString())
				else
					LOG("v is nil!")
				end
				]]

				--LOG("HERE")
				if v ~= Board:GetPawn(point):GetId() then
					--LOG("BEFORE")
					pl:push_back(Board:GetPawnSpace(v))
					--LOG("AFTER")
				end
				--LOG("END")
			end
		end
	end

	return pl 
end

function atlas_NewRepair:GetSkillEffect(p1, p2) 
	local se = SkillEffect()
	
	local damage = SpaceDamage(p2, -1)
	damage.iFire = EFFECT_REMOVE
	damage.iAcid = EFFECT_REMOVE
	damage.iFrozen = EFFECT_REMOVE
	
	se:AddDamage(damage)
	Game:TriggerSound("/ui/map/mech_repair")
	
	return se 
end

return this  