local D = {}

-- Params:
-- -- s:string
-- -- len_s:int
-- -- t:string
-- -- len_t:int
local lavenshteinDistance
lavenshteinDistance = function (s, len_s, t, len_t)
	local cost = 0

	-- Base case (strings are empty)
	if (len_s == 0) then return len_t end
	if (len_t == 0) then return len_s end

	-- Test if last characters of strings match
	if (s:sub(len_s,len_s) == t:sub(len_t,len_t)) then
		cost = 0
	else
		cost = 1
	end
	-- Return minimum of delete char from s, delete char from t and delete char from both
	return math.min(
			lavenshteinDistance(s, len_s - 1, t, len_t) + 1,
            lavenshteinDistance(s, len_s, t, len_t - 1) + 1,
            lavenshteinDistance(s, len_s - 1, t, len_t - 1) + cost
		)
end

function D.isTypo(target, source, tolerance)
	source_length=source:len()
	target_length=target:len()
	lDist = lavenshteinDistance(source, source_length, target, target_length)
	if (lDist > tolerance) then
		print("Source: " .. source .. " | Target: " .. target .. " | Result: Not a typo")
		return false
	end
	print("Source: " .. source .. " | Target: " .. target .. " | Result: Typo")
	return true
end

return D