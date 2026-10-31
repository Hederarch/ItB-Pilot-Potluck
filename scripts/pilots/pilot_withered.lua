local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod_loader.mods[modApi.currentMod].resourcePath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
local personalities = require(path .."scripts/libs/personality")

modApi:appendAsset("img/portraits/pilots/ffrg_Pilot_Withered.png", path .."img/portraits/pilots/ffrg_Pilot_Withered.png")
modApi:appendAsset("img/portraits/pilots/ffrg_Pilot_Withered_2.png", path .."img/portraits/pilots/ffrg_Pilot_Withered_2.png")
modApi:appendAsset("img/portraits/pilots/ffrg_Pilot_Withered_blink.png", path .."img/portraits/pilots/ffrg_Pilot_Withered_blink.png")
modApi:appendAsset("img/effects/refill.png", path .."img/effects/refill.png")

ANIMS.ffrg_UseRefillWithered = Animation:new{
    Image = "effects/refill.png",
    NumFrames = 32,
    Time = 0.03,
    PosX = -20,
    PosY = -30
}

local dialog_withered = require(path .."scripts/pilots/dialog_withered")

local pilot_withered = {
    Id = "ffrg_Pilot_Withered",
    Personality = "ffrg_personality_withered",
    Name = "WitheredPlate",
    Rarity = 1,
    Voice = "/voice/silica",
    PowerCost = 2,
    Skill = "ffrg_Amplifier",
    Blacklist = {"Conservative"},
    Sex = SEX_MALE,
}

function this:GetPilot()
	return pilot_withered
end

function this:init(mod)
    CreatePilot(pilot_withered)
end

local personality_withered = personalities:new{ Label = "ffrg_Withered" }

personality_withered:AddDialog(dialog_withered)

Personality["ffrg_personality_withered"] = personality_withered

pilotSkill_tooltip.Add(
    "ffrg_Amplifier",
    PilotSkill(
        "Amplifier",
        "On Reset Turn, all Mechs gain Boost and are Supplied"
    )
)

local resetCharge = false

local function BoardHasAbility()
    if not Board then return end
    for id = 0, 2 do
        local mech = Board:GetPawn(id)
        if mech ~= nil and mech:IsAbility(pilot_withered.Skill) then
            return true
        end
    end
end

local ffrg_onResetTurn = function(mission)
    resetCharge = true
end

local ffrg_onFrameDrawn = function()
    if resetCharge then
        resetCharge = false
        if BoardHasAbility() then
            for i = 0, 7 do
                for j = 0, 7  do
                    local point = Point(i,j)
                    if Board:IsPawnSpace(point) and Board:GetPawn(point):IsMech() then
                        local pawn = Board:GetPawn(point)
                        if not pawn:IsBoosted() then
                            pawn:SetBoosted(true)
                        end
                        local index = 0
                        local count = pawn:GetWeaponCount()
                        if count > 0 then
                            for h = 1, count do
                                local powered = pawn:IsWeaponPowered(pawn:GetEquippedWeapons()[h])
                                local uses = pawn:GetWeaponLimitedUses(h)
                                if uses > 0 and powered then
                                    index = index + h
                                end
                            end
                        end
                        if index > 0 then
                            local damage = SpaceDamage(point,0)
                            damage.sAnimation = "ffrg_UseRefillWithered"
                            damage.sSound = "/ui/battle/pod_open"
                            Board:DamageSpace(damage)
                            if index == 1 then
                                pawn:SetWeaponLimitedRemaining(1,pawn:GetWeaponLimitedRemaining(1)+1)
                            end
                            if index == 2 then
                                pawn:SetWeaponLimitedRemaining(2,pawn:GetWeaponLimitedRemaining(2)+1)
                            end
                            if index == 3 then
                                pawn:SetWeaponLimitedRemaining(1,pawn:GetWeaponLimitedRemaining(1)+1)
                                pawn:SetWeaponLimitedRemaining(2,pawn:GetWeaponLimitedRemaining(2)+1)
                            end
                            Board:Ping(point, GL_Color(255,176,220))
                        end
                    end
                end
            end
        end
    end
end

-- For custom voice line on reset turn if ability is powered.
local oldTriggerVoiceEvent = TriggerVoiceEvent
function TriggerVoiceEvent(event, ...)
	if event.id == "Mission_ResetTurn" then
        for id = 0, 2 do
            if Board:GetPawn(id):IsAbility(pilot_withered.Skill) then
                event = VoiceEvent("Mission_ResetTurn_Withered",id,id)
            end
        end
    end
	oldTriggerVoiceEvent(event, ...)
end

modapiext.events.onResetTurn:subscribe(ffrg_onResetTurn)
modApi.events.onFrameDrawn:subscribe(ffrg_onFrameDrawn)

return this
