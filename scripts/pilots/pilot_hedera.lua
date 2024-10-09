local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod_loader.mods[modApi.currentMod].resourcePath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
--local repairApi = mod.libs.repairApi
--local pawnMove = self.libs.pawmMove
--local moveSkill = self.libs.moveSkill
--local taunt = mod.libs.taunt
local boardEvents = mod.libs.boardEvents

local pilot = {
	Id = "Pilot_Hedera",
	Personality = "HexAuthor",
	Name = "Hedera",
	Sex = SEX_MALE, --or other sex
	Skill = "HederaSkill",
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

--[[
Helper function to get random unoccupied spaces
--]]
local function getUnoccupiedSpaces(count, point, size) -- copied from weapons_base.lua's getUnoccupiedSpaces
	local choices = {}
	point = point or Point(0,0)
	size = size or Board:GetSize()
	for i = point.x, point.x + size.x - 1 do
		for j = point.y, point.x + size.y - 1  do
			if not Board:IsBlocked(Point(i,j),PATH_GROUND) then
				choices[#choices+1] = Point(i,j)
			end
		end
	end

	local ret = {}
	while count > 0 and #choices > 0 do
		ret[#ret + 1] = random_removal(choices) -- this line is broken in the original, indexes to zero with ret[#ret]
		count = count - 1
	end

	return ret
end

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	pilotSkill_tooltip.Add(pilot.Skill, PilotSkill("Hotfix", "Creates collectible balance patches during every mission."))

	--Skill: A lot of the skill will probably just be hooks, which goes down below
	--But art and icons can go here
	modApi:appendAsset("img/combat/hedera_patch_action.png", path .."img/combat/hedera_patch_action.png")
	Location["combat/hedera_patch_action.png"] = Point(-14,-4)
	modApi:appendAsset("img/combat/hedera_patch_boost.png", path .."img/combat/hedera_patch_boost.png")
	Location["combat/hedera_patch_boost.png"] = Point(-14,-4)
	modApi:appendAsset("img/combat/hedera_patch_bubble.png", path .."img/combat/hedera_patch_bubble.png")
	Location["combat/hedera_patch_bubble.png"] = Point(-14,-4)
	modApi:appendAsset("img/combat/hedera_patch_heart.png", path .."img/combat/hedera_patch_heart.png")
	Location["combat/hedera_patch_heart.png"] = Point(-14,-4)
	modApi:appendAsset("img/combat/hedera_patch_move.png", path .."img/combat/hedera_patch_move.png")
	Location["combat/hedera_patch_move.png"] = Point(-14,-4)
end

--[[  Skill Specfic Dialog and hooks
function this:load(modApiExt, options)
	modApiExt.dialog:addRuledDialog("Name", {
		Odds = 5,
		{ main = "Name" },
	})
end
--]]

--mines here
MINE_TYPES = {"Hedera_HealJuice","Hedera_MoveJuice","Hedera_BoostJuice","Hedera_ShieldJuice","Hedera_RefreshJuice"}

TILE_TOOLTIPS = {
	Hedera_HealJuice = {"Sweet Patch", "Increases max Health by 1 when collected."},
	Hedera_MoveJuice = {"Sour Patch", "Increases movement speed by 1 when collected."},
	Hedera_BoostJuice = {"Bitter Patch", "Grants Boost when collected."},
	Hedera_ShieldJuice = {"Umami Patch", "Grants a Shield when collected."},
	Hedera_RefreshJuice = {"Salty Patch", "If collected by a Mech, restores its movement."},
}

local juice_get = SpaceDamage(0)
juice_get.sSound = "Science_KO_Crack_OnKill" -- REPLACE ME
juice_get.sAnimation = "ExploRepulseSmall"
Hedera_HealJuice = { Image = "combat/hedera_patch_heart.png", Damage = juice_get, Tooltip = "Hedera_HealJuice", Icon = "combat/icons/icon_doubleshot_glow.png", UsedImage = ""}
Hedera_MoveJuice = { Image = "combat/hedera_patch_move.png", Damage = juice_get, Tooltip = "Hedera_MoveJuice", Icon = "combat/icons/icon_doubleshot_glow.png", UsedImage = ""}
Hedera_BoostJuice = { Image = "combat/hedera_patch_boost.png", Damage = juice_get, Tooltip = "Hedera_BoostJuice", Icon = "combat/icons/icon_doubleshot_glow.png", UsedImage = ""}
Hedera_ShieldJuice = { Image = "combat/hedera_patch_bubble.png", Damage = juice_get, Tooltip = "Hedera_ShieldJuice", Icon = "combat/icons/icon_doubleshot_glow.png", UsedImage = ""}
Hedera_RefreshJuice = { Image = "combat/hedera_patch_action.png", Damage = juice_get, Tooltip = "Hedera_RefreshJuice", Icon = "combat/icons/icon_doubleshot_glow.png", UsedImage = ""}

local HOOK_nextTurn = function()
	GetCurrentMission().Potluck_SpedUpThisTurn = {}
  local effect = SkillEffect()
  if Game:GetTeamTurn() == TEAM_ENEMY then
    for id = 0, 2 do
      if Board:GetPawn(id):IsAbility(pilot.Skill) then
        local space = Board:GetPawn(id):GetSpace() -- do the skill below here
		math.randomseed(os.time())
        selectedPoints = getUnoccupiedSpaces(math.random(4,8))
		for k, v in pairs(selectedPoints) do
			if Board:GetItem(v) == "" then
				local deploy = SpaceDamage(v,0)
				deploy.sAnimation = "ExploRepulse3"
				deploy.sItem = MINE_TYPES[math.random(#MINE_TYPES)]
				effect:AddDropper(deploy,"effects/shotup_grid.png")
				effect:AddDelay(0.2)
			end
		end
      end
    end
  end
  Board:AddEffect(effect)
end

boardEvents.onItemRemoved:subscribe(function(loc, removed_item)
    if removed_item == "Hedera_HealJuice" then
        local pawn = Board:GetPawn(loc)
        if pawn then
            local mine_damage = SpaceDamage(loc)
            mine_damage.sScript = "local target = Board:GetPawn("..loc:GetString()..") target:SetMaxHealth(target:GetMaxHealth() + 1) target:SetHealth(target:GetHealth() + 1) Board:AddBurst("..loc:GetString()..",\"Emitter_Burst_Heal\",DIR_NONE)"
            Board:DamageSpace(mine_damage)
        end
    elseif removed_item == "Hedera_MoveJuice" then
        local pawn = Board:GetPawn(loc)
        if pawn then
            local mine_damage = SpaceDamage(loc)
            mine_damage.sScript = "local target = Board:GetPawn("..loc:GetString()..") target:SetMoveSpeed(target:GetMoveSpeed() + 1)"
            Board:DamageSpace(mine_damage)
			GetCurrentMission().Potluck_SpedUpThisTurn[pawn:GetId() + 1] = true
        end
    elseif removed_item == "Hedera_BoostJuice" then
        local pawn = Board:GetPawn(loc)
        if pawn then
            local mine_damage = SpaceDamage(loc)
            mine_damage.sScript = "local target = Board:GetPawn("..loc:GetString()..") target:SetBoosted(true)"
            Board:DamageSpace(mine_damage)
        end
	elseif removed_item == "Hedera_ShieldJuice" then
        local pawn = Board:GetPawn(loc)
        if pawn then
            local mine_damage = SpaceDamage(loc)
            mine_damage.sScript = "local target = Board:GetPawn("..loc:GetString()..") target:SetShield(true)"
            Board:DamageSpace(mine_damage)
        end
	elseif removed_item == "Hedera_RefreshJuice" then
        local pawn = Board:GetPawn(loc)
        if pawn then
            local mine_damage = SpaceDamage(loc)
            mine_damage.sScript = "local target = Board:GetPawn("..loc:GetString()..") target:SetMovementSpent(false)"
            Board:DamageSpace(mine_damage)
        end
    end
end)

local UndoMoveCleanUp = function(mission, pawn, undonePosition)
	if mission.Potluck_SpedUpThisTurn[pawn:GetId() + 1] ~= nil then -- id + 1 since lua arrays are not 0 indexed (it is stupid)
		mission.Potluck_SpedUpThisTurn[pawn:GetId() + 1] = nil
		pawn:SetMoveSpeed(pawn:GetMoveSpeed() - 1)
	end
end

local MissionPrep = function(mission) -- initialize cleanup table
	mission.Potluck_SpedUpThisTurn = {}
end

local MissionCleanUp = function(mission) -- manually reset stats that the game won't
	for id = 0, 2 do
      Game:GetPawn(id):SetMoveSpeed(_G[Game:GetPawn(id):GetType()].MoveSpeed)
    end
end

local function EVENT_onModsLoaded()
  modApi:addNextTurnHook(HOOK_nextTurn)
  modApi:addMissionStartHook(function(mission) MissionPrep(mission) end)
  modApi:addMissionEndHook(function(mission) MissionCleanUp(mission) end)
  modapiext:addPawnUndoMoveHook(UndoMoveCleanUp)
end




modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

return this
