
-- Adds a personality without the use of a csv file.
-- Table of responses to various triggers.
return {
	-- Game States
	Gamestart = {"Let's see what islands survived the flood this time.", "I can't wait to see which Vek species are exterminating humanity in this timeline.","Let us go then, you and I, when the evening is spread out against the sky..." },
	FTL_Found = {"'ET phone home'... was that specist?"},
	FTL_Start = {""},
	Gamestart_PostVictory = {"Every run, we learn more about the Vek... and about each other."},
	Death_Revived = {"...that was not fun."},
	Death_Main = {"Another me will pick up my burden.", "This is my retribution for making Vek stronger.", "The dread of dying, and being dead, flashes afresh to hold and horrify."},
	Death_Response = {"You fought well. Rest, now.", "His hanging face, like a devil’s sick of sin..."},
	Death_Response_AI = {"Good bot."},
	TimeTravel_Win = {"Farewell, friends. I hope to meet another one of you."},
	Gameover_Start = {"This timeline is a goner.", "Did we really give this our best?"},
	Gameover_Response = {"We can't save this timeline, but we may save the next one."},
	
	-- UI Barks
	Upgrade_PowerWeapon = {"Good. I hope the upgrade works as well.",},
	Upgrade_NoWeapon = {"I know I'm not useless unarmed, but at least give me something.", "When we disarmed they sold us and delivered us bound to our foe..."},
	Upgrade_PowerGeneric = {"Feels safer.",},
	
	-- Mid-Battle
	MissionStart = {"I mustn't run away... oh, who am I kidding.", "Let's go, team. We've got bugs to smash.", "Let's go, team. We've got a world to save."},
	Mission_ResetTurn = {"One more time... one more chance...", "So let us try again, for the very first time."},
	MissionEnd_Dead = {"Good, I needed the XP.", "The only dead Vek is a good Vek... no, that isn't right."},
	MissionEnd_Retreat = {"They'll be back, and in greater numbers.", "They might adapt to our weapons."},

	MissionFinal_Start = {"Thank god for air conditioned mechs. Wait, doesn't that require power?"},
	MissionFinal_StartResponse = {"Cool. Cool cool cool. So you're airdropping giant batteries? Have you checked the risks of explosion?"},
	MissionFinal_FallStart = {"I do not like falling aaaaaaaaaaaaaah."},
	MissionFinal_FallResponse = {"no no no no no I hate this part."},
	MissionFinal_Pylons = {"...actually, maybe the pylons exploding would help here."},
	MissionFinal_Bomb = {"Let's blow it up."},
	MissionFinal_BombResponse = {"Thanks for the bomb. Next time, maybe arm it during the drop? Just a thought."},
	MissionFinal_CaveStart = {"Fighting giant insects in a volcano next to a nuke. A perfect Sunday."},
	MissionFinal_BombDestroyed = {"...why doesn't it blow up harder? I should mod that in."},
	MissionFinal_BombArmed = {"Are we done? Let's breach out of here, the heat is killing me.", "At the end of our path a liquescent and nebulous lustre was born."},

	PodIncoming = {"Dibs on the core."},
	PodResponse = {"I hope there's a friend in there."},
	PodCollected_Self = {"Whoever's in there, you are safe... and conscripted."},
	PodDestroyed_Obs = {"Not in my top 10 best ways to die."},
	Secret_DeviceSeen_Mountain = {"Either this mountain is a shiny Pokemon or it drops rare loot."},
	Secret_DeviceSeen_Ice = {"Either this ice sheet is a shiny Pokemon or it drops rare loot."},
	Secret_DeviceUsed = {"Come on down!"},
	Secret_Arriving = {"Not the standard time pod model, is it? We should reverse engineer it."},
	Emerge_Detected = {"Through caverns measureless to man, down to a sunless sea."},
	Emerge_Success = {"Here they come. Let's check out how they work.", "And from this chasm, with ceaseless turmoil seething..."},
	Emerge_FailedMech = {"Hah! Maybe I should put on a few pounds."},
	Emerge_FailedVek = {"Not enough throughput on that. Vek are not great at engineering, are they?"},

	-- Mech State
	Mech_LowHealth = {"Bruh.", "As good a time as any to repair.", "Hear the loud alarum bells - Brazen bells! What tale of terror, now, their turbulency tells!", "I must not know fear, for fear is the mind-killer..."},
	Mech_Webbed = {"So sticky, yet sturdy. Brilliant material. We should use it!", "Reminds me of Worm."},
	Mech_Shielded = {"So how do these work, exactly?"},
	Mech_Repaired = {"Calm down already.", "This is possibly the worst repair job I've ever done, but I'm still alive to get yelled at.", "That we - in spite of being broken, because of being broken - may rise and build anew."},
	Pilot_Level_Self = {"My strength is in making others weaker... that doesn't sound very nice.", "The strength of Vek will pale before mine now... muahaha..."},
	Pilot_Level_Obs = {"Very good.", "I love seeing people learn.", "You're getting the hang of this!"},
	Mech_ShieldDown = {"Ah, well. Come at me!"},

	-- Damage Done
	Vek_Drown = {"Imagine being a starfish that can't swim."},
	Vek_Fall = {"I'm not looking down, but I'm pretty sure it's dead."},
	Vek_Smoke = {"Smoking is bad for you, kids."},
	Vek_Frozen = {"Chill!", "They're not attacking us anymore? That's cool."},
	VekKilled_Self = {"Give me that sweet, sweet XP, Vek.", "Die!" },
	VekKilled_Obs = {"Nice work, #main_first.", "Another kill for #main_first"},
	VekKilled_Vek = {"I love it.", "Bugs squashing themselves... a programmer's dream."},

	DoubleVekKill_Self = {"And this is what we call a pro gamer move.", "KI-AIIIIIII!"},
	DoubleVekKill_Obs = {"Nice one, #main_first!", "More!"},
	DoubleVekKill_Vek = {"Bugs squashing themselves... a programmer's dream."},

	MntDestroyed_Self = {},
	MntDestroyed_Obs = {},
	MntDestroyed_Vek = {},

	PowerCritical = {"Low battery!"},
	Bldg_Destroyed_Self = {"I'm sure I had a good reason for that."},
	Bldg_Destroyed_Obs = {"Why did you do that?"},
	Bldg_Destroyed_Vek = {"Bends the strong wall beneath the furious host.", "And the angels sob at vermin fangs in human gore imbued."},
	Bldg_Resisted = {"The people are safe. Let's not risk their lives again."},


	-- Shared Missions
	Mission_Train_TrainStopped = {"Aaand there goes the train."},
	Mission_Train_TrainDestroyed = {"Wouldn't have happened with a TGV."},
	Mission_Block_Reminder = {"Let's sit atop their tunnels."},

	-- Archive
	Mission_Airstrike_Incoming = {"You know what? Bomber pilots have it easy. There, I said it."},
	Mission_Tanks_Activated = {"Good luck, little tanks!"},
	Mission_Tanks_PartialActivated = {"Time to avenge your friend."},
	Mission_Dam_Reminder = {"Let's break the dam thing down."},
	Mission_Dam_Destroyed = {"Wash the dam Vek away!"},
	Mission_Satellite_Destroyed = {"What a shame."},
	Mission_Satellite_Imminent = {"Liftoff is imminent!"},
	Mission_Satellite_Launch = {"It's safe now.", "I will touch the sky...", "We have a liftoff."},
	Mission_Mines_Vek = {"Well, that was a freebie."},

	-- RST
	Mission_Terraform_Destroyed = {"That machine was pretty great; what a shame."},
	Mission_Terraform_Attacks = {"Careful!"},
	Mission_Cataclysm_Falling = {"Turning yet further into Swiss cheese."},
	Mission_Lightning_Strike_Vek = {"Looks lethal.", "Timelines if the lightning squad could do lightning:"},
	Mission_Solar_Destroyed = {"That power would have been useful."},
	Mission_Force_Reminder = {"I-... Force reminder? What the hell is a \"force reminder?\""},

	-- Pinnacle
	Mission_Freeze_Mines_Vek = {"How does cryotech even work?"},
	Mission_Factory_Destroyed = {"Whatever. Zenith is going to complain either way."},
	Mission_Factory_Spawning = {"Ugh. Generic is the only pilot to find these cute. Let's break them down."},
	Mission_Reactivation_Thawed = {"I guess it's done rebooting."},
	Mission_SnowStorm_FrozenVek = {"Nice. Let's leave it there."},
	Mission_SnowStorm_FrozenMech = {"Time for some actually friendly fire."},
	BotKilled_Self = {"Oh no, the bot is dead. Maybe they should have made backups.", "Easy as pressing Ctrl+Shift+Del."},
	BotKilled_Obs = {"I just don't care about bots. Does that make me specist?"},

	-- Detritus
	Mission_Disposal_Destroyed = {"Noooo! Disposal Unit!", "Damn."},
	Mission_Disposal_Activated = {"Melt them down! Yay! Again! ...ahem."},
	Mission_Barrels_Destroyed = {"We need a ranged mech that just throws these everywhere."},
	Mission_Power_Destroyed = {"We needed that power."},
	Mission_Teleporter_Mech = {"Am I the real me, or just a copy? This was weird enough with timelines..."},
	Mission_Belt_Mech = {"Ever heard of Roborally?"},
}