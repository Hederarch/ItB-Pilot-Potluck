------------------------------------------------------------------------------
-- Taunt Library
-- v0.0
-- By: NamesAreHard (NamesAreHard#2501) and Trulech (Trulech#4266)
------------------------------------------------------------------------------
-- Contains functions that allow for a new mechanic, taunting, that changes vek attacks to a new tile
--
-- For use, add the following lines to the top of any script which is going to use the library, and put this script in a folder named "libs", or edit the code to your liking
--[[
local mod = mod_loader.mods[modApi.currentMod]
local scriptPath = mod.scriptPath
local taunt = require(scriptPath.."libs/taunt")
--]]
--
------------------------------------------------------------------------------
-- Dependencies:
-- LApi - Make sure you have LApi in your mod, and follow it's directions, adding : "require(self.scriptPath.."LApi/LApi")" : into your init

--[[
NOTES:
Lemons Example:
Rotate all enemy attacks example
function magic()
    if Board == nil then return end
    local cutils = _G["cutils-dll"]

    for _, id in ipairs(extract_table(Board:GetPawns(TEAM_ENEMY))) do
        local pawn = Board:GetPawn(id)
        local loc = pawn:GetSpace()
        local target = Point(
            cutils.Pawn.GetQueuedTargetX(id),
            cutils.Pawn.GetQueuedTargetY(id)
        )
        local dir = (GetDirection(target - loc) + 1) % 4
        local dist = loc:Manhattan(target)

        target = loc + DIR_VECTORS[dir] * dist

        cutils.Pawn.SetQueuedTargetX(id, target.x)
        cutils.Pawn.SetQueuedTargetY(id, target.y)
    end
end

More Lemon Words:
My suggestion would be something like this:

Example weapon texts based on Rift Walker weapons:
1. "Punch an adjacent tile, damaging and taunting it."
2. "Fires a powerful projectile that damages and taunts its target."
3. "Powerful artillery strike, damaging a single tile and taunting adjacent tiles."

Taunt would then be explained in tutorial tips, to not clutter weapon descriptions.

As for functionality of taunt, it could function so that the enemy changes its attack direction towards where the attack comes from (not necessarily towards the attacker, as seen in weapon example 3). The new attack direction would be directly opposite of where the unit would go if it was pushed in the original Rift Walker weapons.

And lastly, an image would be needed to preview the taunt direction on affected tiles.

Make sure you have LApi

To Do:
Remove Webs
]]--

local taunt = {}
local mod = mod_loader.mods[modApi.currentMod]

------------------------------------------------------------------------- Utility functions

local function IsTipImage()
    return Board:GetSize() == Point(6,6)
end

local function isEnemyPawn(pawn)
    return pawn:GetTeam() == TEAM_ENEMY
end

local function canTargetPoint(pawn, point)
    local loc = pawn:GetSpace()
    return loc.x == point.x or loc.y == point.y
end


--[[
  Taunts an enemy if given the id of the enemy

  @param pawn  the id 
  @param point  the new point for the pawn to target
]]
function taunt.enemy(id, point) -- REMOVE WEBS
	pawn = Board:GetPawn(id)

    if Board == nil or IsTipImage() or pawn == nil or not isEnemyPawn(pawn) or not canTargetPoint(pawn, point) then return end

    local cutils = _G["cutils-dll"]
	local loc = pawn:GetSpace()

	local target = Point(
		cutils.Pawn.GetQueuedTargetX(id),
		cutils.Pawn.GetQueuedTargetY(id)
	)

    LOG("target: " .. target:GetString() .. ", point: " .. point:GetString())

    --target == Point(-1, -1) when they don't have a target
    if target == point or target == Point(-1, -1) then
        LOG("Return!")
        return
    else
        LOG("Continue!")
    end

	--local dir = GetDirection(target - point)
    local dir = GetDirection(point - target)
    LOG("dir: " .. tostring(dir))

	local dist = loc:Manhattan(point)
    LOG("dist: " .. tostring(dist))

	target = loc + DIR_VECTORS[dir] * dist

    LOG("target: " .. target:GetString())

	--cutils.Pawn.SetQueuedTargetX(id, target.x)
	--cutils.Pawn.SetQueuedTargetY(id, target.y)

    cutils.Pawn.SetQueuedTargetX(id, point.x)
    cutils.Pawn.SetQueuedTargetY(id, point.y)
end

--[[  I CAN'T GET THIS WORKING WHEN IN A SCRIPT, BUT I DON'T THINK WE REALLY NEED IT
  Taunts a pawn if given a tile (Point object)

  @param tile  the tile to check for a pawn on
  @param point  the new point for the pawn to target
]]
function taunt.tile(tile, point)
	if Board == nil then return end
	pawn = Board:GetPawn(tile) -- It doesn't think tile is a point when I try
	if pawn then
		taunt.enemy(pawn,tile)
	end
end
return taunt
