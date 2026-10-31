local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
local repairApi = mod.libs.repairApi

local pilot = {
	Id = "Pilot_Lemonymous",
	Personality = "lemonymous_personality",
	Name = "Lemonymous",
	Sex = SEX_Robot, --or other sex
	Skill = "SkillLemonymous",
	Voice = "/voice/archimedes", --or other voice
	PowerCost = 1,
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	pilotSkill_tooltip.Add(pilot.Skill, PilotSkill("Deus Ex Machina", "When repairing, also increases grid resist chance to 100% until the next hit."))
	modApi:appendAsset("img/effects/lemon100.png",mod.resourcePath.."img/effects/lemon100.png")
	modApi:appendAsset("img/weapons/repair_lemonymous.png",mod.resourcePath.."img/weapons/repair_lemonymous.png")
	Lemon_GridResistEmitter = Emitter:new{
		image = "effects/lemon100.png",
		x = -10,
		y = -2,
		variance = 0,
		variance_x = 0,
		variance_y = 0,
		max_alpha = 0.8,
		min_alpha = 0.1,
		angle = 0,
		angle_variance = 30,
		rot_speed = 0,
		random_rot = false,
		lifespan = 1.2,
		burst_count = 1,
		speed = 0,
		birth_rate = 1,
		gravity = false,
		layer = LAYER_FRONT,
		timer = .1,
		max_particles = 1,
	}
	repairApi:SetRepairSkill{
		Weapon = "LemonymousSkill_Link",
		Icon = "img/weapons/repair_lemonymous.png",
		IsActive = function(pawn)
			return pawn:IsAbility(pilot.Skill)
		end
	}
	LemonymousSkill_Link = Skill:new {
		Name = "Deus Ex Machina",
		Description = "Increases grid resist chance to 100% until the next hit.",
		TipImage = {
			Unit = Point(2,3),
			Target = Point(2,3),
			Enemy = Point(2,2),
			Enemy2 = Point(3,3),
		}
	}

	function LemonymousSkill_Link:GetTargetArea(point)
		local ret = PointList()
		ret:push_back(point)
		return ret
	end

	function LemonymousSkill_Link:GetSkillEffect(p1,p2)
		local ret = SkillEffect()

		local damage = SpaceDamage(p1, -1)
		damage.iFire = EFFECT_REMOVE
		damage.iAcid = EFFECT_REMOVE
		ret:AddDamage(damage)
		if GetCurrentMission() then
			ret:AddScript([[
			GAME.LemonPreviousGridResist = Game:GetResist()
			Game:SetResist(100)]])
			for i = 0, 7 do
				for j = 0, 7 do
					if Board:GetTerrain(Point(i, j)) == TERRAIN_BUILDING then
						ret:AddEmitter(Point(i, j), "Lemon_GridResistEmitter")
					end
				end
			end
		end
		return ret
	end
end
-- Hooks -------------------------------------------------------------------------------------------------------------------------------------------------
local function LemonGridResistReset(mission, pawn, weaponId, p1, p2, p3, effectType)
	if weaponId == "Move" then return end
	local fx
	if p3 == nil then
		fx = _G[weaponId]:GetSkillEffect(p1, p2)
	else
		fx = _G[weaponId]:GetFinalEffect(p1, p2, p3)
	end
	local flag = false
	--stuff below works in *most* cases
	--things like explosives chaining to damage buildings won't trigger
	--but I don't want to do recursion on every queued skill
	for _, spaceDamage in ipairs(extract_table(fx[effectType])) do
		--HANDLE DIRECT DAMAGE TO A VULNERABLE BUILDING
		if Board:GetTerrain(spaceDamage.loc) == TERRAIN_BUILDING 
		and not Board:IsShield(spaceDamage.loc) 
		and not Board:IsFrozen(spaceDamage.loc)  	
		and spaceDamage.iDamage > 0	then
			flag = true
		end
		--HANDLE PUSHING SOMETHING INTO A VULNERABLE BUILDING
		if (spaceDamage.iPush == DIR_UP or spaceDamage.iPush == DIR_DOWN or spaceDamage.iPush == DIR_LEFT or spaceDamage.iPush == DIR_RIGHT) and
		Board:GetPawn(spaceDamage.loc) and not Board:GetPawn(spaceDamage.loc):IsGuarding() and 
		Board:GetTerrain(spaceDamage.loc + DIR_VECTORS[spaceDamage.iPush]) == TERRAIN_BUILDING 
		and not Board:IsShield(spaceDamage.loc + DIR_VECTORS[spaceDamage.iPush]) 
		and not Board:IsFrozen(spaceDamage.loc + DIR_VECTORS[spaceDamage.iPush]) then
			flag = true
		end
		--HANDLE KILLING SOMETHING THAT BLOWS UP
		if Board:GetPawn(spaceDamage.loc) and Board:IsDeadly(spaceDamage, pawn) and 
		(_G[Board:GetPawn(spaceDamage.loc):GetType()].Explodes or Board:GetPawn(spaceDamage.loc):GetMutation() == 6 or Board:GetPawn(spaceDamage.loc):GetMutation() == 7) then
			flag = true
		end
		if flag and Game:GetResist() >= 100 and GAME.LemonPreviousGridResist then
			Game:SetResist(GAME.LemonPreviousGridResist)
			GAME.LemonPreviousGridResist = nil
			return
		end
	end
end

local function EVENT_onModsLoaded()
	--by passing an extra argument, I can use it to look at the part of the skill effect that I care about
	modapiext:addQueuedSkillEndHook(function(mission, pawn, weaponId, p1, p2)
		LemonGridResistReset(mission, pawn, weaponId, p1, p2, nil, "q_effect")
	end)
	modapiext:addSkillEndHook(function(mission, pawn, weaponId, p1, p2)
		LemonGridResistReset(mission, pawn, weaponId, p1, p2, nil, "effect")
	end)
	modapiext:addFinalEffectEndHook(function(mission, pawn, weaponId, p1, p2, p3)
		LemonGridResistReset(mission, pawn, weaponId, p1, p2, p3, "effect")
	end)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)


return this
