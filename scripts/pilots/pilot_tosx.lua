local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
--local repairApi = mod.libs.repairApi
local pawnMove = mod.libs.pawmMove
local moveSkill = mod.libs.moveSkill
--local taunt = mod.libs.taunt
--local boardEvents = mod.libs.boardEvents

local pilot = {
	Id = "Pilot_Tosx",
	Personality = "tosx",
	Name = "Tosx",
	Sex = SEX_VEK, --SEX_MALE
	Skill = "TosxSkill",
	Voice = "/voice/ariadne", --or other voice
}

function IsForest(point)
	return Board:IsTerrain(point, TERRAIN_FOREST) or Board:IsForestFire(point)
end

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	require(mod.scriptPath .."libs/pilotSkill_tooltip").Add(pilot.Skill, PilotSkill("Forest Bound", "Can move on to any forest tile from anywhere. Any forest fires you move to are put out."))

	-- art, icons, animations
	modApi:appendAsset("img/effects/pilot_tosx.png",mod.resourcePath.."img/effects/pilot_tosx.png")
	--modApi:appendAsset("img/effects/pilot_tosx2.png",mod.resourcePath.."img/effects/pilot_tosx2.png")
	modApi:appendAsset("img/combat/tiles_grass/pilot_tosx_leaf.png",mod.resourcePath.."img/effects/pilot_tosx_leaf.png")

	ANIMS.PilotTosxOrgin = Animation:new {
		Image = "effects/pilot_tosx.png",
		NumFrames = 12,
		Time = 0.05,
		PosX = -33,
		PosY = -15
	}

	ANIMS.PilotTosxTarget = ANIMS.PilotTosxOrgin:new {
		Frames = {11,10,9,8,7,6,5,4,3,2,1,0}
	}

	NAH_Tosx_Leaf = Emitter:new{
		image = "combat/tiles_grass/pilot_tosx_leaf.png",
		x = 0,
		y = -7,
		variance = 0,
		variance_x = 22,
		variance_y = 2,
		max_alpha = 0.8,
		min_alpha = 0.5,
		angle = 0,
		angle_variance = 360,
		rot_speed = 40,
		random_rot = true,
		lifespan = 1.2,
		burst_count = 32,
		speed = .15,
		birth_rate = 1,
		gravity = true,
		layer = LAYER_FRONT,
		timer = .1,
		max_particles = 64,
	}


	--Skill
	TosxSkill = {}
	moveSkill.AddTargetArea(pilot.Personality, TosxSkill)
	moveSkill.AddSkillEffect(pilot.Personality, TosxSkill)

	function TosxSkill:GetTargetArea(point)
		local ret = pawnMove.GetTargetArea(point)
		local board_size = Board:GetSize()
		for i = 0,  board_size.x - 1 do
			for j = 0, board_size.y - 1 do
				local curr = Point(i,j)
				if curr ~= point then
					if Board:IsValid(curr) and not Board:GetPawn(curr) and (IsForest(curr)) then
						ret:push_back(curr)
					end
				end
			end
		end
		return ret
	end

	function TosxSkill:GetSkillEffect(p1,p2)
		local mission = GetCurrentMission()
		if not mission then return end

		-- if within the normal target area and not a forest (for fun and to put out the fire), use normal move
		local path = pawnMove.GetTargetArea(p1)
		if list_contains(extract_table(path), p2) and not IsForest(p2) then
			return pawnMove.GetSkillEffect(p1, p2)
		end

		local ret = SkillEffect()
		damage = SpaceDamage(p1,0)
		damage.sAnimation = "PilotTosxOrgin"
		damage.sSound = "/props/train_move"
		ret:AddScript(string.format(
			[[Board:AddBurst(%s,"NAH_Tosx_Leaf",DIR_NONE)]],
			p1:GetString()))
		ret:AddDamage(damage)

		ret:AddDelay(.15)
		damage = SpaceDamage(p2,0)
		damage.sAnimation = "PilotTosxTarget"
		damage.iFire = 2
		--damage.sImageMark = "combat/icons/pilot_vanish_icon_tele_A_glow.png"    --ADD AN ICON
		ret:AddDamage(damage)

		ret:AddDelay(.15)
		ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(-1,-1))", Pawn:GetId()))
		ret:AddTeleport(p1,p2,0) -- Needed for move previewing
		ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(%s))", Pawn:GetId(), p2:GetString()))

		--Trigger pilot dialogue and mark used if not in test scenario
		if not IsTestMechScenario() then
			-- No dialog currently
			--ret:AddScript([[
			--	local cast = { main = ]]..Pawn:GetId()..[[ }
			--	CaulP_modApiExt.dialog:triggerRuledDialog("Pilot_Skill_Vanish", cast)
			--]])
			--
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
return this
