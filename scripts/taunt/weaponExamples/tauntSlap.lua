local mod = mod_loader.mods[modApi.currentMod]
local scriptPath = mod.scriptPath
local taunt = require(scriptPath .. "/taunt/taunt")
LOG("taunt: " .. tostring(taunt))

tauntSlap = Skill:new{
	Name = "Taunt Slap",
	Description = "Taunts a target and deals 2 damage to it.",
	Class = "Prime",
	PowerCost = 1,
	Icon = "weapons/prime_punchmech.png",
	Rarity = 3,
	--LaunchSound = "/weapons/titan_fist",
	LaunchSound = "",
	Range = 1,
	Damage = 1,
	Taunt = true,

	TipImage = StandardTips.Melee,
}

function tauntSlap:GetTargetArea(point)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		local curr = point + DIR_VECTORS[dir]
		if Board:IsValid(curr) then
			ret:push_back(curr)
		end
	end	
	return ret
end

function tauntSlap:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(p2)

	damage.iDamage = self.Damage

	--Taunt (inside AddScript?)
	local pawn = Board:GetPawn(p2)
	if pawn ~= nil then
		taunt.enemy(pawn:GetId(), p1)
	end

	ret:AddDamage(damage)

	--Taunting effect
	local tauntingEffect = SpaceDamage(p1)
	tauntingEffect.sAnimation = "taunting"
	ret:AddDamage(tauntingEffect)

	--Taunted(s) effect(s)
	local tauntedEffect = SpaceDamage(p2)
	tauntedEffect.sAnimation = "taunted"
	ret:AddDamage(tauntedEffect)

	return ret
end
