
---------------------------------------------------------------------
-- Trait v1.0 - code library
---------------------------------------------------------------------
-- add a trait description and icon to the tooltip of a unit type.
-- this system should only be used to give traits to pawn types
-- created by the mod it is used in, and can not be used to give
-- unit types traits in any dynamic way.
-- max one per unit type.

local path = mod_loader.mods[modApi.currentMod].resourcePath
local this = {
	traits = {},
	descs = {},
	tips = {},
	enabled = {},
	version = {},
	icons = {}
}

local function file_exists(name)
	local f = io.open(name, "r")
	if f then io.close(f) return true else return false end
end

-- return the description of the trait.
local oldGetStatusTooltip = GetStatusTooltip
function GetStatusTooltip(id)
	for name, desc in pairs(this.descs) do
		if id == name then
			return desc
		end
	end
	
	return oldGetStatusTooltip(id)
end

-- only call on init.
-- name should be somewhat unique, to avoid collisions with other mods.
-- TODO: manipulate name to be unique after the fact?
function this:Add(name, pilotSkills, icon, iconGlow, desc, tip, isTrait)
	assert(type(name) == 'string')
	
	if type(pilotSkills) == 'string' then
		pilotSkills = {pilotSkills}
	end
	
	assert(type(pilotSkills) == 'table')
	
	for _, pilotSkill in ipairs(pilotSkills) do
		assert(type(pilotSkill) == 'string')
		isTrait = isTrait or function() return true end
		assert(type(isTrait) == 'function')
		
		self.traits[pilotSkill] = function(pawn) return isTrait(pawn) and name or nil end
	end
	
	assert(type(desc) == 'table')
	desc.title = desc.title or desc[1]
	desc.text = desc.text or desc[2]
	
	assert(type(desc.title) == 'string')
	assert(type(desc.text) == 'string')
	
	this.descs[name] = desc
	
	if tip then
		if type(tip) == 'string' then
		else
			assert(type(tip) == 'table')
			tip.title = tip.title or tip[1]
			tip.text = tip.text or tip[2]
			
			assert(type(tip.title) == 'string')
			assert(type(tip.text) == 'string')
			
			Global_Texts[name .."_Text"] = tip.text
			Global_Texts[name .."_Title"] = tip.title
			
			this.tips[name] = true
		end
	end
	
	if type(icon) == 'string' then
		icon = {path = icon, loc = Point(0,0)}
	end
	
	if type(iconGlow) == 'string' then
		iconGlow = {path = iconGlow, loc = Point(0,0)}
	end
	
	if type(icon) == 'table' then
		icon.path = icon.path or icon[1]
		icon.loc = icon.loc or icon[2]
		
		if file_exists(path .. icon.path) then
			modApi:appendAsset("img/combat/icons/icon_".. name ..".png", path .. icon.path)
			Location["combat/icons/icon_".. name ..".png"] = icon.loc
		end
	end
	
	if type(iconGlow) == 'table' then
		iconGlow.path = iconGlow.path or iconGlow[1]
		iconGlow.loc = iconGlow.loc or iconGlow[2]
		
		if file_exists(path .. iconGlow.path) then
			modApi:appendAsset("img/combat/icons/icon_".. name .."_glow.png", path .. iconGlow.path)
			Location["combat/icons/icon_".. name .."_glow.png"] = iconGlow.loc
		end
	end
end

-- reset the tip of a trait.
function this:ResetTip(name)
	if not name then
		for name, _ in pairs(self.tips) do
			modApi:writeProfileData(name, false)
		end
	end
	
	if self.tips[name] then
		modApi:writeProfileData(name, false)
	end
end

function this:load()

	modApi:addPostLoadGameHook(function()
		self.icons = {}
		self.enabled = {}
		self.version = {}
	end)
	
	modApi:addMissionUpdateHook(function(mission)
		-- all icons currently tracked
		--LOG("ya")
		local trackedIcons = shallow_copy(self.icons)
		
		for _, pawnId in ipairs(extract_table(Board:GetPawns(TEAM_ANY))) do
			trackedIcons[pawnId] = nil
			
			local pawn = Board:GetPawn(pawnId)
			--if pawn:GetPersonality() then LOG("a:              "..pawn:GetPersonality()) end
			local trait = self.traits[pawn:GetPersonality()]
			
			-- If trait exists but is disabled, also check for version 2
			local version = 1
			if trait then
				trait0 = trait(pawn)
				if not trait0 then
					trait = self.traits[pawn:GetPersonality()..2]
					version = 2
				end
			end
			
			if trait then
				trait = trait(pawn)
				local loc = pawn:GetSpace()
				local oldLoc = self.icons[pawnId]
				local enabled = trait and true
				local oldEnabled = self.enabled[pawnId]
				local oldVersion = self.version[pawnId]
				
				-- clear location if trait is off.
				if not trait and oldLoc then
					self.icons[pawnId] = nil
					self.enabled[pawnId] = nil
					self.version[pawnId] = nil
					Board:SetTerrainIcon(oldLoc, "")
				end
				
				if trait then
					-- need to update if location, enabled status, or version changed
					if (loc ~= oldLoc) or (enabled ~= oldEnabled) or (version ~= oldVersion) then
						self.icons[pawnId] = loc
						self.enabled[pawnId] = true
						self.version[pawnId] = version
						
						-- clear old loc of it's icon.
						if oldLoc then
							Board:SetTerrainIcon(oldLoc, "")
						end
						
						-- add icon to new loc.
						Board:SetTerrainIcon(loc, trait)
						
						if self.tips[trait] and not modApi:readProfileData(trait) then
							Game:AddTip(trait, loc)
							modApi:writeProfileData(trait, true)
						end
					end
				end
			end
		end
		
		for pawnId, loc in pairs(trackedIcons) do
			self.icons[pawnId] = nil
			self.enabled[pawnId] = nil
			self.version[pawnId] = nil
			
			Board:SetTerrainIcon(loc, "")
		end
	end)
end

return this