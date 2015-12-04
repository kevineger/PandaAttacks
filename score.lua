S = {}

local parse = require ("mod_parse")
local envVars = require("globals")
local analytics = require("gameAnal")

local centerX = display.contentCenterX
local centerY = display.contentCenterY
topPlayer = false
parse:init({
	appId = envVars.appId,
	apiKey = envVars.apiKey
	})

function S.getScoresG2(username)
	
	local query = { ["order"] = "-scorePercent", ["limit"] = "5" }
	topPlayer = false
	parse:getObjects( "score_2", query, function(e)
		display.newText(sceneGroup, "Rank", display.contentCenterX-200, display.contentCenterY-225, native.systemFont, 50)
		display.newText(sceneGroup, "Score", display.contentCenterX, display.contentCenterY-225, native.systemFont, 50)
		display.newText(sceneGroup, "Username", display.contentCenterX+200, display.contentCenterY-225, native.systemFont, 50)
		y = display.contentCenterY-150
		for i=1, #e.results do
			score_data = e.results[i]
			if(username==score_data.username) then
				topPlayer = true
			end
			display.newText(sceneGroup, i..".", display.contentCenterX-200, y, native.systemFont, 50 )
			display.newText(sceneGroup, score_data.correct.."/"..score_data.total, display.contentCenterX, y, native.systemFont, 50 )
			display.newText(sceneGroup, score_data.username, display.contentCenterX+200, y, native.systemFont, 50)
			y = y + 75
		end
	end)
	
	local query2 = {["where"] = {["scorePercent"] = {["$gt"] = analytics.getScorePercentG2() }}}
	parse:getObjects( "score_2", query2, function(e)
		if(#e.results+1>5) then
			display.newText(sceneGroup, "...", display.contentCenterX, display.contentCenterY+215, native.systemFont, 50)
			display.newText(sceneGroup, (#e.results+1)..".", display.contentCenterX-200, display.contentCenterY+300, native.systemFont, 50 )
			display.newText(sceneGroup, analytics.getCorrectAnswerG2().."/"..analytics.getTotalAnswerG2(), display.contentCenterX, display.contentCenterY+300, native.systemFont, 50 )
			display.newText(sceneGroup, username, display.contentCenterX+200,display.contentCenterY+300, native.systemFont, 50)
		end
	end)
	
end



return S