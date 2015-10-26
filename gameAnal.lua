local D = {}

local parse = require ("mod_parse")

local envVars = require("globals")

local g1Incorrect = 0
local g1Correct = 0
local g1Total = 0

parse:init({
	appId = envVars.appId,
	apiKey = envVars.apiKey
	})

print ("APP ID: " .. envVars.appId)
print ("API KEY: " .. envVars.apiKey)

function D.part1Play()
	local result = parse:getObject("game_1_3", "goYQo4jfYF", function(e)
		if not e.error then
			print ("Retrieved object from parse")
			e.response["game_1_plays"] = e.response["game_1_plays"]+1
			parse:updateObject("game_1_3", "goYQo4jfYF", e.response, function(e2)
					if not e2.error then
						print("Updated object in parse")
					else
						print (e2.error)
					end
				end
				)
		else
			print (e.error)
		end
	end
	)
end

function D.part2Play()
	local result = parse:getObject("game_1_3", "goYQo4jfYF", function(e)
		if not e.error then
			print ("Retrieved object from parse")
			e.response["game_2_plays"] = e.response["game_2_plays"]+1
			parse:updateObject("game_1_3", "goYQo4jfYF", e.response, function(e2)
					if not e2.error then
						print("Updated object in parse")
					else
						print (e2.error)
					end
				end
				)
		else
			print (e.error)
		end
	end
	)
end

function D.incorrectAnswerG1()
	g1Incorrect = g1Incorrect + 1
	g1Total = g1Total + 1
	print ("G1 Incorrect:"  .. g1Incorrect)
	print ("G1 Total:"  .. g1Total)
end

function D.correctAnswerG1()
	g1Correct = g1Correct + 1
	g1Total = g1Total + 1
	print ("G1 Correct:"  .. g1Correct)
	print ("G1 Total:"  .. g1Total)
end

function D.getIncorrectAnswerG1()
	return g1Incorrect
end

function D.getCorrectAnswerG1()
	return g1Correct
end

function D.getTotalAnswerG1()
	return g1Total
end

function D.checkForTypo(actualString, enteredString)
	-- Send actualString to char array
	actualStringChars = {}
	for i in string.gmatch(actualString, ".") do
		actualStringChars[#actualStringChars+1] = i
	end
	-- Send enteredString to char array
	enteredStringChars = {}
	for i in string.gmatch(enteredString, ".") do
		enteredStringChars[#enteredStringChars+1] = i
	end
	-- Foreach char in the enteredString array, if index
	-- of char is not within 1 s.d. away, mark as false (no typo)
	-- else return true (typo)
	local typo = true
	for key,value in pairs(enteredStringChars) do
		if (actualStringChars[key-1] ~= value and actualStringChars[key] ~= value and actualStringChars[key+1] ~= value) then
			typo = false
		end
	end
	print ("Typo: " .. tostring(typo))
	-- Send results to parse
	D.sendToParse("game_1_2", {["actual_text"] = actualString, ["entered_text"] = enteredString, ["typo"] = typo})
	return typo
end

function D.sendToParse(parseTable, values)
-- {["incorrect"] = g1Incorrect, ["correct"] = g1Correct, ["total"] = g1Total}
	parse:createObject(parseTable, values, function(e)
		if not e.error then
			print ("Sent to Parse")
		else
			print (e.error)
		end
	end
	)
end

return D