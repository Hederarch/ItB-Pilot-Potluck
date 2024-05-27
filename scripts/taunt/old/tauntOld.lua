------------------------------------------------------------------------------
-- Taunt Library
-- v0.0
-- By: NamesAreHard (NamesAreHard#2501) and Truelch (Trulech#4266)
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
-- LApi - Make sure you have LApi in your mod, and follow its directions, adding : "require(self.scriptPath.."LApi/LApi")" : into your init

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

]]--



local taunt = {}
local mod = mod_loader.mods[modApi.currentMod]

--Custom utility functions
local function isEnemyPawn(pawn)
    return pawn:GetTeam() == TEAM_ENEMY
end

local function canTargetPoint(pawn, point)
    LOG("canTargetPoint()")
    LOG("pawn: " .. pawn:GetType() .. ", point: " .. point:GetString())
    local loc = pawn:GetSpace()
    LOG("loc: " .. loc:GetString())
    return loc.x == point.x or loc.y == point.y
end

local function rotate(pawn)
    LOG("rotate()")
    if Board == nil then return end
    local cutils = _G["cutils-dll"]
    
    --local pawn = Board:GetPawn(id
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

--[[
  Taunts a pawn if given a BoardPawn object

  @param pawn  the BoardPawn 
  @param point  the new point for the pawn to target
]]
function taunt.pawn(pawn, point)
	LOG("Hello!")

    --Logs
    if pawn ~= nil then
        LOG("Pawn exists!")
        LOG("pawn: " .. tostring(pawn:GetType()))
        local isEnemyPawn = isEnemyPawn(pawn)
        LOG("isEnemyPawn: " .. tostring(isEnemyPawn))
        local canTargetPawn = canTargetPoint(pawn, point)
        LOG("canTargetPawn: " .. tostring(canTargetPawn))
    else
        LOG("No pawn!")
    end

	-- You probably want to check that it's a vek before doing anything, just a random thought
    if pawn ~= nil and isEnemyPawn(pawn) and canTargetPoint(pawn, point) then
        rotate(pawn)
    end
end

--[[
  Taunts a pawn if given a tile (Point object)

  @param tile  the tile to check for a pawn on
  @param point  the new point for the pawn to target
]]
function taunt.tile(tile, point)
	pawn = Board:GetPawn(tile)
	if pawn then
		taunt.pawn(pawn,tile)
    end
end

return taunt