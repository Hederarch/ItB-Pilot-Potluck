local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
local pawnMove = mod.libs.pawmMove
local moveskill = mod.libs.moveSkill

local pilot = {
	Id = "Pilot_Square",
	Personality = "Pilot_Square",
	Name = "Square",
	Sex = SEX_MALE, --or other sex
	Skill = "Square_Skill",
	Voice = "/voice/mafan", --or other voice
}

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	pilotSkill_tooltip.Add(pilot.Skill, PilotSkill("Squared Movement", "Mech's movement radius is replaced by a square."))

	--Skill: A lot of the skill will probably just be hooks, which goes down below
	--But art and icons can go here
	Square_Skill = {}
	moveskill.AddTargetArea(pilot.Personality, Square_Skill)
	moveskill.AddSkillEffect(pilot.Personality, Square_Skill)

	function Square_Skill:GetTargetArea(p, ...)
		local mover = Board:GetPawn(p)
		if mover and mover:IsAbility("Square_Skill") then
			local ret = PointList()
			local movespeed = (mover:GetMoveSpeed()-1)
			for i = (0-movespeed), movespeed do
				for j = (0-movespeed), movespeed do
				local curr = Point(p.x+i, p.y+j)
					if not Board:IsBlocked(curr,PATH_PROJECTILE) then
							ret:push_back(curr)
					end
				end
			end
			return ret
		end
	end
	function Square_Skill:GetSkillEffect(p1,p2)
		local ret = SkillEffect()
		damage = SpaceDamage(p1,0)
		damage.sSound = "/props/train_move"
		ret:AddDamage(damage)
		ret:AddTeleport(p1,p2,0)
		return ret
	end
end

return this