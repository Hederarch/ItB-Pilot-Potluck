local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
--local repairApi = mod.libs.repairApi
--local pawnMove = self.libs.pawmMove
--local moveSkill = self.libs.moveSkill
local taunt = mod.libs.taunt

local pilot = {
	Id = "Pilot_Names",
	Personality = "Names",
	Name = "________",
	Sex = SEX_MALE, --SEX_FEMALE
	Skill = "NamesSkill",
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
	pilotSkill_tooltip.Add(pilot.Skill, PilotSkill("Alluring Gaze", "Weapons ________ uses taunt adjacent enemies after use."))

	--Skill

end

local HOOK_skillEnd = function(mission, pawn, weaponId, p1, p2)
  local effect = SkillEffect()
  if pawn:IsAbility(pilot.Skill) and weaponId ~= "Move" then
    local space = pawn:GetSpace()
    for i = DIR_START, DIR_END do
      --Taunt every point, taunt lib will manage the conditionals
      local point = space + DIR_VECTORS[i]
      taunt.addTauntEffectSpace(effect, point, space)
    end
    --damage = SpaceDamage(Board:GetPawn(id):GetSpace(),0)
    --Custom Animation???
    --effect:AddDamage(damage)
  end
  Board:AddEffect(effect)
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
  modapiext:addSkillEndHook(HOOK_skillEnd)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

return this
