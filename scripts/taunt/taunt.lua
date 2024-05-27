------------------------------------------------------------------------------
-- Taunt Library
-- v2.0.2
-- By: NamesAreHard (NamesAreHard#2501) and Truelch (Truelch#4266)
------------------------------------------------------------------------------
-- Contains functions that allow for a new mechanic, taunting, that changes vek attacks to a new tile
--
-- For use, add the following lines to the beginning of any file that uses taunt, and then make sure you've got modApiExt and memedit enabled
-- Place the taunt folder in your scripts folder
--[[

local mod = mod_loader.mods[modApi.currentMod]
local scriptPath = mod.scriptPath
local taunt = require(scriptPath.."taunt/taunt")

--]]
--
------------------------------------------------------------------------------
-- DEPENDENCIES:
-- memedit + modApiExt: Add them as dependencies to your mod, with the modloader

--[[ Documentation and Notes
Note: Custom Tooltips are neccesary for working tooltips unfortunately, espeically if damage is being done
Note: If you want to do damage on the taunted tile, you MUST pass it into the function. If you don't,
the icons will get overridden by the damage icons. Sorry for any inconvinences this causes. You may still
add a zero damage SpaceDamage to the tile.

MORE DOCUMENTATION
Scroll down to "Taunt Functions" line: 194ish for documentation on the functions you'll be using
]]--

taunt = {}

local mod = mod_loader.mods[modApi.currentMod]
local scriptPath = mod.scriptPath

--Icons, gotta love them
modApi:appendAsset("img/combat/icons/tauntIcon_0.png", scriptPath.."taunt/img/combat/icons/tauntIcon_0.png")
	Location["combat/icons/tauntIcon_0.png"] = Point(-15,-7) --288, 216 - 220, 228
modApi:appendAsset("img/combat/icons/tauntFailIcon_0.png", scriptPath.."taunt/img/combat/icons/tauntFailIcon_0.png")
	Location["combat/icons/tauntFailIcon_0.png"] = Point(-15,-7)

modApi:appendAsset("img/combat/icons/tauntIcon_1.png", scriptPath.."taunt/img/combat/icons/tauntIcon_1.png")
	Location["combat/icons/tauntIcon_1.png"] = Point(-15,6) -- 344 304 -- 274 292
modApi:appendAsset("img/combat/icons/tauntFailIcon_1.png", scriptPath.."taunt/img/combat/icons/tauntFailIcon_1.png")
	Location["combat/icons/tauntFailIcon_1.png"] = Point(-15,6)

modApi:appendAsset("img/combat/icons/tauntIcon_2.png", scriptPath.."taunt/img/combat/icons/tauntIcon_2.png")
	Location["combat/icons/tauntIcon_2.png"] = Point(-35,6)
modApi:appendAsset("img/combat/icons/tauntFailIcon_2.png", scriptPath.."taunt/img/combat/icons/tauntFailIcon_2.png")
	Location["combat/icons/tauntFailIcon_2.png"] = Point(-35,6)

modApi:appendAsset("img/combat/icons/tauntIcon_3.png", scriptPath.."taunt/img/combat/icons/tauntIcon_3.png")
	Location["combat/icons/tauntIcon_3.png"] = Point(-35,-6)
modApi:appendAsset("img/combat/icons/tauntFailIcon_3.png", scriptPath.."taunt/img/combat/icons/tauntFailIcon_3.png")
	Location["combat/icons/tauntFailIcon_3.png"] = Point(-35,-6)

--Damage is being done
modApi:appendAsset("img/combat/icons/tauntIcon_0_d.png", scriptPath.."taunt/img/combat/icons/tauntIcon_0_d.png")
	Location["combat/icons/tauntIcon_0_d.png"] = Point(-15,-27) --288, 216 - 220, 228
modApi:appendAsset("img/combat/icons/tauntFailIcon_0_d.png", scriptPath.."taunt/img/combat/icons/tauntFailIcon_0_d.png")
	Location["combat/icons/tauntFailIcon_0_d.png"] = Point(-15,-27)

modApi:appendAsset("img/combat/icons/tauntIcon_1_d.png", scriptPath.."taunt/img/combat/icons/tauntIcon_1_d.png")
	Location["combat/icons/tauntIcon_1_d.png"] = Point(-15,-14) -- 344 304 -- 274 292
modApi:appendAsset("img/combat/icons/tauntFailIcon_1_d.png", scriptPath.."taunt/img/combat/icons/tauntFailIcon_1_d.png")
	Location["combat/icons/tauntFailIcon_1_d.png"] = Point(-15,-14)

modApi:appendAsset("img/combat/icons/tauntIcon_2_d.png", scriptPath.."taunt/img/combat/icons/tauntIcon_2_d.png")
	Location["combat/icons/tauntIcon_2_d.png"] = Point(-35,-14)
modApi:appendAsset("img/combat/icons/tauntFailIcon_2_d.png", scriptPath.."taunt/img/combat/icons/tauntFailIcon_2_d.png")
	Location["combat/icons/tauntFailIcon_2_d.png"] = Point(-35,-14)

modApi:appendAsset("img/combat/icons/tauntIcon_3_d.png", scriptPath.."taunt/img/combat/icons/tauntIcon_3_d.png")
	Location["combat/icons/tauntIcon_3_d.png"] = Point(-35,-26)
modApi:appendAsset("img/combat/icons/tauntFailIcon_3_d.png", scriptPath.."taunt/img/combat/icons/tauntFailIcon_3_d.png")
	Location["combat/icons/tauntFailIcon_3_d.png"] = Point(-35,-26)



--Animations
require(scriptPath .. "/taunt/tauntAnims")



---------------------------- Utility/Local Functions ----------------------------

local function IsTipImage()
    return Board:GetSize() == Point(6,6)
end

local function isEnemyPawn(pawn)
    return pawn:GetTeam() == TEAM_ENEMY
end

local function isVek(pawn,type)
	local name = pawn:GetType()
	return name == type.."1" or name == type.."2" or name == type.."Boss"
end

local function isBot(pawn) --Because all bots are not ranged despite all having ranged attacks
	local name = pawn:GetType() --Using get type instead which pulls from easy to read
	return isVek(pawn,"Snowtank") or isVek(pawn,"Snowart") or isVek(pawn,"Snowlaser") or name == "BotBoss" or name == "BotBoss2" or name == "Snowtank1_Boom" or name == "Snowlaser1_Boom" or name == "Snowart1_Boom"
end

local function isRanged(pawn)
	local ranged = {
		"Burnbug", --Gastropod
		"Moth",
		"Totem", --Spore
		"DNT_Ladybug", --Vextra
		"DNT_Silkworm", --Vextra
	}
	for _, vek in ipairs(ranged) do
		if isVek(pawn,vek) then
			return true
		end
	end
	local mission = GetCurrentMission()
	--Junebug: Only ranged when ladybug is dead
	if mission and isVek(pawn,"DNT_Junebug") and mission.DNT_LadybugID and not Board:IsPawnAlive(mission.DNT_LadybugID) then
		return true
	end
	return (pawn:IsRanged() and not pawn:IsJumper() and not isVek(pawn,"Dung")) or isBot(pawn)
end

local function canTargetHornet(distance, target, pawn) --This is now all enemies with 2 or more range that are still melee.
	local space = pawn:GetSpace()
	if space.x ~= target.x and space.y ~= space.y then return false end
	local dist = target:Manhattan(space)
	return dist <= distance
end

local function canTargetSpringseed(target, pawn)
	local space = pawn:GetSpace()
	local dist = target:Manhattan(space)
	return dist == 1
end

local function canTargetDragonfly(target,pawn)
	local space = pawn:GetSpace()
	local dist = target:Manhattan(space)
	return dist < 4 and dist > 1
end

--Check if the the target is actually in the GetTargetArea of the enemy, as well as more for unique situations
local function canTargetNewPoint(pawn, target)
	--Hornets and modded vek exceptions
	local name = pawn:GetType()
	if name == "Hornet2" or name == "lmn_Chomper1" or name == "lmn_Chomper2" or name == "lmn_Chili1" or name == "lmn_Chili2" then --Hornet and chompers with 2 range and chilis
		return canTargetHornet(2, target, pawn)
	elseif name == "HornetBoss" or name == "lmn_KnightBot" or name == "lmn_ChomperBoss" or name == "lmn_ChiliBoss" or isVek(pawn,"DNT_IceCrawler") then --Hornet Leader + Knight Bots with 3 range + Chomper Boss with 3 range + chili boss with 3 range + Ice Crawlers with 3 range
		return canTargetHornet(3, target, pawn)
	elseif isVek(pawn,"lmn_Springseed") then --Springseed with essentially a melee attack, but its target area is two
		return canTargetSpringseed(target, pawn)
	elseif name == "DNT_DragonflyBoss" then --Dragonfly Boss has 3 range arty
		return canTargetDragonfly(target,pawn)
	elseif name == "lmn_Cactus1" or name == "lmn_Cactus2" or name == "lmn_SpringseedBoss" or isVek(pawn,"DNT_Mantis") then
		return false --Cactus always retargets to nearest enemy, so you can't taunt it. Also springseed boss is chaos hell to the no. And mantis is diagonal
	end
	--Other Ranged
  if isRanged(pawn) then
		local id = pawn:GetId()
		local loc = pawn:GetSpace()
		local point = pawn:GetQueuedTarget()
		local dist = loc:Manhattan(point) --Artillery should honestly revert back to the in target area thing. Too late now. (not sure why I didn't do this)
		if dist > 1 then --Artillery Vek
			dist = loc:Manhattan(target)
			if dist > 5 or dist == 1 then return false end --Out of the artillery's range
		end
		return true
	end
	--All Else
	local queuedWeaponName = pawn:GetQueuedWeapon()
    if queuedWeaponName == nil then
        return
    end

    local queuedWeapon = _G[queuedWeaponName]

    local pawnPos = pawn:GetSpace()

    local areaPoints = queuedWeapon:GetTargetArea(pawn:GetSpace())

    --Loop over GetArea points and check if the target is in it
    for _,v in pairs(extract_table(areaPoints)) do
        if v == target then
            return true
        end
    end

    --Did not find a corresponding point
    return false
end

--Checks if the enemy can be taunted by the given point
local function canBeTauntedByPoint(pawn, point)
	local id = pawn:GetId()
	local space = pawn:GetSpace()

	local target = pawn:GetQueuedTarget()
	if target == Point(-1, -1) or target == space then return false end -- The enemy has a target, the target doesn't equal the current space trying to be taunted, and the target is attacking its own space (digger, scorp leader, etc.)
  return canTargetNewPoint(pawn, point)-- and not target == point and not target == Point(-1,-1)
end


------------------------------- Taunt Functions -------------------------------
--[[
  Taunts an enemy if given the id of the enemy, will do so as soon as it's called: does not add animations on its own
  If you are making a weapon, it is *highly* suggested that use use taunt.addTauntEffectEnemy or taunt.addTauntEffectSpace instead, (seen below), but this is given to you if you wish
  (you can always create an effect and activate it immediatly with Board:AddEffect(effect))
  Provide your effect and let us do all the hard work for you, such as adding icons and animations!

  @param pawn	the id
  @param point	the new point for the pawn to target
]]
function taunt.enemy(id, point)
	if Board == nil then return end

	local pawn = Board:GetPawn(id)
  if IsTipImage() or pawn == nil or not isEnemyPawn(pawn) or not canBeTauntedByPoint(pawn, point) then return end

	local loc = pawn:GetSpace()

	local target = pawn:GetQueuedTarget()

	if isRanged(pawn) then --Ranged
		local dist = loc:Manhattan(target)
		if dist > 1 then --Artillery Vek
			dist = loc:Manhattan(point)
			if dist > 5 or dist == 1 then return end --Out of the artillery's range
		end
		local dir = GetDirection(point - loc)
		local newtarget = loc + DIR_VECTORS[dir] * dist
		pawn:SetQueuedTarget(newtarget)
	elseif isVek(pawn,"lmn_Springseed") then --Springseed
		local dir = GetDirection(point - loc)
		local newtarget = loc + DIR_VECTORS[dir] * 2
		pawn:SetQueuedTarget(newtarget)
	else --Melee
		local dir = GetDirection(point - loc)
		local newtarget = loc + DIR_VECTORS[dir]
		pawn:SetQueuedTarget(newtarget)
	end
end

--[[
  taunt.addTauntEffectEnemy
  Adds a taunt to the Skill Effect object given, when given a pawn id: You should use this primarily, or the space version, since it will add icons.
  Note: The space version has the advantage of adding the fail icon even if there is no enemy there, while this function will not.

  @param effect	the SkillEffect Object to add to.
  @param pawn		the id
  @param point		the new point for the pawn to target
  @param dmg[opt=0] the damage to do to the taunted point (if you do this outside, the icon will be overridden)
  @param failFlag[opt=false] If true, if the taunt fails, it no longer does damage
  @return returns a bool: true if the taunt is successful and false if it is not
]]

function taunt.addTauntEffectEnemy(effect, id, point, dmg, failFlag)
	local ret = false

	dmg = dmg or 0
	failFlag = failFlag or false
	if Board == nil or IsTipImage() then return end
	local pawn = Board:GetPawn(id)
	if pawn == nil or not isEnemyPawn(pawn) then return end
	local loc = pawn:GetSpace()
	local dir = GetDirection(point - loc)


	effect:AddScript([[
		taunt.enemy(]]..id..[[,]]..point:GetString()..[[)
	]])
	local damage = SpaceDamage(loc,dmg)
	if canBeTauntedByPoint(pawn, point) then
		damage.sImageMark = "combat/icons/tauntIcon_"..tostring(dir)..".png"
		if dmg > 0 then
			damage.sImageMark = "combat/icons/tauntIcon_"..tostring(dir).."_d.png"
		end
		damage.sAnimation = "taunted"
		effect:AddDamage(damage)
		damage = SpaceDamage(point,0)
		damage.sAnimation = "taunting"

		--Remove Webs
		effect:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(-1,-1))", id))
		effect:AddDelay(0.016)
		effect:AddScript(string.format("Board:GetPawn(%s):SetSpace(%s)", id, loc:GetString()))

		ret = true
	else
		damage.sImageMark = "combat/icons/tauntFailIcon_"..tostring(dir)..".png"
		if failFlag then
			damage.iDamage = 0
		elseif dmg > 0 then
			damage.sImageMark = "combat/icons/tauntFailIcon_"..tostring(dir).."_d.png"
		end

		ret = false
	end
	effect:AddDamage(damage)
	return ret
end

--[[
  taunt.addTauntEffectSpace
  Adds a taunt to the Skill Effect object given, when given a space: You should use this primarily, or the pawn version, since it will add icons.
  Note: The pawn version has the disadvantage of not adding the fail icon if there is invalid enemy id given, while this function will.

  @param effect	the SkillEffect Object to add to.
  @param space		the space to trigger the effect on
  @param point		the new point for the pawn to target
  @param dmg[opt=0] the damage to do to the taunted point (if you do this outside, the icon will be overridden)
  @param failFlag[opt=false] If true, if the taunt fails, it no longer does damage
  @return returns a bool: true if the taunt is successful and false if it is not
]]
function taunt.addTauntEffectSpace(effect, space, point, dmg, failFlag)
	dmg = dmg or 0
	failFlag = failFlag or false
	if Board == nil or IsTipImage() then return end
	local pawn = Board:GetPawn(space)
	if pawn == nil or not isEnemyPawn(pawn) then
		local dir = GetDirection(point - space)
		local damage = SpaceDamage(space,dmg)
		damage.sImageMark = "combat/icons/tauntFailIcon_"..tostring(dir)..".png"
		if failFlag then
			damage.iDamage = 0
		elseif dmg > 0 then
			damage.sImageMark = "combat/icons/tauntFailIcon_"..tostring(dir).."_d.png"
		end
		effect:AddDamage(damage)
		return false
	end
	local id = pawn:GetId()
	return taunt.addTauntEffectEnemy(effect,id,point,dmg,failFlag)
end

return taunt
