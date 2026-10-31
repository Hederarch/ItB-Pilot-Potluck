--////////////////////////////////--
--//            Lines           //--
--////////////////////////////////--

return {

----------------
-- Game Start --
----------------

	Gamestart = {
	-- A new game is started. --
	-- Guaranteed. --
	-- Selects the starting Pilot. --
	-- If starting Pilot is an FTL Pilot, forms a dialogue with [Gamestart_Alien]. --
		"Vek :c/: Threatening Humanity -- Current Goal :: Extermination",
		"Islands :(): Corporate :: Barrier :(): Vek -- #squad :f/>>: Reinforce Islands",
		"Vek :c/: Global Threat -- Charging Amplifiers"
	},
	Gamestart_PostVictory = {
	-- A new game is started and this Pilot's last timeline resulted in a victory. --
	-- Guaranteed. --
	-- Selects the starting Pilot. --
	-- Overrides [GameStart]. --
		"Current Unit :p/>>: Annihilated Vek -- Repetition :(): Task :: Feasible",
		"Vek Threat :!/: Minimal -- Extermination :(): Vek :p/: Proven Possible"
	},

--[[
	Gamestart_Alien = {
	-- Can play in a dialogue with [Gamestart]. --
	-- Guaranteed. --
	-- Non-Standard. --
	-- Selects a random Pilot other than the starting Pilot. --
	-- As an indirect result of the triggering circumstances, Unique and FTL Pilots never need this line. --
		""
	},
]]


----------------------
-- Combat (General) --
----------------------

	VekKilled_Self = {
	-- This Pilot's Mech kills a Vek. --
	-- 20% Chance. --
	-- Selects a Pilot that fulfills #main. --
	-- Competes with [VekKilled_Obs]. --
		"Life Signs :(): Vek :c/: Ceased",
		"Vek :: Exterminated",
		"Current Unit :p/: Killed Vek"
	},
	VekKilled_Obs = {
	-- Another Pilot's Mech kills a Vek. --
	-- 20% Chance. --
	-- Selects a Pilot that fulfills #other. --
	-- Competes with [VekKilled_Self]. --
		"Life Signs :(): Vek :c/: Ceased",
		"Vek :: Exterminated",
		"Unit #main_last :p/: Killed Vek"
	},
	VekKilled_Vek = {
	-- A Vek kills another Vek. --
	-- 50% Chance. --
	-- Selects a random Pilot. --
		"Life Signs :(): Vek :c/: Ceased -- Cause :: Fellow Vek",
		"Vek :: Stupid Idiots",
		"Vek :(): Particular :c/: Fumbling Bag"
	},
	DoubleVekKill_Self = {
	-- This Pilot's Mech kills 2 or more Vek at once. --
	-- 50% Chance. --
	-- Selects a Pilot that fulfills #main. --
	-- Competes with [DoubleVekKill_Obs]. --
	-- Overrides [VekKilled_Self]. --
		"Multiple Life Signs :(): Vek :c/: Ceased",
		"Swarm :: Exterminated",
		"Current Unit :p/: Killed Multiple Vek"
	},
	DoubleVekKill_Obs = {
	-- Another Pilot's Mech kills 2 or more Vek at once. --
	-- 50% Chance. --
	-- Selects a Pilot that fulfills #other. --
	-- Competes with [DoubleVekKill_Self]. --
	-- Overrides [VekKilled_Obs]. --
		"Multiple Life Signs :(): Vek :c/: Ceased",
		"Swarm :: Exterminated",
		"Unit #main_last :: Proven :(): Combat Effective"
	},
	DoubleVekKill_Vek = {
	-- A Vek kills 2 or more other Vek at once. --
	-- 50% Chance. --
	-- Selects a random Pilot. --
	-- Overrides [VekKilled_Vek]. --
		"Vek :: Choking Fight -- Chances :(): Success :: Rising",
		"Vek :!/<<: Significant Levels :(): Intelligence -- Evidence :: Current Events"
	},
	Emerge_Detected = {
	-- New Emergence tiles are formed. --
	-- 3% Chance. --
	-- Selects a random Pilot. --
		"Emergence :c/: Spotted",
		"#squad :>>: Look Out :(): Below -- Vek :f/: Emerge"
	},
	Emerge_Success = {
	-- A Vek succeeds at Emerging. --
	-- 3% Chance. --
	-- Selects a random Pilot. --
		"Emergence Attempt :(): Vek :p/: Successful",
		"Additional Combatant :p/: Emerged"
	},
	Emerge_FailedMech = {
	-- A Vek attempts to Emerge, but this Pilot's Mech is positioned on the emergence tile, dealing damage to the Mech. --
	-- 20% Chance. --
		"Vek :(): Below Current Position :: Being Blueballed",
		"Fat Ass :(): #self_mech :c/: Planted :(): Emergence Point",
		"Emerge Attempts :!/c/: Authorized"
	},
	Emerge_FailedVek = {
	-- A Vek attempts to Emerge, but another Vek is positioned on the emergence tile, dealing damage to the latter Vek. --
	-- 3% Chance. --
	-- Selects a random Pilot. --
		"Vek :!/<<: Patience"
	},
	BotKilled_Self = {
	-- A Pinnacle Bot is destroyed by this Pilot. --
	-- 20% Chance. --
	-- Selects a Pilot that fulfills #main. --
	-- Competes with [BotKilled_Obs]. --
		"Power Signature :(): Bot :c/: Ceased",
		"Current Unit :p/: Dismantled Bot",
		"Targeted Bot :p/: Inferior"
	},
	BotKilled_Obs = {
	-- A Pinnacle Bot is destroyed by another Pilot. --
	-- 20% Chance. --
	-- Selects a Pilot that fulfills #other. --
	-- Competes with [BotKilled_Self]. --
		"Power Signature :(): Bot :c/: Ceased",
		"Unit #main_last :p/: Dismantled Bot"
	},
	Mech_LowHealth = {
	-- This Pilot's Mech is dropped to 1 Health. --
	-- Guaranteed. --
		"Ow",
		"Ouchie",
		"Current Unit :c/: Under Threat :(): Destruction",
		"#self_mech Hull Integrity :: Low"
	},
	Death_Main = {
	-- This Pilot's Mech is disabled. --
	-- Guaranteed. --
	-- Selects a Pilot that fulfills #main. --
	-- Competes with [Death_Response]. --
		"Current Unit :: Losing Power",
		"Current Unit :c/: Transferring Data :(): Black Box",
		"Current Unit :: Down -- Current Unit :?/: Out"
	},
	Death_Response = {
	-- Another Piloted Mech is disabled. --
	-- Guaranteed. --
	-- Selects a Pilot that fulfills #other. --
	-- Competes with [Death_Main]. --
		"Unit #main_last :: Losing Power -- Under Threat :(): Death",
		"Unit #main_last :?/: Cooked "
	},
	Death_Response_AI = {
	-- Another Mech is disabled but it had no Pilot. --
	-- Guaranteed. --
	-- Selects a Pilot that fulfills #other. --
		"Military Equipment :c/: Disabled -- Status :: Recoverable",
		"Offensive Capabilities :: #squad :c/: Dropping"
	},
	Death_Revived = {
		-- This Pilot's Mech healed when it previously had no health remaining. --
		-- Guaranteed. --
		"Current Unit :c/: Receiving Data :(): Black Box",
		"Power :: Restored -- Vek :c/: Engaged"
	},

--[[
	Death_Response_Medical = {
	-- No trigger in vanilla gameplay. --
	-- My speculation is that this was meant for either Rosie Rivets or an earlier form of Isaac Jones, to force a reminder to the player to use the healing capabilities to revive the slain Mech. --
	-- Guaranteed. --
	-- Non-Standard. --
	-- Overrides [Death_Main] and [Death_Response]. --
		""
	},
]]


------------------------
-- Combat (Elemental) --
------------------------

	Vek_Drown = {
	-- A Vek without the Flying or Massive traits is pushed onto any liquid tile, killing the Vek. --
	-- 50% Chance. --
	-- Selects a random Pilot. --
		"Vek Breathing Pathways :p/: Saturated",
		"Vek Respiration :c/: Interrupted -- Lethality :: Guaranteed"
	},
	Vek_Fall = {
	-- A Vek without the Flying trait is pushed onto a Chasm, killing the Vek. --
	-- 50% Chance. --
	-- Selects a random Pilot. --
		"Vek Downwards Velocity :p/: Increasing -- Lethality :: Guaranteed",
		"Vek :c/: Falling :(): Great Height"
	},
	Vek_Smoke = {
	-- A Vek's action is cancelled by Smoke. --
	-- 10% Chance. --
	-- Selects a random Pilot. --
		"Vek Visual Organs :p/: Impaired",
		"Vek :!/c/:<< Ability :(): Retaliation"
	},
	Vek_Frozen = {
	-- A Vek is frozen. --
	-- 35% Chance. --
	-- Selects a random Pilot. --
		"Vek Body Temperature :: Heavily Reduced -- Autonomous Activity :!/: Expected",
		"Vek :p/: Encased -- Life Signs :(): Vek :!/: Ceased"
	},
	Mech_Webbed = {
	-- This Pilot's Mech becomes grappled by Vek webs. --
	-- 50% Chance. --
		"Mobility :(): Current Unit :: Heavily Impaired",
		"Vek :c/: Grappling #self_mech -- Vek :: Bitch",
		"Vek Webs :: Extremely Annoying"
	},
	Mech_Shielded = {
	-- This Pilot's Mech gains a Shield. --
	-- 20% Chance. --
		"Pinnacle Shield Technology :c/: Engaged"
	},
	Mech_ShieldDown = {
	-- This Pilot's Mech loses a Shield. --
	-- 50% Chance. --
		"Pinnacle Shield Technology :p/: Lost Power",
		"Shield :c/: Down -- It :: What It Is"
	},
	Mech_Repaired = {
	-- This Pilot's Mech takes the repair action. --
	-- 75% Chance. --
		"Field Repairs :: Applied",
		"#self_mech Hull :: Mended"
	},

--[[
	Mech_WebBlocked = {
	-- This Pilot's Mech would become grappled by Vek webs, but this Pilot has the [Disable_Immunity] skill. --
	-- Essentially, this line is only used for Camilla Vera --
	-- Guaranteed. --
	-- Non-Standard. --
		""
	},
]]


--------------------
-- Combat (Level) --
--------------------

	-- LINEAR DIALOGUE --
	Pilot_Level_Self = {
	-- This Pilot levels up. --
	-- Guaranteed. --
	-- Forms a dialogue with [Pilot_Level_Obs]. --
		"Combat Effectiveness :p/: Increased",
		"New Protocols :p/: Applied -- Expected Vek Kill Rate :c/: Rising"
	},
	Pilot_Level_Obs = {
	-- Plays in a dialogue with [Pilot_Level_Self]. --
	-- Guaranteed. --
		"Registering Increase :(): Combat Effectiveness :(): Unit #main_last",
		"Recalclating Battlefield Prominence :(): Unit #main_last"
	},


--------------------------
-- Combat (Environment) --
--------------------------

	MntDestroyed_Self = {
	-- This Pilot's Mech demolishes a Mountain. --
	-- 25% Chance. --
	-- Selects a Pilot that fulfills #main. --
	-- Competes with [MntDestroyed_Obs]. --
		"Mountain :: Demolished",
		"Obstacle :: Removed"
	},
	MntDestroyed_Obs = {
	-- Another Pilot's Mech demolishes a Mountain. --
	-- 25% Chance. --
	-- Selects a Pilot that fulfills #other. --
	-- Competes with [MntDestroyed_Self]. --
		"Mountain :: Demolished",
		"Obstacle :: Removed"
	},
	MntDestroyed_Vek = {
	-- A Vek demolishes a Mountain. --
	-- 25% Chance. --
	-- Selects a random Pilot. --
		"Mountain :: Demolished -- Cause :: Vek",
		"Obstacle :: Removed -- Cause :: Vek"
	},
	Bldg_Destroyed_Self = {
	-- This Pilot's Mech damages or destroys a Building. --
	-- 75% Chance. --
	-- Selects a Pilot that fulfills #main. --
	-- Competes with [Bldg_Destroyed_Obs]. --
		"Current Unit :?/: Malfunctioning -- Civilians :!/: Priority Target",
		"#self_mech Weaponry :?/: Malfunctioning -- Civilians :!/: Priority Target"
	},
	Bldg_Destroyed_Obs = {
	-- Another Pilot's Mech damages or destroys a Building. --
	-- 75% Chance. --
	-- Selects a Pilot that fulfills #other. --
	-- Competes with [Bldg_Destroyed_Self]. --
		"Unit #main_last :?/: Throwing -- Civilians :!/: Priority Target",
		"#main_mech Weaponry :?/: Throwing -- Civilians :!/: Priority Target"
	},
	Bldg_Destroyed_Vek = {
	-- A Vek damages or destroys a Building. --
	-- 50% Chance. --
	-- Selects a random Pilot. --
		"Population Center Attack :(): Vek :: Successful",
		"Vek Target Priority :: Appended -- Cause :: Vengeance",
		"Civilian Structures :c/: Collapsing -- Vek :(): Particular :f/: Dead"
	},
	Bldg_Resisted = {
	-- A Building resists damage via Grid Resist, from any source. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Structural Integrity :(): Population Center :c/: Holding",
		"Population :(): Building :!/: Hurt"
	},
	PowerCritical = {
	-- Remaining Grid Power is dropped below three. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
	-- Can only play once per Mission. --
		"Grid Power :c/: Rapidly Dropping",
		"Connection :(): Grid Power :c/: Failing"
	},

	-- LINEAR DIALOGUE --
	Gameover_Start = {
	-- Remaining Grid Power is dropped to zero. Overrides [PowerCritical] --
	-- Guaranteed. --
	-- Selects a random Pilot. --
	-- Forms a dialogue with [Gameover_Response]. --
		"Connection :(): Grid Power :c/: Ceased",
		"Structural Integrity :(): Grid :!/c/: Functional"
	},
	Gameover_Response = {
	-- Plays in a dialogue with [Gameover_Start]. --
	-- Selects a different random Pilot. --
		"Current Timeline :: Cooked",
		"Vek Extermination :: Failed",
		"Damn"
	},


-------------------
-- Mech Upgrades --
-------------------

	Upgrade_PowerWeapon = {
	-- A new, zero Core cost equipment is equipped onto the Pilot's Mech, an equipped equipment that costs one or more Core is powered for the Pilot's Mech, or an upgrade for an equipped equipment is powered for the Pilot's Mech. --
	-- Guaranteed. --
		"New Kit :: Kickass",
		"Weaponry Improvements :: [ Aknowledged,  Recorded ]",
		"Upgraded Armaments :f/: Improve :(): Combat Effectiveness"
	},
	Upgrade_NoWeapon = {
	-- A piece of equipment is removed from the Pilot's Mech, and the Pilot's Mech had only one piece of equipment. --
	-- Guaranteed. --
		"Bet",
		"Current Unit :!/<<: Weaponry :!/f/: Combat Vek "
	},
	Upgrade_PowerGeneric = {
	-- The "+2 Health" or "+1 Move" upgrade is powered on the Pilot's Mech. --
	-- Guaranteed. --
		"External Device Augmentation :: Dope",
		"Chassis Alterations :: [ Aknowledged,  Recorded ]",
		"Upgraded Capabilities :f/: Improve :(): Combat Effectiveness"
	},


-----------------------
-- Mission (General) --
-----------------------

	MissionStart = {
	-- All three Mechs have landed into a new mission. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Current Time :: Go Time",
		"#squad :p/: Landed -- Mission :c/: Underway",
		"Amplifiers :c/: Ready -- Amplifier Activation Protocols :(): Standby"
	},
	Mission_ResetTurn_Withered = {
	-- A Reset Turn is used and this Pilot has the powered [ffrg_Withered] skill. --
	-- Guaranteed. --
	-- Overrides [Mission_ResetTurn] --
		"Vek Life Expectancy :: Dropping :(): Rapidly",
		"We Know :: [ Vek Movements,  Vek Actions,  Vek Plans ] -- All Vek :!/f/: Escape",
		"Vek :c/: In Great Danger -- Searching Global Maximum :(): Danger",
		"#squad :>>: [ Block Escape Routes :(): Vek,  Prepare :(): Extermination ]",
		"Amplifiers :: Engaged -- Many Vek :f/: Perish",
		"Current Time :: Time :(): Clutch Up"
	},
	Mission_ResetTurn = {
		-- A Reset Turn is used. --
		-- Guaranteed. --
		-- Selects a random Pilot. --
		"Breach :p/: Successful",
		"Time :: Dilated"
	},
	MissionEnd_Retreat = {
	-- A mission is finished but some Vek remain alive. --
	-- 50% Chance. --
	-- Selects a random Pilot. --
		"Vek :c/: Escaping -- Extermination :: Superior Outcome",
		"Vek Swarm :c/: Retreating"
	},
	MissionEnd_Dead = {
	-- A mission is finished and all Vek were killed. --
	-- 75% Chance. --
	-- Selects a random Pilot. --
		"Life Signs :(): Vek :!/c/: Detected -- Vek :!/p/: Ball",
		"Vek Swarm :p/: Fully Exterminated"
	},

	-- LINEAR DIALOGUE --
	PodIncoming = {
	-- A Time Pod is incoming. Plays over the entire landing sequence. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
	-- Forms a dialogue with [PodResponse]. --
		"Sensor Abnormalities :c/: Detected -- Craft :c/: Incoming",
		"Re-Entry :c/: Detected -- Time Pod :c/: Landing"
	},
	PodResponse = {
	-- Timed such that it plays shortly after the Time Pod lands. --
	-- Plays in a dialogue with [PodIncoming]. --
	-- Selects a different random Pilot. --
		"Time Pod :: Valuable -- [ Mission,  Lives ] :: Valuable :(): More",
		"Time Pod :?/<<: Useful Equipment -- Priority :: Moderate"
	},

	PodCollected_Self = {
	-- This Pilot's Mech is moved onto a Time Pod, collecting it. --
	-- Guaranteed. --
		"Time Pod :p/: Acquired",
		"Time Pod :c/(): Storage"
	},
	PodDestroyed_Obs = {
	-- A Time Pod is destroyed by a Vek or another Pilot's Mech. --
	-- Guaranteed. --
	-- Selects a Pilot that does not fulfill #main. --
		"Pod Hull Integrity :p/: Failed"
	},
	Secret_DeviceSeen_Mountain = {
	-- A Suspicious Mountain tile containing a Secret Device was demolished, revealing the device. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Abnormal Device :c/: Spotted -- Location :: Mountain Rubble"
	},
	Secret_DeviceSeen_Ice = {
	-- A Suspicious Ice tile containing a Secret Device was shattered, revealing the device. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Abnormal Device :c/: Spotted -- Location :: Glacial Remnants"
	},
	Secret_DeviceUsed = {
	-- This Pilot's Mech is moved onto a Secret Device, consuming it and queuing an FTL Pod. --
	-- Guaranteed. --
		"Abnormal Device :p/: Activated -- Use :: Unknown"
	},
	Secret_Arriving = {
	-- An FTL Pod is incoming. Plays over the entire landing sequence. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Re-Entry :c/: Detected -- Abnormal Craft :c/: Incoming"
	},
	FTL_Found = {
	-- Played upon returning to the Island overview screen after an FTL Pod was opened. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Current Unit :p/: Recalls :(): Abnormal Individual -- We :: Go Way Back"
	},
	Mission_Train_TrainStopped = {
	-- The Train is hit for the first time and partially destroyed, halting its progress on the tracks. Partially fails an objective. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Cargo Train :c/: Derailed -- [ Passengers,  Crew ] :c/: Vulnerable",
		"Cargo Train :p/: Heavily Damaged -- Contents :: Recoverable"
	},
	Mission_Train_TrainDestroyed = {
	-- The Train is hit a second time and fully destroyed. Completely fails an objective. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Cargo Train :p/: Destroyed -- [ Occupants,  Contents ] :: [ Dead,  Unrecoverable ]"
	},
	Mission_Block_Reminder = {
	-- The "Block Vek Spawning 3 times" mission is not progressing adequately. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Vek Emergence Attempts :c/: Unimpeded -- Rectification :f/: Necessary",
		"Vek Emerging :(): Freely -- Circumstance :: Conflicts :(): Mission Directive"
	},


-----------------------
-- Mission (Archive) --
-----------------------

	Mission_Airstrike_Incoming = {
	-- An Archive Bomber airstrike is queued. --
	-- 30% Chance. --
	-- Selects a random Pilot. --
		"Archive Bomber Flight Path :f/(): Current Area",
		"Bomber :c/: Incoming -- #squad :!/f/>>(): Blast Zone"
	},
	Mission_Repair_Start = {
	-- All three Mechs have landed into a "Use 3 Repair Platforms" mission. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
	-- Overrides [MissionStart]. --
	-- AE only. --
		"Mech State :c/: Critical",
		"Archive Mechanics :p/: Threw"
	},
	Mission_Tanks_Activated = {
	-- Both Light Tanks activate. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Additional Fire Support :: Acquired -- Tanks :: Gas",
		"Archive Tanks :c/: Fully Activated -- Calculating :(): Additional Firepower"
	},
	Mission_Tanks_PartialActivated = {
	-- One Light Tank of the two has already been destroyed, but the other Light Tank activates. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Archive Tank :c/: Fully Activated -- Calculating :(): Additional Firepower"
	},
	Mission_Dam_Reminder = {
	-- The "Destroy the Dam" mission is not progressing adequately. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"River Barricade :!/c/: Destroyed -- Rectification :f/: Necessary",
		"Dam :c/: Intact -- Circumstance :: Conflicts :(): Mission Directive"
	},
	Mission_Dam_Destroyed = {
	-- A Dam is destroyed, flooding 2 lines of tiles. Completes an objective. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Dam :p/: Demolished -- Body :(): Water :p/: Created",
		"Dam :c/: Breached -- River Formation :c/: Underway"
	},
	Mission_Satellite_Destroyed = {
	-- A Satellite is destroyed. Partially fails an objective. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Archive Space Craft :p/: Destroyed",
		"Primitive Space Probe :!/c/: Launch-Ready State"
	},
	Mission_Satellite_Imminent = {
	-- A Satellite queues takeoff. --
	-- 30% Chance. --
	-- Selects a random Pilot. --
		"Primitive Space Probe :c/: Launch-Ready State",
		"Space Craft Thrusters :c/: Igniting -- #squad :>>: Clear Takeoff Zone"
	},
	Mission_Satellite_Launch = {
	-- A Satellite takes off. Always partially completes an objective. --
	-- 30% Chance. --
	-- Selects a random Pilot. --
		"Space Craft Flight :c/: Underway",
		"Takeoff :(): Archive Space Craft :p/(): As Scheculed"
	},
	Mission_Mines_Vek = {
	-- A Vek moves onto and is killed by a Mine. --
	-- 30% Chance. --
	-- Selects a random Pilot. --
		"Vek :: Stupid -- Mine :(): Red Light :(): Giant",
		"Mine :p/: Easily Visible -- Vek :(): Particular :p/<<: Smooth Brain"
	},


-------------------
-- Mission (RST) --
-------------------

	Mission_Terraform_Destroyed = {
	-- A Terraformer is destroyed. Always partially fails an objective, typically completely fails the objectives. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Terraforming Unit :p/: Destroyed",
		"RST Terraforming Capabilities :: Lost"
	},
	Mission_Terraform_Attacks = {
	-- A Terraformer's Terraform is used. Typically progresses the objective. --
	-- 30% Chance. --
	-- Selects a random Pilot. --
		"Terrain Upheaval :c/: Detected",
		"New Desert :c/: Forming -- Impeding Obstacles :p/: Destroyed"
	},
	Mission_Cataclysm_Falling = {
	-- Seismic Activity collapses some tiles into chasms --
	-- 30% Chance. --
	-- Selects a random Pilot. --
		"Extreme Seismic Activity :c/: Detected",
		"Terrain :c/: Shifting -- #squad :>>: Watch :(): Footing"
	},
	Mission_Lightning_Strike_Vek = {
	-- A Vek is killed by a lightning strike. --
	-- 30% Chance. --
	-- Selects a random Pilot. --
		"Vek :p/: Killed -- Cause :: Extreme Electrical Shock",
		"Unit Mother Nature :p/: Exterminated Vek"
	},
	Mission_Solar_Destroyed = {
	-- A Solar Farm is destroyed. Partially fails an objective. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Solar Power Farm :p/: Destroyed",
		"RST Solar Batteries :c/(): Non-Functional"
	},
	Mission_Force_Reminder = {
	-- The "Destroy 2 Mountains" mission is not progressing adequately. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Mountain Range :!/c/: Destroyed -- Rectification :f/: Necessary",
		"Cliffs :c/: Intact -- Circumstance :: Conflicts :(): Mission Directive"
	},
	Mission_Wind_Mech = {
	-- This Pilot's Mech is moved by a Wind Storm. --
	-- 30% Chance. --
	-- AE only. --
		"Exreme Wind Conditions :p/: Moved #self_mech",
		"Powerful Gale :c/: Serving :(): Form :(): Transportation"
	},


------------------------
-- Mission (Pinnacle) --
------------------------

	Mission_Freeze_Mines_Vek = {
	-- A Vek is frozen via a Cryo-Mine. --
	-- 30% Chance. --
	-- Selects a random Pilot. --
	-- Overrides [Vek_Frozen]. --
		"Vek :: Stupid -- Mine :(): Blue Light :(): Giant",
		"Cryo Mine :p/: Easily Visible -- Vek :(): Particular :<<: Smooth Brain"
	},
	Mission_Factory_Destroyed = {
	-- A Bot Factory is destroyed. Partially fails an objective. --
	-- Guaranteed.. --
	-- Selects a random Pilot. --
		"Robotics Manufacturing Facility :p/: Destroyed",
		"Incoming Source :(): Hostile Bots :p/: Rectified -- Consequences :!/f/: Minimal"
	},
	Mission_Factory_Spawning = {
	-- A Bot Factory manufactures and releases a Pinnacle Bot. --
	-- 30% Chance. --
	-- Selects a random Pilot. --
		"Manufacturing Load :c/: Accelerating -- Bots :c/: Incoming",
		"Pinnacle Factory :c/: Manufacturing Bots"
	},
	Mission_Reactivation_Thawed = {
	-- Vek and/or Bots have their Frozen status removed via the thaw modifier. --
	-- 30% Chance. --
	-- Selects a random Pilot. --
		"Ice :c/: Weakening -- Vek :c/: Breaking Free",
		"Unusual Temperatures :(): Current Environment :p/: Thawed Ice"
	},
	Mission_Hacking_NewFriend = {
	-- A Hacking Facility is destroyed, switching the team of the linked Cannon-Bot. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
	-- AE only. --
		"Goofy Goober :c/: No Longer Hostile",
		"Lil Guy :c/: Friend -- Directive Assignment :c/: Available"
	},
	Mission_Shields_Down = {
	-- A Shield Generator is destroyed, removing the Shield of every unit on the field. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
	-- AE only. --
		"Universal Shield :p/: Dropped -- [ #squad,  Vek ] :c/: Vulnerable",
		"Shield Generator :p/: Destroyed"
	},
	Mission_SnowStorm_FrozenVek = {
	-- A Blizzard freezes a Vek. --
	-- 30% Chance. --
	-- Selects a random Pilot. --
	-- Overrides [Vek_Frozen]. --
		"Unit Mother Nature :p/: Neutralized Vek",
		"Vek Body Temperature :: Heavily Reduced -- Cause :: Extreme Blizzard"

	},
	Mission_SnowStorm_FrozenMech = {
	-- A Blizzard freezes this Pilot's Mech. --
	-- 75% Chance. --
		"Mech Manueverability :c/: Neutralized -- Cause :: Extreme Blizzard",
		"#self_mech Controls Seized -- Cause :: Ice Buildup"
	},


------------------------
-- Mission (Detritus) --
------------------------

	Mission_Disposal_Destroyed = {
	-- A Disposal Unit is destroyed. Always partially fails an objective, typically completely fails the objectives. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Disposal Unit :p/: Destroyed",
		"Detrius Mass Disposal Capabilities :: Lost"
	},
	Mission_Disposal_Activated = {
	-- A Disposal Unit's A.C.I.D. Dump is used. Typically progresses the objective. --
	-- 30% Chance. --
	-- Selects a random Pilot. --
		"Mass A.C.I.D. Dump :c/: Detected",
		"Mass Disposal Capabilities :p/: Utilized -- Impeding Obstacles :p/: Destroyed"
	},
	Mission_ACID_Storm_Start = {
	-- All three Mechs have landed into a "Destroy the A.C.I.D. Storm Generator" mission. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
	-- Overrides [MissionStart]. --
	-- AE only. --
		"A.C.I.D. Storm :: [ Annoying,  Dangerous ] -- Destruction :(): Generator :: Neccessary",
		"Universal A.C.I.D. Application :c/: Detected -- Conditions :: Hazardous"
	},
	Mission_ACID_Storm_Clear = {
	-- A Disposal Unit is destroyed. Completes an objective. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
	-- AE only. --
		"Storm Generator :p/: Destroyed",
		"Universal A.C.I.D. Application :c/: Ceased"
	},
	Mission_Barrels_Destroyed = {
	-- An A.C.I.D. Barrel is destroyed. Partially completes the objective. --
	-- 30% Chance. --
	-- Selects a random Pilot. --
		"A.C.I.D. Containment Barrel :p/: Destroyed",
		"Subterranean Vek :c/: Experiencing :(): Bad Time"
	},
	Mission_Power_Destroyed = {
	-- A Power Plant is destroyed. Fails an objective. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Chemical Power Facility :p/: Destroyed",
		"Detritus Power Production :c/(): Non-Functional"
	},
	Mission_Teleporter_Mech = {
	-- This Pilot's Mech is moved by a Teleporter. --
	-- 30% Chance. --
		"Instant Mass Translocation :p/: Engaged",
		"Vek Swarm :(): Particular :>>: Look Behind You :(): Idiots"
	},
	Mission_Belt_Mech = {
	-- This Pilot's Mech is moved by a Conveyor Belt. --
	-- 30% Chance. --
		"Wheee",
		"Cargo Transportation Belt :c/: Aiding Maneuverability"
	},


--------------------
-- Mission (Hive) --
--------------------

	MissionFinal_Start = {
	-- All three Mechs have landed onto the surface half of the Volcanic Hive. Overrides [MissionStart]. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Mission Importance :: Paramount -- Your Lives :!/: Worthless -- Heroic Sacrifices :!/: Allowed",
		"#squad :>>: Engage Mission -- We :<<: One Chance"
	},
	MissionFinal_StartResponse = {
	-- Played when the Power Pylons are dropped onto the surface of the Volcanic Hive. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Power Pylons :c/: Incoming",
		"Power Pylons :c/: Dropping"
	},
	MissionFinal_FallResponse = {
	-- The ground on the surface of the Volcanic Hive begins giving way. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Seismic Activity :c/: Detected",
		"Seismic Activity :c/: Detected -- #squad :>>: Watch Yourselves"
	},
	MissionFinal_Bomb = {
	-- All three Mechs have landed into the subterranean half of the Volcanic Hive. --
	-- For some reason, every vanilla Pilot is a whiny bitch and, in this line, complains that they can't take out the hive with their current firepower. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
	-- Overrides [MissionStart]. --
		"Current Weaponry :?/!/: Adequate :(): Hive Demolition",
		"Current Weaponry :!/: Adequate :(): Hive Demolition"
	},
	MissionFinal_CaveStart = {
	-- Played after the Renfield Bomb is dropped for the squad, when the Final Mission is actually started. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Fuck It -- We :>>: Ball",
		"Current Time :: Vek Ass Kicking Time"
	},
	MissionFinal_BombArmed = {
	-- The Renfield Bomb finishes arming itself, indicating the completion of the Final Mission. --
	-- Guaranteed. --
	-- Selects a random Pilot. --
		"Bomb :p/: Activated",
		"Bomb :c/: Active -- #squad :>>: Open A Breach"
	},
	TimeTravel_Win = {
	-- Played for all three pilots in sequence after [MissionFinal_BombArmed]. --
	-- Guaranteed. --
		"Wow",
		"Vek Extermination :p/: Successful",
		"Perhaps -- True Victory :: Friends :p/: Made Along Journey"
	},
}

--////////////////////////////////--
