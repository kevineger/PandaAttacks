local D = {}

local parse = require ("mod_parse")
local envVars = require("globals")

local g1Incorrect = 0
local g1Correct = 0
local g1Total = 0

local g2Incorrect = 0
local g2Correct = 2
local g2Total = 6

parse:init({
	appId = envVars.appId,
	apiKey = envVars.apiKey
	})

print ("APP ID: " .. envVars.appId)
print ("API KEY: " .. envVars.apiKey)

function D.updateTotal(table, objId, attribute)
	local result = parse:getObject(table, objId, function(e)
		if not e.error then
			print ("Retrieved object from parse")
			e.response[attribute] = e.response[attribute]+1
			parse:updateObject(table, objId, e.response, function(e2)
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

-- game 2 functions

function D.getCorrectAnswerG2()
	return g2Correct
end

function D.getTotalAnswerG2()
	return g2Total
end

function D.incorrectAnswerG2()
	g2Incorrect = g2Incorrect + 1
	g2Total = g2Total + 1
	print ("G2 Incorrect:"  .. g2Incorrect)
	print ("G2 Total:"  .. g2Total)
end

function D.getIncorrectAnswerG2()
	return g2Incorrect
end

function D.correctAnswerG2()
	g2Correct = g2Correct + 1
	g2Total = g2Total + 1
	print ("G2 Correct:"  .. g2Correct)
	print ("G2 Total:"  .. g2Total)
end

function D.getCorrectAnswerG2()
	return g2Correct
end

function D.getTotalAnswerG2()
	return g2Total
end
function D.getScorePercentG2()
	return g2Correct/g2Total
end

-- function sends game analytics to parse
function D.sendToParse(parseTable, values)
-- parseTable = "table_name", values = {["col1"] = var1, ["col2"] = var2, ["col3"] = var3}
	parse:createObject(parseTable, values, function(e)
		if not e.error then
			print ("Sent to Parse")
		else
			print (e.error)
		end
	end
	)
end

function D.sendErrorsFound(errors)
	if errors[4] then 
		D.sendToParse("game_2_3", {["error_1"] = errors[1], ["error_2"] = errors[2], ["error_3"] = errors[3], ["error_4"] = errors[4]})

	elseif errors[3] then
		D.sendToParse("game_2_3", {["error_1"] = errors[1], ["error_2"] = errors[2], ["error_3"] = errors[3]})

	elseif errors[2] then
		D.sendToParse("game_2_3", {["error_1"] = errors[1], ["error_2"] = errors[2]})

	elseif errors[1] then
		D.sendToParse("game_2_3", {["error_1"] = errors[1]})
	end

end

function D.reset()
	g1Incorrect = 0
	g1Correct = 0
	g1Total = 0

	g2Incorrect = 0
	g2Correct = 0
	g2Total = 0
end

function D.getQNum()
	local query = { ["order"] = "-num", ["limit"] = "1" }
	parse:getObjects( "questions_2", query, function(e)
		 qnum = e.results[1].num
	end)
end

return D