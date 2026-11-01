
-- Adds a personality without the use of a csv file.
-- Table of responses to various triggers.
return {
	Enfeeble = {"Calm down a bit.", "Stop that.", "Behave.", "And what do you think you are doing?", "Quiet."},
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
	Mech_Shielded = {"So how do these work, exactly?", "So it's not the Dune kind of shield where you can only pass through at low kinetic energy...", "It's not the Rimworld kind of shield where you can't shoot from inside..."},
	Mech_Repaired = {"Calm down already.", "This is possibly the worst repair job I've ever done, but I'm still alive to get yelled at.", "That we - in spite of being broken, because of being broken - may rise and build anew."},
	Pilot_Level_Self = {"My strength is in making others weaker... that doesn't sound very nice.", "The strength of Vek will pale before mine now... muahaha..."},
	Pilot_Level_Obs = {"Very good.", "I love seeing people learn.", "You're getting the hang of this!"},
	Mech_ShieldDown = {"Ah, well. Come at me!"},

	-- Damage Done
	Vek_Drown = {"Imagine being a starfish that can't swim.", "I relate, little Vek. Drowning is not fun."},
	Vek_Fall = {"I'm not looking down, but I'm pretty sure it's dead.", "Into the pit with you."},
	Vek_Smoke = {"Smoking is bad for you, kids.", "We get it, you vape. Hah!"},
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
	Mission_Belt_Mech = {"Ever heard of Roborally? It was my wife's favorite game, before... well, before all this."},
	
	-- AE
	Mission_ACID_Storm_Start = {"How dreary. Abrasive and ugly - reminds me of my mother."},
	Mission_ACID_Storm_Clear = {"Finally, this mephitic downpour abates."},
	Mission_Wind_Mech = {"Ah, my favorite weather.", "Isn't there something fun about being pushed around by the wind? Makes you appreciate nature."},
	Mission_Repair_Start = {"I'd hoped for better from Archive - but I expected as much."},
	Mission_Hacking_NewFriend = {"I'm sure Generic would be thrilled."},
	Mission_Shields_Down = {"Time to go on the offensive."},

	-- Meridia
	Mission_lmn_Convoy_Destroyed = {"I feel bad. Driving through a warzone to deliver supplies - they're heroes."},
	Mission_lmn_FlashFlood_Flood = {"Oh, time for a bath?... Seriously though, I could go for a hot spring trip."},
	Mission_lmn_Geyser_Launch_Mech = {"Oh god no no no no I hate heights"},
	Mission_lmn_Geyser_Launch_Vek = {"Well, that was a freebie."},
	Mission_lmn_Volcanic_Vent_Erupt_Vek = {"Spectacular!"},
	Mission_lmn_Wind_Push = {"Ah, my favorite weather.", "Isn't there something fun about being pushed around by the wind? Makes you appreciate nature."},
	Mission_lmn_Runway_Imminent = {"Let's get out of the way."},
	Mission_lmn_Runway_Crashed = {"I'm sorry, fellow pilot."},
	Mission_lmn_Runway_Takeoff = {"Godspeed."},
	Mission_lmn_Greenhouse_Destroyed = {"I... I don't care. Never been one for flowers."},
	Mission_lmn_Geothermal_Plant_Destroyed = {"A marvel of engineering, gone. What a tragedy."},
	Mission_lmn_Hotel_Destroyed = {"These poor people..."},
	Mission_lmn_Agroforest_Destroyed = {"They should have sent a botanist."},

	-- Watchtower missions
	Mission_tosx_Sonic_Destroyed = {"...Well, at least the noise is gone."},
	Mission_tosx_Tanker_Destroyed = {"The water supply's gone. People are going to die."},
	Mission_tosx_Rig_Destroyed = {"Pro tip: in a Mad Max-scenario, don't do cars with spikes, do technicals."},
	Mission_tosx_GuidedKill = {"Guided missiles: finally, pathfinding that works the first time."},
	Mission_tosx_NuclearSpread = {"I didn't realize I was terrified of radiation before.", "The silent death... the ruination of your body's blueprints...", "Losing what you are, cell by cell, strand by strand of DNA..."},
	Mission_tosx_RaceReminder = {"This is not the Mario Kart I remember. ...My brother, gone. Forever."},
	Mission_tosx_MercsPaid = {"I'm not sure they should be worried about money. The world is ending. They're like merchants in RPGs."},
	Mission_tosx_RigUpgraded = {"That guy works fast. Can we poach him?"},
	--FarLine barks
	Mission_tosx_Delivery_Destroyed = {"Packet lost. Shame this delivery contained actual supplies."},
	Mission_tosx_Sub_Destroyed = {"Water, water, every where, nor any drop to drink.", "I hope they had a quick death."},
	Mission_tosx_Buoy_Destroyed = {"Shame."},
	Mission_tosx_Rigship_Destroyed = {"There goes the floor. I really don't want to swim."},
	Mission_tosx_SpillwayOpen = {"Spillway's open. Good. I'd rather control where the water goes than be in it."},
	Mission_tosx_OceanStart = {"7.8/10, way too much water."},
	Mission_tosx_RTrain_Destroyed = {},
	
	--Nautilus
	Mission_Nautilus_CrumblingReaction = {"Oh I don't want to get close to that."},
	Mission_Nautilus_ExcavatorDestroyed = {"Such a cool machine. What a shame."},
	Mission_Nautilus_DrillerDestroyed = {"This was the drill that was to pierce the heavens..."},
	Mission_Nautilus_BlastChargeDestroyed = {"Not with a bang, but a whimper."},
	Mission_Nautilus_BlastChargeExploded = {"I want a Blast Charge Launcher weapon now."},
	Mission_Nautilus_RailLayerDamaged = {"Subterranean rail system... Isn't that a subway? No subway for them."},
	Mission_Nautilus_RailLayerDestroyed = {"Well, they're not getting this one back up anytime soon."},

	-- Island missions
	Mission_tosx_Juggernaut_Destroyed = {"Oh."},
	Mission_tosx_Juggernaut_Ram = {"The more warfare evolves, the more it stays the same... Warhounds turned to drones; arrows to bullets; armor to mechsuits; rams to juggernauts."},
	Mission_tosx_Zapper_On = {"My brother hated mosquitoes. He had a machine to attract and zap them. ...I miss you."},
	Mission_tosx_Zapper_Destroyed = {"Shame. Though with this much electricity, a point-defense laser..."},
	Mission_tosx_Warper_Destroyed = {"I can't bring myself to trust teleporters. Still, a shame."},
	Mission_tosx_Battleship_Destroyed = {"It's like the Yamato."},
	Mission_tosx_Siege_Now = {"Ambushed by foul invention!"},
	Mission_tosx_Plague_Spread = {"Disgusting.", "Biological warfare, now?"},

	--Machin's Missions
	Mission_Machin_Botbuddy_Destroyed = {"Hm."},
	Mission_Machin_Botbuddy_Trained = {"That's a fast learner if I ever saw one."},
	Mission_Machin_Fuel_Delivered = {"Who doesn't like lasers?"},
	Mission_Machin_Radio_Destroyed = {"Ah, shame."},
	Mission_Machin_Laser_Array_Destroyed = {"No! It was so cool!"},
	Mission_Machin_Warhead_Destroyed = {"Good, one less death threat to worry about."},
	
	--Karto's Missions
	kf_Env_Wildfire_BldgDanger = {"These people are... Wait, why do we care? Buildings survive fire all the time. ...Should I mod that in?"},
	kf_Env_Wildfire_Spreading = {"Scary. At least we can outrun it."},
}