
-- Notes: To use modApiExt's dialog functions, you need a version MORE RECENT than 1.12.260
-- Prior versions had bugs
-- modApiExt version 1.12.260 can be used, but you will need to adjust global.lua (copy this mod's file)

local function SelectedPersonalityRule(personality)
    return function(pawnId, cast)
        return Pawn and Pawn:GetId() == pawnId and Game:GetPawn(pawnId):GetPersonality() == personality
    end
end

local load = function()
	modapiext:addPawnUndoMoveHook(function(mission, pawn, oldPosition)
		if not GAME.convopause then
			-- We set a global "no conversations" flag so that multiple mods calling
			-- "Pilot_Story_Conversation" on move-undo can all check for this flag;
			-- only the first call will go through, and will then suppress others for
			-- 1 second
			GAME.convopause = true
			modApi:scheduleHook(1200, function()
				GAME.convopause = nil
			end)
			modapiext.dialog:triggerRuledDialog("Pilot_Story_Conversation")
			
		end
	end)
	-- Just to be safe, we clear the flag at mission start as well:
	modApi:addMissionStartHook(function(mission)
		GAME.convopause = nil
	end)
------------------------------------
	--Dialog that triggers when 'main' ends movement next to 'other'.
	--We check that 'main' has the right personality, 'other' has the right personality, and they are adjacent.
	modapiext.dialog:addRuledDialog("MoveEnd", { Unique = true, Odds = 10, Dialog(
			{ other = "Convo_metalocif_personality_flynn_personality1" },
			{ main = "Convo_metalocif_personality_flynn_personality2" },
			{ other = "Convo_metalocif_personality_flynn_personality3" }
		),
		CastRules = {
			main = SelectedPersonalityRule("metalocif_personality"),

			other = function(pawnId, cast)
				if not PersonalityRule("flynn_personality")(pawnId, cast) then
					return false
				end
				if not cast.main then
					return false
				end

				local p1 = Game:GetPawn(pawnId):GetSpace()
				local p2 = Game:GetPawn(cast.main):GetSpace()

				return p1:Manhattan(p2) == 1
			end
		}
	})
	--Banter goes here. Flynn says the first line, then Metalocif, then Flynn.
	Personality.flynn_personality.Convo_metalocif_personality_flynn_personality1 = { "Konnichiwa, Metalocif-kun ^-^." }
	Personality.metalocif_personality.Convo_metalocif_personality_flynn_personality2 = { "Hisashiburi desu ne~" }
	Personality.flynn_personality.Convo_metalocif_personality_flynn_personality3 = { "Genki?" }
------------------------------------
	-- modapiext.dialog:addRuledDialog("Pilot_Story_Conversation", 
	-- { Unique = true, Odds = 10,
		-- CastRules = {
			-- main = SelectedPersonalityRule("metalocif_personality"),
			-- other = PersonalityRule("NicoGeneric")
		-- },
		-- {
			-- { other = "Convo_Metalocif_Generic1" },
			-- { main = "Convo_Metalocif_Generic2" },
			-- { other = "Convo_Metalocif_Generic3" },
		-- }
	-- })
		
	-- Personality.metalocif_personality.Convo_Metalocif_Generic1 = { "Hey, Generic. Do you have the cyborg prototypes I asked you for?" }
	-- Personality.NicoGeneric.Convo_Metalocif_Generic2 = { "Testing is going nicely, but I've been busy piloting as of late." }
	-- Personality.metalocif_personality.Convo_Metalocif_Generic3 = { "Can you do 6 more for me?" }
	
	-- The above would work if Nico made his dialog file
------------------------------------
end

return{
	load = load,
}