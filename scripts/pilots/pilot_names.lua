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
	Name = "Names",
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
	pilotSkill_tooltip.Add(pilot.Skill, PilotSkill("Alluring Gaze", "Taunts all adjacent enemies at the start of your turn."))

	--Skill

end

local HOOK_nextTurn = function()
  local effect = SkillEffect()
  if Game:GetTeamTurn() == TEAM_PLAYER then
    for id = 0, 2 do
      if Board:GetPawn(id):IsAbility(pilot.Skill) then
        local space = Board:GetPawn(id):GetSpace()
        for i = DIR_START, DIR_END do
          --Taunt every point, taunt lib will manage the conditionals
          local point = space + DIR_VECTORS[i]
          taunt.addTauntEffectSpace(effect, point, space)
        end
        --damage = SpaceDamage(Board:GetPawn(id):GetSpace(),0)
        --Custom Animation???
        --effect:AddDamage(damage)
      end
    end
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
  modApi:addNextTurnHook(HOOK_nextTurn)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

return this
