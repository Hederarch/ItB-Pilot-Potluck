-- Adds a personality without the use of a csv file.

-- Unique identifier for personality.
local personality = "NicoGeneric"
--[[
	#squad
	#corp

	#ceo_full
	#ceo_first
	#ceo_second

	#self_mech
	#self_full
	#self_first
	#self_second

	#main_mech
	#main_full
	#main_first
	#main_second
]]
-- Table of responses to various triggers.
local tbl = {
	--Game States
		Gamestart = {"Fuck I left my phone's charger at the hangar, already off to a great start.","Hi Commander, my name is #self_first, but you can call me #self_second","Greetings, #self_second's my name, piloting's my game!"},
		FTL_Found = {"They're not the weirdest I've seen this week.","Reminds me of some of my friends.","I wonder if the Vek exist in other planets too..."},
		Gamestart_PostVictory = {"Well, let's keep the streak- oh fuck I left my Bot behind, oh well.","Let's hope this one goes better than the last, if possible.","Damn now I'm motivated, let's go!","I hope that my Bot doesn't miss me."},
		Death_Revived = {"Oh fuck I thought I saw grandma back there-","Systems back on, thank God.","Gotta be more careful...","That was certainly close...","I hope I haven't said anything embarassing back there..."},
		Death_Main = {"NO NO DON'T FAIL ME YE-","Shit shit shi-", "No! Not now! Not ye-","M-mom...?","#squad, focus on the Vek, I'll be fi-"},
		Death_Response = {"Fuck, #main_first's down, it's only us now.","#main_first, NO! you bastards!","I'll try to bring them back, gimme an opening to do so."},
		Death_Response_AI = {"AI unit down, let's compensate its absense.","#main_mech down, that's not good.","That was not 'alive' but it sure was useful..."},
		TimeTravel_Win = {"LET'S GO!","Goodbye my little bot, see ya in the flip side.","Glad to be one of the #squad today.","Phew, had my heart on my throat right now, see ya later guys!"},
		Gameover_Start = {"Grid's down, it's over.","NO NO NOT NOW WE WERE SO CLOSE!","I-we've failed these people.","*desk slam*"},
		Gameover_Response = {"Ashamed to retreat, but there's nothing else to do.","God Dammit we were so close","Urgh, we had a good run, eh?"},
	
	-- UI Barks
		Upgrade_PowerWeapon = {"Hehe new toy, wait, I can say that? Nevermind if not.","Now this is what my #self_mech needed!","Nice."},
		Upgrade_NoWeapon = {"Hey! that was mine.","Huh, you're going to replace it with another one, right?","My Bot and Remote can be useful, but don't reduce me to a sitting duck please.","Rude..."},
		Upgrade_PowerGeneric = {"Power running, weapons ready.","I once tried to charge my earphones with a core reactor.\nGuess why I wear these glasses.","Already feels stronger."},
	
	-- Mid-Battle
		MissionStart = {"#squad, cover me while I deploy my bot.","Ok, another day, another mission, let's go.", "Time for us to shine!", "Urgh.", "Don't forget our traning #squad.", "#self_full reporting for Vek termination, #ceo_full.","Time for our Parabellum"},
		Mission_ResetTurn = {"There we go.", "Gotta get back, back to the past, Samurai- #self_first!", "Let's try that again.", "I think I left my breakfast three minutes ago."},
		MissionEnd_Dead = {"Battlefield empty, of Vek, at least.","Call me Mister Clean.","The only good battlefield is one clean of Vek.","There we go."},
		MissionEnd_Retreat = {"They're running away, fuck.","Do we know if they'll come back here?","Phew, could've done that better.","Vek on the run, at least the region's safe..."},

		MissionFinal_Start = {"Fuck... This is why I hate summer...","I hope my bot doesn't melt off.","I can feel the heat even inside here.","My mech is not responding, this isn't good.","G- Guys? Are your mechs also not working?"},
		MissionFinal_StartResponse = {"Mech's back online, phew.", "Damn I wish I could see the volcanic rock here.","Finally, some building free buildings.","Nice."},
		--MissionFinal_FallStart = {},
		MissionFinal_FallResponse = {"*Screams into the intercom as he falls*","W- why does this always happens?!","We should add parachutes to these-"},
		--MissionFinal_Pylons = {},
		MissionFinal_Bomb = {"This is not good, we're underarmed for this.","I think I left my bot upside.", "This cave always surprises me in terms of size.", "Thank God we're not supposed to destroy this Hive ourselves."},
		--MissionFinal_BombResponse = {},
		MissionFinal_CaveStart = {"Okay, guard the bomb, turn this hive to a tomb.\nWished it rhymed...","You know the drill #self_full, you've come so far.","Protect the bomb, save humanity, simple enough, right?"},
		--MissionFinal_BombDestroyed = {},
		MissionFinal_BombArmed = {"Bomb's ready, let's get out of here!","The bomb is primed, about time.","#squad, time to retreat!","This is the part it blows... God I hate this part."},

		PodIncoming = {"Huh? Something's coming.","A pod is on the way.","Nice, lootbox."},
		PodResponse = {"I wonder if it left diamonds where it landed.","Uh... I hope I'm not in there.","I'm sure the civilians can wait, right?"},
		PodCollected_Self = {"Pod's safe!","Ooh, shiny!", "A part of me wants to shake it, I'd rather not."},
		PodDestroyed_Obs = {"Pod's gone, that's a shame.","Pod's gone, let's hope there wasn't anyone there."},
		Secret_DeviceSeen_Mountain = {"Do mountains glow, usually?","... Huh.","I detect something strange in one of this region's mountains, we should check that.","Wait, what's that?"},
		Secret_DeviceSeen_Ice = {"Something's under the ice, we should check it sooner or later.","The permafrost hides something, we should check it."},
		Secret_DeviceUsed = {"Huh... Okay?","Commander, the strange device has been activated, What do I do?"},
		Secret_Arriving = {"Now that's a hella strange Pod.","I wonder who's inside that."},
		Emerge_Detected = {"Surfacing spots detected, waiting for orders.","The Vek intend to emerge.","Emerging Imminent.","Enemy backup incomming."},
		Emerge_Success = {"We've got company.","This ain't good.","From the depths they rise.","Enemy backup arrived Commander."},
		Emerge_FailedMech = {"Commander, I don't think this is the most optimal way for me to engage in the fight.","Let's hope no one attacks me while I'm with my defense down."},
		Emerge_FailedVek = {"Thanks for that.","Vek threat stopped another, perfect.", "That's how I like it.", "Commander, they're stopping each other, I recommend exploiting that."},

	-- Mech State
		Mech_LowHealth = {"And when I JUST repaired my mech.","It would be better if only I left my mech in this state thank you so much.", "Commander, I'm not made of Titanite. HELP."},
		Mech_Webbed = {"Rude.","Ew.", "This thing's worse than military grade glue.", "Be thankful you webbed ME and not MY BOT, you vermin.", "Just like we needed, now I can't move."},
		Mech_Shielded = {"That's more like it.","Shield technology is a life saver.","Shield deployed.","One hit free of charge, let's make it count Commander."},
		Mech_Repaired = {"There we go.","The less close to death I am the better.","The only bad part of the T-417 is how fragile I end up being, this will help for a while.", "That's relieving", "Phew, that's better."},
		Pilot_Level_Self = {"I kindly accept it.","The honor is mine, I assure you.", "I'm just doing all I can do, no need for a promotion."},
		Pilot_Level_Obs = {"That's how it's done #main_first, congratulations!.","Well done!","Now now, #main_first, don't get ahead of yourself!"},
		Mech_ShieldDown = {"Oops.","Fuck.","Better me than the civilians, that's what I say."},

	-- Damage Done
		Vek_Drown = {"I wonder why they invaded Earth after the global flood, it feels counter productive.\nNot that I'm complaining-","Thank God that one couldn't swim.","Vek drowned with water, I'm drowned with joy.","Cannonball to your doom."},
		Vek_Fall = {"Mind where you walk if you don't want to end like that Vek.","how deep are these?","I wonder what's at the bottom."},
		Vek_Smoke = {"Now you see, now you don't.","Smoked Vek, my favorite.","Thank God they can't see through that.","Think Fast Chucklenuts!"},
		Vek_Frozen = {"Woundn't the cold kill them eventually? We should let it be then.","It's like a winter wonderland! Not so 'wonderland' for the Vek though.","the coolest way to say immobilize a threat."},
		VekKilled_Self = {"And stay dead.","There's more where that came from.","Just another day, another killed.","Another bug bites the dust!"},
		VekKilled_Obs = {"Color me surprised.","Well done!","well done #main_second."},
		VekKilled_Vek = {"Commander, the Vek are stupid.","Huh, guess they're aren't as smart as I thought","That was good, let's make it happen again.","Vek taking each other out? Nice."},

		DoubleVekKill_Self = {"Two Vek, one stone.","Two less to worry about.","I'm a fan of efficiency.","Combo!","It's almost too easy."},
		DoubleVekKill_Obs = {"Two bugs down, you're knocking it out of the park #main_first!","Two Vek down, fantastic.","Nicely done!","Leave some for the rest of us!"},
		DoubleVekKill_Vek = {"What?","Oh... ok?", "Two Vek, one stone, but the stone is a third Vek?"},

		MntDestroyed_Self = {"Commander, what did that mountain do to you?","I wonder what rare ores were there.","I was supposed to break that, right?"},
		MntDestroyed_Obs = {"Oh, so we're doing this now?","I didn't know #main_first was demolition expert.", "Who needs TNT when you have we have #main_full?"},
		MntDestroyed_Vek = {"Man, these Vek really are something.","Oh.","D- Damn..."},

		PowerCritical = {"Grid hangs on a string, DO NOT LET IT FALL.","The Grid on the edge? that's not good.", "Grid levels are plummeting, this isn't a drill.","FUCK FUCK GUYS PAY ATTENTION FOR GOD'S SAK-\n*Intercom Cutted Off*"},
		Bldg_Destroyed_Self = {"I'm so sorry.","I...","I had to. I had... to..."},
		Bldg_Destroyed_Obs = {"What the fuck was that #main_first?!","Huh? Oh, great.","Well, now that's just fantastic.","ARE WE FOR REAL?!"},
		Bldg_Destroyed_Vek = {"That Vek is mine.","Do NOT let that Vek get out of here!","Great, just what we needed.","I swear, these Vek are like wrecking balls that walk.","Oh, for the love of-"},
		Bldg_Resisted = {"Let's go!","Building resisted, but we can't relax just yet.","resisted to be defended another day"},


	-- Shared Missions
		Mission_Train_TrainStopped = {"Train stopped, now's a sitting duck.", "Take cover, passengers! We've got this!", "Train at a standstill, don't let it be destroyed."},
		Mission_Train_TrainDestroyed = {"And there goes the Train... #ceo_first won't like this.","as if stopping it wasn't enough.","Horace's down..."},
		Mission_Block_Reminder = {"Don't let the Vek surface, order from #corp.","Don't get too comfortable, #squad. Vek love popping up unexpectedly.","Gotta C-block these V-guys, right?"},

	-- Archive
		Mission_Airstrike_Incoming = {"The sky is falling down.","Commander, air strike inbound.","Brace yourselves for the fireworks!","Careful with my bot fuckers!"},
		Mission_Tanks_Activated = {"About time.","#ceo_first got these relics running, nice."},
		Mission_Tanks_PartialActivated = {"1 is better than none.","These ain't piloted, right?"},
		Mission_Dam_Reminder = {"The dam must go down, if anyone finds an opening, destroy it","I hope there are no cities downstream. For, er, multiple reasons."},
		Mission_Dam_Destroyed = {"Commander, the dam has fallen.","Quite deep for a river.","Anyone wanna cannonball?"},
		Mission_Satellite_Destroyed = {"Oops.","Dammit!","Didn't like astronauts that much anyways..."},
		Mission_Satellite_Imminent = {"Stand back!","3, 2, 1...","Gotta make sure my Bot is safe."},
		Mission_Satellite_Launch = {"My dad saw the first batch of these take launch.","#ceo_second will like this","Up and away."},
		Mission_Mines_Vek = {"Mine fields... Amazing.","Try to bait the Vek into them if you see the chance."},

	-- RST
		Mission_Terraform_Destroyed = {"Dammit.","Super weapons aren't worth much when they're nothing but debris.","Terraformer down, I repeat, terraformer down!","Cool while it lasted..."},
		Mission_Terraform_Attacks = {"DAMN.","That sure is powerful.","Wow."},
		Mission_Cataclysm_Falling = {"Watch your step, the ground is about to go down.","Prepare for some ground turbulence.","Things are about to get shaky.","Incoming ground anomalies, #squad."},
		Mission_Lightning_Strike_Vek = {"Well, thanks for that I guess.","A random lightning will not outclass us.","Commander, Lightnings seem to completely nullify Vek, who'd have guessed."},
		Mission_Solar_Destroyed = {"Oops.","Solar pannel destroyed, let's be more careful next time","Blackout."},
		Mission_Force_Reminder = {"Let's, uh, break some mountains.","#corp said we should flatten the terrain, don't forget that.","I'm really angry at those mountains over there, you know?"},

	-- Pinnacle
		Mission_Freeze_Mines_Vek = {"Walked right into it","You were asking for it.","I'm glad that we have so many of those.","Lol, Lmao even."},
		Mission_Factory_Destroyed = {"I know it has a hassle, but we needed to defend that.","Factory's down, #ceo_full will not like this.","At least no more evil bots."},
		Mission_Factory_Spawning = {"Until #ceo_first fixes its bots, we'll have to tolerate them, cool.","Rogue factory deployed more threats, proceed with caution.","Those factory's bots are cringe, mine are based."},
		Mission_Reactivation_Thawed = {"I'm free don't worry.","That's better.","Brr..."},
		Mission_SnowStorm_FrozenVek = {"Someone wasn't ready for winter.","Are Vek cold-blooded?","Vek Frozen, I recommend leaving them there.","Cooler than cool."},
		Mission_SnowStorm_FrozenMech = {"BOT GET ME OUTTA HERE.","Dang.","Mind helping me?"},
		BotKilled_Self = {"Oops.","You left no other choice.","Replaceable."},
		BotKilled_Obs = {"Talk about a 'Glass Cannon'.","For the punch they pack, their defenses suck...","These are better at demolition than at fighting."},

	-- Detritus
		Mission_Disposal_Destroyed = {"One of the most powerful weapons I've ever seen, done just like that.", "Disposal down, its absense will be felt.","Damn I wanted to fire that."},
		Mission_Disposal_Activated = {"Wow.","Don't wanna be on the other side of that.","Can I try it after this?"},
		Mission_Barrels_Destroyed = {"These smell like my energy drinks.","Barrel down, let's use the acid to our advantage.","I've heard Acid smells like nickles."},
		Mission_Power_Destroyed = {"That's not good","That's a shame.","Dang.","I guess coal really is last century..."},
		Mission_Teleporter_Mech = {"Huh? where am I?!", "My #self_mech's radar has gone crazy where am I?","Hehe, I wanna add this to my bot."},
		Mission_Belt_Mech = {"I wonder how practical these conveyors really are.","I'm on my way.","Going.\nSlowly."},

	-- AE
		Mission_ACID_Storm_Start = {"Ew the sky is spitting bile.","God dammit as if Detritus wasn't dangerous enough!","Cool, ACID rain..."},
		Mission_ACID_Storm_Clear = {"Glad it stopped.","I missed the clear sky.","Finally!"},
		Mission_Wind_Mech = {"Wow, I am not used to this.","How hard would it be to stabilize my mech?","God I'm gonna puke..."},
		Mission_Repair_Start = {"This is what happens when they don't let me fix my stuff.","What we needed just now..."},
		Mission_Hacking_NewFriend = {"A friendly Bot, finally.","Hacking tower is now offline, perfect.", "Welcome back to the good guys side, tin can.", "Conversion, my favorite."},
		Mission_Shields_Down = {"Ok I wasn't expecting that","Our's and the Vek's shields are down.","Time to get serious.", "And there goes that shield, dammit."},
	
	-- Meridia
		Mission_lmn_Convoy_Destroyed = {"The convoy was destroyed","Convoy down, let's cut our losses.","Oops."},
		Mission_lmn_FlashFlood_Flood = {"I forgot my beachpants.","Huh, nice.", "They didn't lie about the 'Flash Floods'"},
		Mission_lmn_Geyser_Launch_Mech = {"WHAT'S GOING O-","WHAT THE -","How strong are these geyser-","Oh?!"},
		Mission_lmn_Geyser_Launch_Vek = {"Haha, Commander are you seeing this?","Glad it wasn't me.","Like a rocket."},
		Mission_lmn_Volcanic_Vent_Erupt_Vek = {"Not even my Bot would survive against that.", "Fried to the core.", "If my calculations are correct, that could tear a hole on even the strongest Vek."},
		Mission_lmn_Wind_Push = {"And I thought that RST was a windy nightmare.","Be aware of your surroundings #squad, or else we'll knock into a building or each other.","I HATE wind, nothing good happens when it's THIS strong."},
		Mission_lmn_Runway_Imminent = {"The plane's about to take off, leave an opening!","That plane needs to take off!"},
		Mission_lmn_Runway_Crashed = {"Not my fault I swear.","The plane crashed, before it even took flight, what a shame."},
		Mission_lmn_Runway_Takeoff = {"Let's go!","Plane took flight, it's now safe.", "Safe and sound, at last."},
		Mission_lmn_Greenhouse_Destroyed = {"Oh no...","that's not good.","Oh..."},
		Mission_lmn_Geothermal_Plant_Destroyed = {"Let's hope this doesn't affect the enviroment TOO much.","Really unfortunate."},
		Mission_lmn_Hotel_Destroyed = {"Isn't Meridia an institute? why would they have an hotel?.","For who is this hotel made? Not the locals I'll assume.", "Hotel's down."},
		Mission_lmn_Agroforest_Destroyed = {"We could've defended that.","No survivors, not even the trees.", "Agroforest's reduce to ashes, #ceo_first won't like this."},

	-- Watchtower missions
		Mission_tosx_Sonic_Destroyed = {"Damn that thing was really loud, not that I'm glad about its destruction either.","Damn that thing was really useful, shame it wasn't exactly silent.","The most interesting machines, they never last long."},
		Mission_tosx_Tanker_Destroyed = {"All of this region will die of thrist, we failed them...","No! It can't be!","FUCK!"},
		Mission_tosx_Rig_Destroyed = {"#ceo_first is going to be so angry...","Oh no.","Oops."},
		Mission_tosx_GuidedKill = {"Glad these missiles pack the punch they that they pack.","Death falls from the sky, not on the #squad though! Right?"},
		Mission_tosx_NuclearSpread = {"I detect an increase in nuclear radiation, keep an eye on your geiger counters","Radiation spreads, be careful y'all.","Who decided to leave these here?"},
		Mission_tosx_RaceReminder = {"I'm sad to say this, but one of these racers will not come back home","#ceo_second said that only one will win, I don't like what that implies.","Ok who's not making it home?"},
		Mission_tosx_MercsPaid = {"Only having loyalty to money is not wise, but it is efficient.","if this is what they need to abide the Commander, so be it.","How valuable are these crystals anyways?"},
		Mission_tosx_RigUpgraded = {"If only our technology was as easy to upgrade...","Notify #ceo_full that we successfully upgraded their War Rig.","Battle-Rig online~!"},

	--FarLine barks
		Mission_tosx_Delivery_Destroyed = {"Delivery failed","Dammit.","Oops...","Hope for a refund?"},
		Mission_tosx_Sub_Destroyed = {"... I don't like being underwater."},
		Mission_tosx_Buoy_Destroyed = {"Uuhg, that's bad.","we should've kept an eye on that one.","Those things are hard to see, okay?"},
		Mission_tosx_Rigship_Destroyed = {"There goes our floor.","Now we gotta take the most advantage of the least floor possible.","Just what we needed."},
		Mission_tosx_SpillwayOpen = {"Spillway open, I'll hold on tight here.","As easy as that? Nice.","Commander, spillway activated, waiting for further command."},
		Mission_tosx_OceanStart = {"This isn't good.","Any idea on how we'll cover terrain if we're like this?","Oh oh."},
		Mission_tosx_RTrain_Destroyed = {"First time I've been glad of seeing a train be destroyed.","Train derailed successfully, massive casualities avoided.", "Huh, destroying them feels good, who would've thought."},
		
	--Nautilus
		Mission_Nautilus_CrumblingReaction = {"This doesn't look good.","This whole thing is going down!","HOLY-"},
		Mission_Nautilus_ExcavatorDestroyed = {"We lost the Excavator.","Excavator down.","No more digging rocks..."},
		Mission_Nautilus_DrillerDestroyed = {"We lost the Driller.","We'll have to continue without the Driller.","No drill? No thrill..."},
		Mission_Nautilus_BlastChargeDestroyed = {"The Blast Charge had to be destroyed, but not like this.","we had to make it go boom, not like that..."},
		Mission_Nautilus_BlastChargeExploded = {"Get out of the explosion's range.","Commander, the Charge exploded as expected.","Damn."},
		Mission_Nautilus_RailLayerDamaged = {"Rail Layer disabled, don't let it get damaged any further.","The Rail Layer's partially damaged, but not destroyed.","It's just like with trains..."},
		Mission_Nautilus_RailLayerDestroyed = {"The Rail Layer's destroyed. Not even Nautilus could get it running again.","#ceo_first won't like this.","We never catch a break with rails, now don't we?","Rail Layer's down Commander."},

	-- Island missions
		Mission_tosx_Juggernaut_Destroyed = {"Why are most Bots here either fragile as cardboard or almost immortal?!","Juggernaut's down.", "The last of its kind, now gone... I can relate to that.","Damn, #ceo_second had allowed me to try to replicate it."},
		Mission_tosx_Juggernaut_Ram = {"Try to avoid being on its path, I would recommend.","We could use one of them, shame this is the last one...\nUnless.", "If only #ceo_first had more of these."},
		Mission_tosx_Zapper_On = {"Zapper is connected.","I've been promoted from soldier to cable, what an honor...","My whole suit felt that.","Call me #self_first, 'The Zapper', Soto"},
		Mission_tosx_Zapper_Destroyed = {"#ceo_second is going to kill us for that-","The zapper has fallen, we'll have to compensate the loss.","Oops"},
		Mission_tosx_Warper_Destroyed = {"Such amazing technology, destroyed like it was nothing.","And just when I started to get used to the portals...","Oops"},
		Mission_tosx_Battleship_Destroyed = {"Into the depths it goes.","At least it wasn't an iceberg this time.","Oh..."},
		Mission_tosx_Siege_Now = {"COMMANDER, WE'RE GETTING AMBUSHED, PREPARE FOR THE WORST.","Oh no.","NO NOT AGAIN PLEASE!","I saw a movie like this."},
		Mission_tosx_Plague_Spread = {"EW WHAT'S THAT!","Commander, that Vek carries deadly pathogens, proceed with caution.","That definitely doesn't have a vaccine-"},
	
	-- Candy Land Mission Events
		Mission_Candy_SeederDestroyed = {"For something that generates mountain-likes, is not nearly as durable as one.","Seeder's down, Miss #ceo_first won't like this.","Shame..."},
		Mission_Candy_TruckDestroyed = {"The truck has been destroyed.","No more ice cream for us I guess.","Dawg I wanted some... Dulce de Leche is the best one."},
		Mission_Candy_UnicornHurt = {"Unicorn's down, we gotta protect it now.","Commander, the unicorn is where we want it, awaiting further instructions."},
		Mission_Candy_UnicornDestroyed = {"We overkilled it, dammit.","We had to protect it, you know?"},
		Mission_Candy_PinataDestroyed = {"Piñata down, let's collect the reward.","Reap what you Sow- er- Kill.","Collect the candy, we could need that boost.","Are its guts candy? Ok."},
		Mission_Candy_BombDestroyed = {"The bomb has been destroyed.","We really don't have luck with bombs, do we?"},
		Mission_Candy_PicnicStain = {"Why does #ceo_second has a blanket this big?!","#ceo_first was asking for trouble having a blanket that big.","If fixing my #self_mech taught me anything, Vek blood is a hassle to clean."},
		Mission_Candy_PicnicTear = {"Let's hope she doesn't notice...","Commander, tearing the blanket removes the stained parts, should we proceed?","I guess that's one way to remove the stains."},
		Mission_Candy_RainbowRide = {"Talk about 'Catching the rainbow'","Commander, my mech is now potentiated, time to rock.","WOW! That didn't felt good, not on my stomatch..."},
		Mission_Candy_SuperMilkStorm = {"Thank God the ground is not made out of cookies or cereal, we would be swimming in milk otherwise.","How fucked up is the weather here?","People here use umbrellas or cereal bowls?","Commander, milk rains are getting worse, we have to be careful."},

		--Machin's Missions
		Mission_Machin_Botbuddy_Destroyed = {"And just when I was starting to like it...","Bot lost, they did their part as best as they could."},
		Mission_Machin_Botbuddy_Trained = {"If only our training was as simple.","Why is #ceo_full building death machines again?"},
		Mission_Machin_Fuel_Delivered = {"Laser Array has been activated, let's use it.","Commander, Laser Array has been fueled successfully.","Conga Line the Vek to oblivion."},
		Mission_Machin_Radio_Destroyed = {"Radio communication cut.","#ceo_first will kill us for this...","There goes my favorite station..."},
		Mission_Machin_Laser_Array_Destroyed = {"Let's hope that doesn't trigger any ripples in time...","Array's down, what a pity."},
		Mission_Machin_Warhead_Destroyed = {"Warhead detonated successfully.","One of these almost crush me at my youth."},
		
		--Karto's Missions
		kf_Env_Wildfire_BldgDanger = {"Fire nearby buildings, act with caution.","Keep the firefighters notified of that building."},
		kf_Env_Wildfire_Spreading = {"Fire is spreading, and FAST!","Hell is running loose here, we must do something about it.","It's getting way to hot in here..."},
}

-- inner workings. no need to modify.
local PilotPersonality = {}

function PilotPersonality:GetPilotDialog(event)
	if self[event] ~= nil then 
		if type(self[event]) == "table" then
			return random_element(self[event])
		end
		
		return self[event]
	end
	
	--If I did everything right, this shouldn't trigger at all
	LOG("No pilot dialog found for "..event.." event in "..self.Label)
	return ""
end

Personality[personality] = PilotPersonality
for trigger, texts in pairs(tbl) do
	if
		type(texts) == 'string' and
		type(texts) ~= 'table'
	then
		texts = {texts}
	end
	
	assert(type(texts) == 'table')
	Personality[personality][trigger] = texts
end