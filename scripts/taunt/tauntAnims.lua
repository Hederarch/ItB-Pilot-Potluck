------------------------------------------------------------------------- Imports
local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
local scriptPath = mod.scriptPath

------------------------------------------------------------------------- Assets
--temporary
modApi:appendAsset("img/effects/taunting.png", scriptPath.."taunt/img/animations/taunting.png")
modApi:appendAsset("img/effects/taunted.png", scriptPath.."taunt/img/animations/taunted.png")



------------------------------------------------------------------------- Anims
ANIMS.taunting = Animation:new{
	Image = "effects/taunting.png",
	NumFrames = 5,
	Time = .1,
	PosX = -24,
	PosY = -2,
}


ANIMS.taunted = Animation:new{
	Image = "effects/taunted.png",
	NumFrames = 4,
	Time = .07,
	PosX = -24,
	PosY = -2,
	Frames = { 1, 2, 3, 2, 1, 2, 3, 2, 1, 2, 3, 4 },
}

