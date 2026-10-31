
-- Adds a personality without the use of a csv file.
-- Table of responses to various triggers.
return {
	-- Game States
	--Gamestart = {"Ready to roll out!","Just like the simulations."}, --these lines were references I like, but out of my character imo
	Gamestart = {"These people have suffered a lot. But they don't know the worst has yet to come.", "There's no fate but what we make for ourselves.", "The journey begins..."},
	FTL_Found = {"The fu... what is that thing?","I don't trust... \"it\""},
	FTL_Start = {"What in the hell?"},
	Gamestart_PostVictory = {"Oh shit, here we go again.","They see us as saviors. We must not fail them."},
	Death_Revived = {"We only die twice.","They should have double tapped!"},
	Death_Main = {"Farewell... my friends...","It's over for me... Give them hell!","Tell m-- *static*","I thought I fought thoroughly throughout though...","Delete my browser history."},
	Death_Response = {"#main_second is not responding!"},
	Death_Response_AI = {"It fought with us honorably, even though honor is a foreign concept to them."},
	TimeTravel_Win = {"No, no, no! I want to stay here! Let me sta-- *static*"},
	Gameover_Start = {"This war was lost long ago..."},
	Gameover_Response = {"#main, out."},
	
	-- UI Barks
	Upgrade_PowerWeapon = {"Weew, shiny!"},
	Upgrade_NoWeapon = {"Oh. Okay...", "I can still shout at them I guess..."},
	Upgrade_PowerGeneric = {"Pas mal non ? C'est français.", "Thank God for cold fusion! *opens a beer*"},
	
	-- Mid-Battle
	MissionStart = {"They told me I'd pilot drones...", "Why can't we pilot the Mechs remotly?", "#squad - 01, Engage!", "Cavalry has arrived!"},
	Mission_ResetTurn = {"I won't judge you if you used 'undoturn' command.", "Comme un air de \"Deja vu\"."},
	MissionEnd_Dead = {"I... I think we wiped them all!"},
	MissionEnd_Retreat = {"We couldn't wipe them all."},

	MissionFinal_Start = {"It's time.", "Let's do better than Klendathu's drop, shall we?"},
	MissionFinal_StartResponse = {"Hey Aldaris, we built your freaking pylons!"},
	MissionFinal_FallStart = {"Dafuck?"},
	MissionFinal_FallResponse = {"Oh nonononono..."},
	MissionFinal_Pylons = {"Hey Aldaris, we built your freaking pylons!"},
	MissionFinal_Bomb = {"I love the optimism of the team, but aren't we a bit underpowered to bring down a whole underground hive?"},
	MissionFinal_BombResponse = {"Okay, now we are talking!"},
	MissionFinal_CaveStart = {"I hope Renfield has put enough boom for the big kaboom."},
	MissionFinal_BombDestroyed = {"Uh oh. We have other bombs, right?"},
	MissionFinal_BombArmed = {"Do we have an evac'?"},

	PodIncoming = {"Detecting object coming in hot! It's... it comes from a different timeline!"},
	PodResponse = {"Oh, I remember being in one of those. Not comfortable. Let's rescue whatever remains inside."},
	PodCollected_Self = {"I got you little fellow.", "My turn to be the saviour!","Congratulations, you are being rescued! Please do not resist.","Come with me if you want to live."},
	PodDestroyed_Obs = {"This hurts so bad. There was maybe someone inside still alive with the stories of a timeline. It's now lost to meander of time."},
	Secret_DeviceSeen_Mountain = {"Hey, take a look. There's... something shiny there."},
	Secret_DeviceSeen_Ice = {"I-cy something there. Got it? \"I-see\"! Ahem, let's proceed..."},
	Secret_DeviceUsed = {"Listen, this was VERY tempting to click on this."},
	Secret_Arriving = {"It's a Bird... It's a Plane... It's a Pod!"},
	Emerge_Detected = {"Incomiiiing!", "Contact!"},
	Emerge_Success = {"Here they are. You know what to do."},
	Emerge_FailedMech = {"This bastard made me spill my beer!"},
	Emerge_FailedVek = {"This was funny."},

	-- Mech State
	Mech_LowHealth = {"My #self_mech's is screaming its pain at me!"},
	Mech_Webbed = {"That's why Camila rocks!","Eww"},
	Mech_Shielded = {"Exterior world looks funny from within a shield."},
	Mech_Repaired = {"Red lights and annoying beeps stopped. About time."},
	Pilot_Level_Self = {"I'm not sure I deserve this promotion, but I guess when this mess is all over, I'll enjoy a quiet retirement.","Nice. Uh, are we rotated out when we reach some veterancy? No? Okay."},
	Pilot_Level_Obs = {"Well done, #main_first. But don't get cocky."},
	Mech_ShieldDown = {"Oof, shield absorbed this shot."},

	-- Damage Done
	Vek_Drown = {"Water' you doing?"},
	Vek_Fall = {"The bigger they are, the harder they fall! (or something along those lines?)"},
	Vek_Smoke = {"I'm gonna call this one Snoop Vek."},
	Vek_Frozen = {"It's crazy that they survive such extreme temperatures..."},
	VekKilled_Self = {"I'm just getting started!"},
	VekKilled_Obs = {"Good kill!"},
	VekKilled_Vek = {"Get Vekt!"},

	DoubleVekKill_Self = {"That was entertaining! I hope I wasn't distracted from something more important..."},
	DoubleVekKill_Obs = {"D-D-D-OUBLE KILL!", "#main_second just bagged two Bandits!"},
	DoubleVekKill_Vek = {"Wait what?"},

	MntDestroyed_Self = {"Wh... Did I do that?"},
	MntDestroyed_Obs = {"I sensed the shock from here!"},
	MntDestroyed_Vek = {"This is a bit frightening.", "Wow."},

	PowerCritical = {"This is not good."},
	Bldg_Destroyed_Self = {"I'm gonna need to drink a bit more to forget that...","What have I done..."},
	Bldg_Destroyed_Obs = {"I saw this guy jumping from the window. This gonna haunt my nightmares."},
	Bldg_Destroyed_Vek = {"I think I knew the people that lived here from another timeline."},
	Bldg_Resisted = {"Let's not test our luck too much..."},

	-- Shared Missions
	Mission_Train_TrainStopped = {"Uh oh, train will be delayed..."},
	Mission_Train_TrainDestroyed = {"The TGV has been destroyed. We lost a fine piece of engineering."},
	Mission_Block_Reminder = {"Not my intention to backseat, but we need to block the Vek before they emerge."},

	-- Archive
	Mission_Airstrike_Incoming = {"In comiiiing!"},
	Mission_Tanks_Activated = {"Reinforcements have arrived!"},
	Mission_Tanks_PartialActivated = {"Let's make the surviving one count!"},
	Mission_Dam_Reminder = {"Dam it! We need to focus the damn dam!"},
	Mission_Dam_Destroyed = {"That reminds me of a mission in Command and Conquer Generals."},
	Mission_Satellite_Destroyed = {"We just lost our intelligence gathering tool."},
	Mission_Satellite_Imminent = {"Watch out, 'Argus V' is preparing for launch!"},
	Mission_Satellite_Launch = {"It escaped to the one place that hasn't been consumed by the Vek...\nSPACE!!!","What a magnificient sight.","I switched to Archive's frequency to hear the cheers of their engineering team.\nFeels good."},
	Mission_Mines_Vek = {"I got some Vek flesh and blood on my Mech!", "It's not a warcrime if it hurts Vek."},

	-- RST
	Mission_Terraform_Destroyed = {"Terraformer has been terraformed."},
	Mission_Terraform_Attacks = {"Better stay afar from that thing."},
	Mission_Cataclysm_Falling = {"WOW-WOW-WOW! That de-escalated quickly!"},
	Mission_Lightning_Strike_Vek = {"That Vek got smited!"},
	Mission_Solar_Destroyed = {"Civilians will suffer strict energy restrictions after this..."},
	Mission_Force_Reminder = {"The Commander asked us to destroy the mountains. Wait, we can destroy mountains?"},

	-- Pinnacle
	Mission_Freeze_Mines_Vek = {"(N)ice!"},
	Mission_Factory_Destroyed = {"This is bad but at the same time, I'm relieved, to be honest."},
	Mission_Factory_Spawning = {"Traitors..."},
	Mission_Reactivation_Thawed = {"Whaaa... they can free themselves from ice?!"},
	Mission_SnowStorm_FrozenVek = {"I'm cool with this one!"},
	Mission_SnowStorm_FrozenMech = {"The war has gone cold!"},
	BotKilled_Self = {"I've destroyed that backstabber S.O.B. and I'm not sorry."},
	BotKilled_Obs = {"It got a-BOT-litared!"},

	-- Detritus
	Mission_Disposal_Destroyed = {"Crap, the launcher is scrap now!"},
	Mission_Disposal_Activated = {"This is both satisfying to witness, and a bit disgusting."},
	Mission_Barrels_Destroyed = {"Beware of not being splashed by the A.C.I.D. coming from it!"},
	Mission_Power_Destroyed = {"Power plant is now a memory from a better past. We need to minimize the damage to the Grid!"},
	Mission_Teleporter_Mech = {"Weew, that was... something. Let me check if my sensors are recalibrated.", "Am I still me? Or a shallow copy of a now forever gone person?"},
	Mission_Belt_Mech = {"I'm moonwalking!","Wow, easy now.","I'm not really a good dancer.","Ain't good, I've the legs' coordination of a toddler!"},

	-- Advanced Edition
	Mission_ACID_Storm_Start = {"How can people live in such conditions?"},
	Mission_ACID_Storm_Clear = {"I see... a green \"rainbow\"? I'm not sure how to feel about it.","That's a relief. But our job here isn't done yet."},
	Mission_Wind_Mech = {"I see... a green rainbow? I'm not sure how to feel about it."},
	Mission_Repair_Start = {"You know, I like Archive's people. But sometimes, their amateurism is borderline criminal."},
	Mission_Hacking_NewFriend = {"I still don't trust this traitorous tin can.","Welcome aboard, to our boat that you should have never left. Bast-- *static*"},
	Mission_Shields_Down = {"Pinnacle is no longer shielding our enemies."},

	-- Lemonymous
	Mission_lmn_Convoy_Destroyed = {"Poor convoy trucks, they didn't stand a chance."},
	Mission_lmn_FlashFlood_Flood = {"Is this water damage?"},
	Mission_lmn_Geyser_Launch_Mech = {"Woooo --- oooaaAAAAh!"},
	Mission_lmn_Geyser_Launch_Vek = {"Strike!","Oh boy, that ejected quickly!","See you later, loser!"},
	Mission_lmn_Volcanic_Vent_Erupt_Vek = {"The floor is lava!"},
	Mission_lmn_Wind_Push = {"Le vent se lève ! Il faut tenter de vivre !", "Le vent l'emportera !"},
	Mission_lmn_Runway_Imminent = {"Clear the runway!"},
	Mission_lmn_Runway_Crashed = {"I have no idea how we gonna tell that to #ceo_last.","This pilot. He was part of #ceo_first's family..."},
	Mission_lmn_Runway_Takeoff = {"Does the color of the sky mean anything special to you? It does to me. A hell of a lot."},
	Mission_lmn_Greenhouse_Destroyed = {"I... hope we'll figure out fast how to use Vek's remains to create food and fuel. Otherwise, we are screwed."},
	Mission_lmn_Geothermal_Plant_Destroyed = {"I just saw most of the lights of the nearby buildings going off. They rerouted all the remaining energy to our Mechs."},
	Mission_lmn_Hotel_Destroyed = {"I shouldn't have switched to their communications' channels. The screams. I... need to drink after this mission."},
	Mission_lmn_Agroforest_Destroyed = {"I can't bear to watch. People, animals, trees. There's nothing left."},

	-- tosx
	Mission_tosx_Juggernaut_Destroyed = {"For once, we had a reliable robot ally. It's gone now, along with a tons of other sentient victims."},
	Mission_tosx_Juggernaut_Ram = {"BAH. RAM. YOU."},
	Mission_tosx_Zapper_On = {"I'm glad Mechs are properly insulated.","Just grilled some auxiliary systems, but this is worth it!"},
	Mission_tosx_Zapper_Destroyed = {"That tesla coil, I mean storm tower has been destroyed!"},
	Mission_tosx_Warper_Destroyed = {"The aircraft handling the portals has been shot down!","I don't think the crew survived the impact..."},
	Mission_tosx_Battleship_Destroyed = {"We lost another piece of our glorious past.","The crew fought to the end, but this antiquity stood no chance against these fast and vicious giant bugs."},
	Mission_tosx_Siege_Now = {"They are coming from all directions. You know what that means? We can fire in all directions!"},
	Mission_tosx_Plague_Spread = {"Vek are very imaginative to be obnoxious pest. Let's not approach to close this... thing."},
	Mission_tosx_NuclearGray = {"WTF"},
	Mission_tosx_Sonic_Destroyed = {"Good news: no more tinnitus.\nBad news: we lost a very effective tool."},
	Mission_tosx_Tanker_Destroyed = {"How long can a human survive without water, again? Better win that war before that."},
	Mission_tosx_Rig_Destroyed = {"I met the crew earlier. I shouldn't attach myself too much to people while the war is still going."},
	Mission_tosx_GuidedKill = {"Watchtower's people might be harsher than most other Corpos', but they sure are reliable for warfare."},
	Mission_tosx_NuclearSpread = {"Our Mechs should protect us from most radiations, but what about the people down there?"},
	Mission_tosx_RaceReminder = {"I know people's moral is important, but are we really doing the right thing?","This whole operation... it feels wrong."},
	Mission_tosx_MercsPaid = {"These... \"people\" ask us to pay them while we are risking our lives to save other people's lives.\nThese greedy vultures better be worth it."},
	Mission_tosx_RigUpgraded = {"It's in these times of struggles that humanity's creativity shines.","It's not pretty looking, but this is a badass expression of humanity's fighting spirit!"},
	Mission_tosx_Delivery_Destroyed = {"What was in the box??","Well, uh, we'll have to do without these supplies, whatever they were."},
	Mission_tosx_Sub_Destroyed = {"Uh, is the sub supposed to go so deep underwater?","We lost contact with the crew. Chances of survival close to 0."},
	Mission_tosx_Buoy_Destroyed = {"Oh buoy...","Well, we better ask Archive to use their satellite to compensate that loss to #corp's navigation systems."},
	Mission_tosx_Rigship_Destroyed = {"The construction ship has sunk, in a deafening noise of the twisting hull.\nAt least we're not hearing the screams of the dying innoncents..."},
	Mission_tosx_SpillwayOpen = {"We are creating a waterpark, aren't we?"},
	Mission_tosx_OceanStart = {"Oof, I hope there's no giant underwater Vek monstrosity.","Did we deploy at the right place? Our Mechs can hardly fight here!"},

	Mission_tosx_Scoutship_Destroyed = {"The blimp is down! The blimp is down!"},
	Mission_tosx_Beamtank_Destroyed = {"No more Jean-Michelle Jarre show."},
	Mission_tosx_Phoenix_Destroyed = {"This project was one of our best hope..."},
	Mission_tosx_Exosuit_Destroyed = {"I didn't even had the time to meet the pilot. I'll try next timeline to save them..."},
	Mission_tosx_Retracter_Destroyed = {"Hope is as fragile as these antenna. But we need to continue the fight."},
	Mission_tosx_Halcyte_Destroyed = {"I'll collect some of these shards after the mission, for my... collection."},
	Mission_tosx_Retracting = {"Okay, the antenna should be retracting. Let's protect it!", "I hope that's what we were supposed to do with these..."},
	Mission_tosx_MeltingDown = {"If we don't destroy this thing, Chernobyl will be outshined by its meltdown!"},
	Mission_tosx_CrysGrowth = {"They are not rocks, they are crystals!", "Who said \"Not enough minerals\"?!"},

	-- Truelch custom dialogs
	--Archive
	Truelch_Airstrike_Requested = {"Archive's command? Truelch here, requesting immediate Close Air Support!"},
	Truelch_Airstrike_Incoming = {"I hope they remembered the lesson I taught them about fire control systems."},

	--RST
	Truelch_Trap_Requested = {"CEO Kern, you may send in your demolition team, the building has been evacuated!"},
	Truelch_Trap_Incoming = {"I hate sacrificing fine pieces of building engineering, but this is the price to pay to win this war!"},
	Truelch_Trap_Final_Requested = {"I hope we still got enough juice from the remaining powered pylons..."},
	Truelch_Trap_Final_Incoming = {"Hey Vek, don't you wanna chew this shiny red pylon?"},

	--Pinnacle
	Truelch_PinnacleBot_Launched = {"This tin can better be friendly!"},

	--Detritus
	Truelch_Detritus_Used = {"I wanna throw up...", "Commander, I don't feel so good."},

	--Meridia
	Truelch_Meridia_Used = {"Damn, Meridia's new fertilizer sure is efficient!", "They're rooting for us!\n'Rooting', got it?"},

	--Nautilus
	Truelch_Nautilus_Used = {"Looks like we are the hunter in Bugs Bunny?", "Whack-a-Vek time guys!"},

	--Candy
	Truelch_Candy_Used = {"They won't believe me when I'll tell them what I did today!", "Pink fluffy unicorn, dancing on rainbows!", "Sweet Celestia!"},

	--Far Line
	Truelch_Farline_Used = {"Hey, look! Brice is riding that wave!"},

	--Watchtower
	Truelch_Watchtower_Used = {"This War Rig is tough but lacks some equipment like a radio.\nWe won't be able to communicate with the crew, so we'll have to trust them."},

	--Vertex
	Truelch_Vertex_OnDeathShards = {"I've kept some Vertex' Crystals in my cargo hold as a souvenir, but maybe we can use it on the Vek."},
}