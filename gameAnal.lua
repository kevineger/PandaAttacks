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

function D.incorrectAnswerG1()
	g1Incorrect = g1Incorrect + 1
	g1Total = g1Total + 1
	print ("G1 Incorrect:"  .. g1Incorrect)
	print ("G1 Total:"  .. g1Total)
end

function D.getIncorrectAnswerG1()
	return g1Incorrect
end

function D.correctAnswerG1()
	g1Correct = g1Correct + 1
	g1Total = g1Total + 1
	print ("G1 Correct:"  .. g1Correct)
	print ("G1 Total:"  .. g1Total)
end

function D.getCorrectAnswerG1()
	return g1Correct
end

function D.getTotalAnswerG1()
	return g1Total
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