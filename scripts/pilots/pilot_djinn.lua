local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
local repairApi = mod.libs.repairApi
--local pawnMove = self.libs.pawmMove
--local moveSkill = self.libs.moveSkill
--local taunt = mod.libs.taunt

local pilot = {
	Id = "Pilot_Djinn",
	Personality = "Djinn",
	Name = "Djinn",
	Sex = SEX_MALE, --or other sex
	Skill = "Skill_Djinn",
	Voice = "/voice/kwan", --or other voice
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
	pilotSkill_tooltip.Add(pilot.Skill, PilotSkill("Djinn's Desires", "Provides three useful(?) wishes per game. Use repair to activate it."))

	--Skill
	--Art and icons can go here
	modApi:appendAsset("img/combat/icons/icon_gridup_glow.png", mod.resourcePath.."img/combat/icons/icon_gridup_glow.png")
		Location["combat/icons/icon_gridup_glow.png"] = Point(-15,5)

	modApi:appendAsset("img/combat/icons/icon_grapple_no.png", mod.resourcePath.."img/combat/icons/icon_grapple_no.png")
		Location["combat/icons/icon_grapple_no.png"] = Point(-13,5)

	modApi:appendAsset("img/combat/icons/icon_timedown.png", mod.resourcePath.."img/combat/icons/icon_timedown.png")
		Location["combat/icons/icon_timedown.png"] = Point(-15,3)

	modApi:appendAsset("img/effects/djinn_dropper.png", mod.resourcePath.."img/effects/djinn_dropper.png")
		Location["effects/djinn_dropper.png"] = Point(-27,2)

	--Weapon is Usually called Skill_Link where Skill is the Skill of the pilot
	-- i.e. NamesSkill_Link
	repairApi:addSkill{
		weapon = "DjinnSkill_Link",
		Icon = "img/weapons/repair_djinn_3.png",
		IsActive = function(pawn)
			if not GAME then return false end
			local mission = GAME.GetMission and GetCurrentMission()
			if not mission then return false end
			return pawn:IsAbility(pilot.Skill) and GAME.Potluck_Djinn_Wishes == 3
		end
	}

	repairApi:addSkill{
		weapon = "DjinnSkill_Link",
		Icon = "img/weapons/repair_djinn_2.png",
		IsActive = function(pawn)
			if not GAME then return false end
			local mission = GAME.GetMission and GetCurrentMission()
			if not mission then return false end
			return pawn:IsAbility(pilot.Skill) and GAME.Potluck_Djinn_Wishes == 2
		end
	}

	repairApi:addSkill{
		weapon = "DjinnSkill_Link",
		Icon = "img/weapons/repair_djinn_1.png",
		IsActive = function(pawn)
			if not GAME then return false end
			local mission = GAME.GetMission and GetCurrentMission()
			if not mission then return false end
			return pawn:IsAbility(pilot.Skill) and GAME.Potluck_Djinn_Wishes == 1
		end
	}

	repairApi:addSkill{
		weapon = "Skill_Repair",
		Icon = "img/weapons/repair_djinn_0.png",
		IsActive = function(pawn)
			if not GAME then return false end
			local mission = GAME.GetMission and GetCurrentMission()
			if not mission then return false end
			return pawn:IsAbility(pilot.Skill) and GAME.Potluck_Djinn_Wishes == 0
		end
	}

	--Put Weapon Defintion Here
	DjinnSkill_Link = Skill:new {
		Name = "Djinn's Wishes",
		Description = "Provodes a useful wish.",
		TipImage = {
			Unit = Point(2,2),
			Target = Point(2,2),
		}
	}

	function DjinnSkill_Link:GetTargetArea(point)
		local ret = PointList()
		ret:push_back(point)

		--Put Target Area Here

		return ret
	end

	function DjinnSkill_Link:GetSkillEffect(p1,p2)
		local ret = SkillEffect()
		local mission = GetCurrentMission()
		local pawn = Board:GetPawn(p1)

		if not mission or not GAME or IsTipImage() or IsTestMechScenario() then
			return ret
		end

		--Helper Functions
		local function CountTargetedBuildings()
			local buildings = 0
			local enemies = extract_table(Board:GetPawns(TEAM_ENEMY))
			for _, id in pairs(enemies) do
				local pawn = Board:GetPawn(id)
				local target_point = pawn:GetQueuedTarget()
				if target_point and Board:IsBuilding(target_point) then
					buildings = buildings + 1
				end
			end
			return buildings
		end

		local function CountTargetedMechs()
			local mechs = 0
			local enemies = extract_table(Board:GetPawns(TEAM_ENEMY))
			for _, id in pairs(enemies) do
				local pawn = Board:GetPawn(id)
				local target_point = pawn:GetQueuedTarget()
				if target_point and Board:GetPawn(target_point) and Board:GetPawn(target_point):IsMech() then
					mechs = mechs + 1
				end
			end
			return mechs
		end

		local function IsDeadAlly()
			for id = 0, 2 do
				if not Board:IsPawnAlive(id) then
					return true
				end
			end
			return false
		end

		ret:AddScript(string.format([[
			GAME.Potluck_Djinn_Wishes = GAME.Potluck_Djinn_Wishes - 1
			Board:AddAlert(%s, "Wish Granted")
		]], p1:GetString()))

		--[[
			If power is 2 or less, add one power
			If there's three targeted buildings, shield all buildings
			If there's three targeted mechs, shield all mechs
			If webbed, unweb and reactivate
			If ally is dead, heal all mechs
			If not one turn left, reduce turns by one
			Else, kill all enemies
		]]

		if Game:GetPower():GetValue() <= 2 then
			local damage = SpaceDamage(p1)
			damage.sImageMark = "combat/icons/icon_gridup_glow.png"
			ret:AddDamage(damage)
			ret:AddScript("Game:ModifyPowerGrid(SERIOUSLY_JUST_ONE)")
		elseif CountTargetedBuildings() >= 3 then
			local buildings = Board:GetBuildings()
			for i = 1, buildings:size() do
				local damage = SpaceDamage(buildings:index(i))
				damage.iShield = EFFECT_CREATE
				ret:AddDamage(damage)
			end
		elseif CountTargetedMechs() >= 3 then
			for id = 0, 2 do
				local damage = SpaceDamage(Board:GetPawn(id):GetSpace())
				damage.iShield = EFFECT_CREATE
				ret:AddDamage(damage)
			end
		elseif pawn:IsGrappled() then
			local damage = SpaceDamage(p1)
			damage.sImageMark = "combat/icons/icon_grapple_no.png"
			ret:AddDamage(damage)
			ret:AddScript(string.format([[
				local space = %s
				local pawn = Board:GetPawn(space)
				Board:Ping(space, GL_Color(255, 255, 255));
				pawn:SetSpace(Point(-1, -1))

				modApi:runLater(function()
					pawn:SetSpace(space)

					pawn:SetActive(true)
					pawn:SetBonusMove(0)
				end)
			]], p1:GetString()))
		elseif IsDeadAlly() then
			local damage = SpaceDamage(Point(-1,-1), -10)
			damage.iFire = EFFECT_REMOVE
			damage.iAcid = EFFECT_REMOVE

			for id = 0, 2 do
				damage.loc = Board:GetPawn(id):GetSpace()
				ret:AddDamage(damage)
			end
		--Because this means there isn't one turn left for some reason, just trust
		elseif mission.TurnLimit - Board:GetTurn() ~= 0 then
			local damage = SpaceDamage(p1)
			damage.sImageMark = "combat/icons/icon_timedown.png"
			ret:AddDamage(damage)
			ret:AddScript("GetCurrentMission().TurnLimit = GetCurrentMission().TurnLimit - 1")
		else
			local enemies = extract_table(Board:GetPawns(TEAM_ENEMY))
			for _, id in pairs(enemies) do
				local pawn = Board:GetPawn(id)
				local space = pawn:GetSpace()

				local damage = SpaceDamage(space, DAMAGE_DEATH)
				ret:AddDropper(damage, "effects/djinn_dropper.png")
				ret:AddDelay(.8)
				ret:AddDamage(damage)

			end
		end



		return ret
	end
end

--[[  Skill Specfic Dialog and hooks
function this:load(modApiExt, options)
	modApiExt.dialog:addRuledDialog("Name", {
		Odds = 5,
		{ main = "Name" },
	})
end
--]]

local function EVENT_GameStart()
	GAME.Potluck_Djinn_Wishes = 3
end

local function EVENT_onModsLoaded()
	--Add hooks here
end

modApi.events.onPostStartGame:subscribe(EVENT_GameStart)

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

return this
