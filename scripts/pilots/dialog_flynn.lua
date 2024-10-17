
-- Adds a personality without the use of a csv file.
-- Table of responses to various triggers.
return {
	-- Game States
	Gamestart = {"Let's get cracking.","Heaven or hell... Let's rock!"},
	FTL_Found = {"Should I say something meta?","If you ask me, this is the better game."},
	FTL_Start = {"This message should not appear... Just kidding!"},
	Gamestart_PostVictory = {"Once more... into the breach!","I've done it once before, how bad can it be?"},
	Death_Revived = {"All a part of the plan!","I'm baaaack!"},
	Death_Main = {"I'll be back.","Well, y'know what they say. Greed always pays of-*static*","Such is the fate of the Fool..."},
	Death_Response = {"Was that one tactical?","All a part of the plan...?"},
	Death_Response_AI = {"I sure hope it's turn 5. Or 4, if it's a train mission. But you wouldn't pick a train mission, would you?","He died doing his job: dying, so we know where the aliens are."},
	TimeTravel_Win = {"Another day, another victory!","I hope to see you again!"},
	Gameover_Start = {"Ah, this one must be on me...!","It's just like Jelt..."},
	Gameover_Response = {"We're going for take two!","Let's do the time warp again!"},
	
	-- UI Barks
	Upgrade_PowerWeapon = {"Ooh, shiny!","The cost of preparedness, measured now in power cores... later in grid.",},
	Upgrade_NoWeapon = {"A challenge? Very well!","This... has turned into a difficult situation.","This can't end well."},
	Upgrade_PowerGeneric = {"Ooh, shiny!","The cost of preparedness, measured now in power cores... later in grid.",},
	
	-- Mid-Battle
	MissionStart = {"Time to motor!","Let's rock!","Hoping there are no digging Vek."},
	Mission_ResetTurn = {"Don't worry. I won't tell a soul.","Getting abilities to trigger off this is surprisingly finicky."},
	MissionEnd_Dead = {"Style points!","A glorious victory!","Always feels good to get a full wipe."},
	MissionEnd_Retreat = {"Quiver in fear!","Well done, ladies and gents!"},

	MissionFinal_Start = {"If anyone asks, we've only done two islands.","Why does every video game have lava in it?"},
	MissionFinal_StartResponse = {"At least this won't ruin a 40k run!"},
	MissionFinal_FallStart = {"Onto the next!"},
	MissionFinal_FallResponse = {"Wheee~...!"},
	MissionFinal_Pylons = {"Spare a few more pylons?"},
	MissionFinal_Bomb = {"You guys remember when Kern was mandatory because of this?"},
	MissionFinal_BombResponse = {"They never target this thing when you really wish they would."},
	MissionFinal_CaveStart = {"Is it night? I'm told we shouldn't mine at night."},
	MissionFinal_BombDestroyed = {"It's only a two-turn delay, how bad can it be?"},
	MissionFinal_BombArmed = {"Hey, you on the other side. Did you find what you were looking for?"},

	PodIncoming = {"Ah, good, I could use a hand.","Is another wizard in there?"},
	PodResponse = {"Ah, good, I could use a hand.","There might be another wizard in there!"},
	PodCollected_Self = {"Sorry to keep you waiting.","So... would you happen to be an artist?"},
	PodDestroyed_Obs = {"Stock assets it is...","Can we reset for that?"},
	Secret_DeviceSeen_Mountain = {"Should I spoil the surprise?","There's an FTL pilot here, if you're looking for one."},
	Secret_DeviceSeen_Ice = {"Should I spoil the surprise?","There's an FTL pilot here, if you're looking for one."},
	Secret_DeviceUsed = {"Come on down!"},
	Secret_Arriving = {"Do you think FTL takes place in the same timeline?"},
	Emerge_Detected = {"More on their way"},
	Emerge_Success = {"Bringing the party to us!"},
	Emerge_FailedMech = {"This is gonna start hurting soon...","Locked down!"},
	Emerge_FailedVek = {"Very nice!","Frankly brilliant."},

	-- Mech State
	Mech_LowHealth = {"This... can't end well.","All a part of the plan...!"},
	Mech_Webbed = {"Impending doom approaches...!"},
	Mech_Shielded = {"Nice to have some breathing room."},
	Mech_Repaired = {"Up and running!","I assure you, this mech is fully operational!"},
	Pilot_Level_Self = {"Please not Popular Hero...","Y'know what would be funny? If you made an entire squad full of +3 Grid Defense.","I just keep getting better and better."},
	Pilot_Level_Obs = {"Good stuff, #main_first!","Another job well done, it seems!"},
	Mech_ShieldDown = {"Well, I that is what it's for.","Exposed to a killing blow..."},

	-- Damage Done
	Vek_Drown = {"It's not coming back from there."},
	Vek_Fall = {"Wheee~..."},
	Vek_Smoke = {"I've always been partial to the Hulks.","Sssssmokin'!"},
	Vek_Frozen = {"They're not going anywhere.","Check out this awesome move!"},
	VekKilled_Self = {"Another one's dead.", "One shot, one kill. I hope.", "DOWN!"},
	VekKilled_Obs = {"Nice work, #main_first.", "Another kill for #main_first"},
	VekKilled_Vek = {"Bugs squishing other bugs.", "A brilliant confluence of skill and purpose!"},

	DoubleVekKill_Self = {"Well? Did you expect anything less?", "A singular strike!"},
	DoubleVekKill_Obs = {"Absolutely brilliant, #main_first!", "Burn brightly, #main_first!"},
	DoubleVekKill_Vek = {"Now that was a sight to see.", "Two for... zero, I guess!"},

	MntDestroyed_Self = {"Rock and stone!"},
	MntDestroyed_Obs = {"Rock and stone in the heart!"},
	MntDestroyed_Vek = {"Did I hear a rock and stone?"},

	PowerCritical = {"All a part of the plan! Again!"},
	Bldg_Destroyed_Self = {"Look, look, I've got a plan, okay??"},
	Bldg_Destroyed_Obs = {"Y'know, a pilot that benefits from destroyed buildings sounds kinda cool."},
	Bldg_Destroyed_Vek = {"We're just letting that go? I mean, you're in charge."},
	Bldg_Resisted = {"See? Always trust."},


	-- Shared Missions
	Mission_Train_TrainStopped = {"Train's clogged up!"},
	Mission_Train_TrainDestroyed = {"Really, you did this one to yourself, picking a train mission."},
	Mission_Block_Reminder = {"Something's in the way, it's blocked."},

	-- Archive
	Mission_Airstrike_Incoming = {"Why don't we have a mech that can do this?","I shudder to think of a bomber Vek..."},
	Mission_Tanks_Activated = {"Things should be a little easier now!"},
	Mission_Tanks_PartialActivated = {"Things should be a little easier now!"},
	Mission_Dam_Reminder = {"That dam's gotta go!"},
	Mission_Dam_Destroyed = {"Shout! Let it all out!"},
	Mission_Satellite_Destroyed = {"Well, so much for the perfect island."},
	Mission_Satellite_Imminent = {"Think we can get a four-piece this time?","Satellite's prepped and ready!"},
	Mission_Satellite_Launch = {"Up and away!","Ever think about building a tungsten death station?"},
	Mission_Mines_Vek = {"Arrivederci!","A lucky break!"},

	-- RST
	Mission_Terraform_Destroyed = {"Terraformer's down!"},
	Mission_Terraform_Attacks = {"Keep an eye on the terraformer!"},
	Mission_Cataclysm_Falling = {"So we can survive the fall in the volcano, but not this one? Hardly fair.","Wonder what's down there."},
	Mission_Lightning_Strike_Vek = {"Kaboom, baby!","Ok, so hear me out, we set up a lightning rod..."},
	Mission_Solar_Destroyed = {"I always liked steam power more anyway."},
	Mission_Force_Reminder = {"I-... Force reminder? What the hell is a \"force reminder?\""},

	-- Pinnacle
	Mission_Freeze_Mines_Vek = {"And so the map gets further clogged...","That bug's on ice."},
	Mission_Factory_Destroyed = {"Well, at least there's less robots.","Weren't we supposed to protect these?"},
	Mission_Factory_Spawning = {"It's making more little fellas!","More bots incoming!"},
	Mission_Reactivation_Thawed = {"It's out of the ice!"},
	Mission_SnowStorm_FrozenVek = {"One less to worry about.","Don't tell anyone, but I can never remember if this affects the spawn rate."},
	Mission_SnowStorm_FrozenMech = {"If this is planned, its genius.","We've got a frozen comrade!"},
	BotKilled_Self = {"Okay, if anyone asks, there was nothing we could do.","Look, I chose the grid, okay?"},
	BotKilled_Obs = {"Killing robots just isn't as fun as Vek.","This feels... wrong. Aren't we supposed to kill bugs?"},

	-- Detritus
	Mission_Disposal_Destroyed = {"The disposal's gone!","So much for that."},
	Mission_Disposal_Activated = {"Kaboom, baby!","I love this thing."},
	Mission_Barrels_Destroyed = {"Poof!","Another one down!"},
	Mission_Power_Destroyed = {"Ah. Crumbs."},
	Mission_Teleporter_Mech = {"Hang on, lemme-... Yep, all limbs accounted for!","If you think space is cool, try traveling through time!"},
	Mission_Belt_Mech = {"I could be playing Factorio right now...","This never gets old.","Reminds me of Jelt."},
}