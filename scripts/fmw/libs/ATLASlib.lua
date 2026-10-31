local this = {}

-- the vanilla Pawn object is pretty weird since it sometimes won't update,
-- even if you have a pawn selected
function this.Pawn()
	if Board then
		for i, p in pairs(extract_table(Board:GetPawns(TEAM_ANY))) do
			local p = Board:GetPawn(p)

			if p:IsSelected() then
				return p
			end
		end
	end
end

-- returns length of hash table
function this.hashLen(t)
	local n = 0

	for _,_ in pairs(t) do
		n = n + 1
	end

	return n
end

-- null safe version of Board:GetPawn()
this.GetPawn = {}
setmetatable(this.GetPawn, {
	__call = function(self, pawn)
		if not pawn then
			local t = {}

			setmetatable(t, {
				__index = function()
					return function() return end
				end
			})

			return t
		elseif Board then
			return Board:GetPawn(pawn)
		end
	end
})

return this
