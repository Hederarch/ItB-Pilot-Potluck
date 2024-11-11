local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip
--local repairApi = mod.libs.repairApi
--local pawnMove = self.libs.pawmMove
--local moveSkill = self.libs.moveSkill
--local taunt = mod.libs.taunt

local pilot = {
	Id = "Pilot_Tatu",
	Personality = "pilotpotluck_Tatu",
	Name = "Tatu",
	Sex = SEX_MALE, --or other sex
	Skill = "tatu_armordillo",
	Voice = "/voice/archimedes", --or other voice
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
	pilotSkill_tooltip.Add(pilot.Skill, PilotSkill("Armordillo", "Mech can't be pushed and suffers no self-damage"))

	--Skill: A lot of the skill will probably just be hooks, which goes down below
	--But art and icons can go here

end

--[[  Skill Specfic Dialog and hooks
function this:load(modApiExt, options)
	modApiExt.dialog:addRuledDialog("Name", {
		Odds = 5,
		{ main = "Name" },
	})
end
--]]

-- Place hook functions here
-- Use BoardHasAbility to check if your pilot is on the Board
-- Or search all mech pawns to find the pawn with your skill
-- But DON'T apply effects to the board uncondtionally

local function tatu_zeroDamage(pawn,skillEffect,queued)
	if pawn and pawn:IsAbility(pilot.Skill) then
		local effect = queued and skillEffect.q_effect or skillEffect.effect
		if effect == nil or not pawn:IsMech() then
			return
		end
		
		-- create points with pawns list
		local pointPawn = {}
		-- remove damage
		for i = 1, effect:size() do
			local spaceDamage = effect:index(i)
			-- add points with pawns to list
			if spaceDamage:IsMovement() then
				local startPoint = spaceDamage:MoveStart()
				local endPoint = spaceDamage:MoveEnd()
				local endPawn = Board:GetPawn(startPoint)
				if endPawn and endPawn:GetId() == pawn:GetId() then
					pointPawn[endPoint.x+10*endPoint.y] = endPawn
				end
			end
			local dpoint = spaceDamage.loc
			local damage = spaceDamage.iDamage
			local dpawn = Board:GetPawn(dpoint)
			-- if dpawn or pointPawn[dpoint.x+10*dpoint.y] then
			if (dpawn and dpawn:GetId() == pawn:GetId()) or pointPawn[dpoint.x+10*dpoint.y] then
				if damage > 0 then
					spaceDamage.iDamage = DAMAGE_ZERO
				end
			end
		end
	end
end

local HOOK_onMissionStart = function(mission)
	modApi:conditionalHook(
		function()
			return Board
		end,
		function()
			for id = 0, 2 do
				local pawn = Board:GetPawn(id)
				if pawn and pawn:IsAbility(pilot.Skill) then
					pawn:SetPushable(false)
				elseif pawn and _G[pawn:GetType()].Pushable == true then
					pawn:SetPushable(true)
				end
			end
		end
	)
end

local HOOK_onMissionEnd = function(mission)
	for id = 0, 2 do
		local pawn = Board:GetPawn(id)
		if pawn and pawn:IsAbility(pilot.Skill) then
			if _G[pawn:GetType()].Pushable == true then
				pawn:SetPushable(true)
			end
		end
	end
end

local HOOK_onSkillBuild = function(mission, pawn, weaponId, p1, p2, skillEffect)
	tatu_zeroDamage(pawn,skillEffect,false)
	tatu_zeroDamage(pawn,skillEffect,true)
end

local HOOK_onFinalEffectBuild = function(mission, pawn, weaponId, p1, p2, p3, skillEffect)
	tatu_zeroDamage(pawn,skillEffect,false)
	tatu_zeroDamage(pawn,skillEffect,true)
end

local function EVENT_onModsLoaded()
	--Add hooks here
	modapiext:addSkillBuildHook(HOOK_onSkillBuild)
	modapiext:addFinalEffectBuildHook(HOOK_onFinalEffectBuild)
	modApi:addMissionStartHook(HOOK_onMissionStart)
	modApi:addTestMechEnteredHook(HOOK_onMissionStart)
	modApi:addPostLoadGameHook(HOOK_onMissionStart)
	modApi:addMissionEndHook(HOOK_onMissionEnd)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

-------------
-- Dialogs --
-------------

-- barks
local pilot_dialog = {
    -- Game States
	Gamestart = {
		"Is this the real life? Is this just fantasy?",
		"Being inside the game is not as fun as playing it.",
	},
	FTL_Found = {
		"There it is, the thing from the other game!",
	},
	FTL_Start = {
		"And here it comes. There is an alien inside.",
	},
	Gamestart_PostVictory = {
		"Are you kidding me, why am I here again?",
	},
	Death_Revived = {
		"Oh, no there ain't no rest for the wicked. Until we close our eyes for good.",
		"Huh... I'm not dead! Oh wait, I'm not dead...",
	},
	Death_Main = {
		"I did it MYYYYY WAAAAAYYY!",
		"I don't wanna die! I sometimes wish I'd never been born at aaaaaaall!",
	},
	Death_Response = {
		"I know you are not real, but I'm still sad.",
	},
	Death_Response_AI = {
		"Off, 1 less mech. How many turns left again?",
	},
	TimeTravel_Win = {
		"Weeeeeeee are the champions, my friends!",
		"That was pretty cool, but I'm out of here. Don't pick me for your next run.",
	},
	Gameover_Start = {
		"That was a good try. Maybe choose another pilot for your next run.",
		"That's all folks, time to leave.",
	},
	Gameover_Response = {
		"Just gotta get out, just gotta get right outta here!",
		"Don't worry, It's just a game after all.",
	},
    
    -- UI Barks
	Upgrade_PowerWeapon = {
		"Oh, much better!",
		"That's what I'm talking about!",
	},
	Upgrade_NoWeapon = {
		"Hey, I need some weapons!",
	},
	Upgrade_PowerGeneric = {
		"POWER! UNLIMITED POWER!",
	},
    
    -- Mid-Battle
	MissionStart = {
		"Highway to the Dangerzone!",
		"Another happy landing.",
		"This is where the fun begins.",
	},
	Mission_ResetTurn = {
		"Deja vu! I just been in this place before!",
		"You can type undoturn in the console to do this again, just so you know.",
	},
	MissionEnd_Dead = {
		"We got all them. Terrific.",
	},
    MissionEnd_Retreat = {
		"So beat it, just beat it!",
	},

    PodIncoming = {
		"Incoming!",
		"Open your eyes, look up to the skies and see!",
	},
    PodResponse = {
		"I hope there's more than just a core inside.",
	},
    PodCollected_Self = {
		"We didn't really need to collect it, but better safe than sorry.",
	},
    PodDestroyed_Obs = {
		"And one less pod.",
		"There goes our extra power core.",
	},
    Secret_DeviceSeen_Mountain = {
		"Oh nice, you found the FTL pod.",
	},
    Secret_DeviceSeen_Ice = {
		"Oh nice, you found the FTL pod.",
	},
    Secret_DeviceUsed = {
		"Ground control to Major Tom.",
	},

    Secret_Arriving = {
		"An alien? It's an Alien!",
	},
    Emerge_Detected = {
		"It's close to miiiiiidnight, and something evil's lurking in the dark",
		"There's something strange... in your neighborhood.",
	},
    Emerge_Success = {
		"Master Skywalker, there are too many of them. What are we going to do?",
		"Who let the dogs out? Who, who, who, who, who?",
	},
    Emerge_FailedMech = {
		"Nope.",
		"You shall not pass!",
	},
    Emerge_FailedVek = {
		"Nope.",
	},

    -- Mech State
    Mech_LowHealth = {
		"I'm still standing, yeah yeah yeah!",
		"My back! Oooh! My back!",
	},
    Mech_Webbed = {
		"I want to break free!",
		"Oh, mamma mia, mamma mia! Mamma mia, let me go!",
	},
    Mech_Shielded = {
		"Who wants... to live... foreveeeeer.",
	},
    Mech_Repaired = {
		"Ah, ha, ha, ha, stayin' alive, stayin' alive!",
		"No, not I! I will survive!",
	},
    Pilot_Level_Self = {
		"It's +3 grid defense, isn't it?",
		"I wanna be the very best, like no one ever was!",
	},
    Pilot_Level_Obs = {
		"Congratulations, you deserve it!",
	},
    Mech_ShieldDown = {
		"Shield gone, carry on.",
	},

    -- Damage Done
    Vek_Drown = {
		"Under the sea! Under the sea! Darling it's better down where it's wetter, take it from me.",
	},
    Vek_Fall = {
		"I believe I can fly! I believe I can touch the sky!",
		"It's over Vek, I have the high ground!",
		"See ya, chump!",
	},
    Vek_Smoke = {
		"Smoke on the water, a fire in the sky.",
		"I'm gonna put some dirt in your eye.",
		"I don’t like sand. It’s coarse and rough and irritating, and it gets everywhere.",
	},
    Vek_Frozen = {
		"Vek ice cream.",
	},
    VekKilled_Self = {
		"Put a gun against his head, pulled my trigger, now he's dead.",
		"Stings, doesn't it?",
		"Say hello to my little friend!",
	},
    VekKilled_Obs = {
		"That still only counts as one!",
		"Well done, this will end in no time.",
	},
    VekKilled_Vek = {
		"And I think to myself, what a wonderful world.",
		"With friends like this...",
	},

    DoubleVekKill_Self = {
		"We will, we will rock you!",
		"And another one gone, and another one gone. Another one bites the dust!",
		"Hasta la vista, baby.",
	},
    DoubleVekKill_Obs = {
		"She's a Killer... Queeeen!",
		"That was impressive!",
	},
    DoubleVekKill_Vek = {
		"And another one gone, and another one gone, another one bites the dust!",
		"They are not very bright, are they?",
	},

    MntDestroyed_Self = {
		"Ain't no mountain high enough!",
	},
    MntDestroyed_Obs = {
		"Ain't no mountain high enough!",
	},
    MntDestroyed_Vek = {
		"Ain't no mountain high enough!",
	},

    PowerCritical = {
		"Take my hand, we'll make it I swear. Whoa oh, livin' on a prayer!",
		"Don't worry... about a thing. Cause every little thing... is gonna be alright!",
		"Yesterdaaaaaay. All my troubles seemed so far awaaaay!",
	},
    Bldg_Destroyed_Self = {
		"Whaaaat I've dooooone!",
		"Don't worry, they are not real people.",
	},
    Bldg_Destroyed_Obs = {
		"I see dead people.",
	},
    Bldg_Destroyed_Vek = {
		"Grid gone, carry on.",
	},
    Bldg_Resisted = {
		"All in all, it's just another brick in the wall.",
		"Be runnin' up that road, be runnin' up that hill, be runnin' up that building.",
	},
	
	-- Shared Mission Events
	Mission_Train_TrainStopped = {
		"You can still get 1 rep out of this.",
	},
	Mission_Train_TrainDestroyed = {
		"That's rough, buddy.",
	},
	-- Mission_Block_Reminder = {
		-- "Remember, keep the Vek in the dirt.",
		-- "Don't let them surface!",
	-- },
	
	-- Archive Mission Events
	Mission_Tanks_Activated = {
		"Finally! This should make things easier.",
	},
	Mission_Tanks_PartialActivated = {
		"Almost there!",
	},
	Mission_Satellite_Destroyed = {
		"Aaaand it's gone.",
	},
	Mission_Satellite_Imminent = {
		"It's almost ready!",
	},
	Mission_Satellite_Launch = {
		"Awesome. I've never seen a real launch up close!",
	},
	-- Mission_Dam_Reminder = {
		-- --"We still need to take out that dam.",
		-- "We still need to break open that dam and release the waters.",
		-- "The grass is looking a little dry here; better unleash that dam soon!",
	-- },
	Mission_Dam_Destroyed = {
		"Caught in a landslide, no escape from reality.",
	},
	Mission_Mines_Vek = {
		"That Vek disappeared.",
	},
	Mission_Airstrike_Incoming = {
		"Highway to the danger zone!",
	},
	
	-- R.S.T. Mission Events
	-- Mission_Force_Reminder = {
		-- --"Gotta clear those mountains or the Vek will infest them.",
		-- "We still have mountains to destroy; if we don't, I'm sure #ceo_full will have some extra paperwork for us to fill out explaining why.",
		-- "Can't leave those mountains standing for the Vek to turn into hives.",
	-- },
	Mission_Lightning_Strike_Vek = {
		"Thunderbolt and lightning, very, very frightening me!",
		"Oh, there is thunder in our hearts.",
	},
	Mission_Terraform_Destroyed = {
		"That's rough, buddy",
	},
	Mission_Terraform_Attacks = {
		"How does that thing work?",
	},
	Mission_Cataclysm_Falling = {
		"Caught in a landslide, no escape from reality.",
	},
	Mission_Solar_Destroyed = {
		"We are not getting paid after that.",
	},
	
	-- Pinnacle Mission Events
	BotKilled_Self = {
		"Another one bites the dust!",
		"Put a gun against his head, pulled my trigger, now he's dead.",
	},
	BotKilled_Obs = {
		"Another one bites the dust!",
	},
	Mission_Factory_Destroyed = {
		"We are not getting paid after that.",
		"That's rough, buddy",
	},
	Mission_Factory_Spawning = {
		"These aren't the droids you're looking for.",
	},
	Mission_Reactivation_Thawed = {
		"Here they come!",
	},
	Mission_Freeze_Mines_Vek = {
		"Deep beneath the cover of another perfect wonder where it's so white as snow",
	},
	Mission_SnowStorm_FrozenVek = {
		"Deep beneath the cover of another perfect wonder where it's so white as snow",
	},
	Mission_SnowStorm_FrozenMech = {
		"I'm really cold.",
		"Someone give me a blanket.",
	},
	
	-- Detritus Mission Events
	Mission_Barrels_Destroyed = {
		"+1 rep!",
	},
	Mission_Disposal_Destroyed = {
		"Oh that's bad.",
	},
	Mission_Disposal_Disposal = {
		"Woah-oh, woah I'm, radioactive, radioactive.",
		"Yes, very balanced.",
	},
	Mission_Power_Destroyed = {
		"Grid gone, carry on.",
	},
	Mission_Belt_Mech = {
		"Hahaha, very fun.",
	},
	Mission_Teleporter_Mech = {
		"Don't do this again, plase!",
		"Ugh... that was uncool.",
	},
	
	-- AE
	Mission_ACID_Storm_Start = {
		"I wanna know, have you ever seen the rain?",
		"Hey, this is ruining my mech's painting!",
	},	
	Mission_ACID_Storm_Clear = {
		"Here comes the sun.",
	},	
	Mission_Wind_Mech = {
		"Any way the wind blows doesn't really matter to me.",
	},	
	Mission_Repair_Start = {
		"It's a trap!",
	},	
	Mission_Hacking_NewFriend = {
		"Domo arigato, Mr. Roboto!",
	},	
	Mission_Shields_Down = {
		"Shields gone, carry on.",
	},
	
	-- Final
	MissionFinal_Start = {
		"One does no simply walk into a vek hive.",
	},
	MissionFinal_StartResponse = {
		"I have a bad feeling about this.",
		"Hello there!",
	},
	MissionFinal_FallResponse = {
		"Caught in a landslide, no escape from reality.",
		"I'm on the highway to hell!",
	},
	MissionFinal_Bomb = {
		"One does no simply walk into a vek hive.",
	},
	MissionFinal_CaveStart = {
		"It's the final countdown!",
	},
	MissionFinal_BombArmed = {
		"Guaranteed to blow your mind... Anytime!",
	},
}

-- create personality
local personality = CreatePilotPersonality("pilotpotluck_Tatu")
personality:AddDialogTable(pilot_dialog)

-- add our personality to the global personality table
Personality["pilotpotluck_Tatu"] = personality

return this
