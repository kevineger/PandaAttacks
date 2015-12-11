local composer = require( "composer" )
local scene = composer.newScene()
local analytics = require("gameAnal")
local parse = require ("mod_parse")
local envVars = require("globals")

parse:init({
    appId = envVars.appId,
    apiKey = envVars.apiKey
    })

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

function goHome(event)
   local options =
   {
       effect = "crossFade",
       time = 400,
   }
   composer.gotoScene("start", options)
end

function nextScene(event)
   local options =
   {
       effect = "crossFade",
       time = 400,
   }
   composer.gotoScene("select", options)
end

-- -------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
function getUserScore(username)
    local query2 = {["where"] = {["scorePercent"] = {["$gt"] = analytics.getScorePercentG2() }}}
    parse:getObjects( "score_2", query2, function(e)
        if((#e.results)>5) then
            display.newText(sceneGroup, "...", display.contentCenterX, display.contentCenterY+215, native.systemFont, 50)
            display.newText(sceneGroup, (#e.results+1)..".", display.contentCenterX-200, display.contentCenterY+300, native.systemFont, 50 )
            display.newText(sceneGroup, analytics.getCorrectAnswerG2().."/"..analytics.getTotalAnswerG2(), display.contentCenterX, display.contentCenterY+300, native.systemFont, 50 )
            display.newText(sceneGroup, username, display.contentCenterX+200,display.contentCenterY+300, native.systemFont, 50)
        end
    end)
end

function getScoresG2(username)
    local query = { ["order"] = "-scorePercent", ["limit"] = "5" }
    analytics.resetTopPlayer()
    parse:getObjects( "score_2", query, function(e)
        display.newText(sceneGroup, "Rank", display.contentCenterX-200, display.contentCenterY-225, native.systemFont, 50)
        display.newText(sceneGroup, "Score", display.contentCenterX, display.contentCenterY-225, native.systemFont, 50)
        display.newText(sceneGroup, "Username", display.contentCenterX+200, display.contentCenterY-225, native.systemFont, 50)
        y = display.contentCenterY-150
        for i=1, #e.results do
            score_data = e.results[i]
            if(username==score_data.username) then
                analytics.setTopPlayer()
            end
            display.newText(sceneGroup, i..".", display.contentCenterX-200, y, native.systemFont, 50 )
            display.newText(sceneGroup, score_data.correct.."/"..score_data.total, display.contentCenterX, y, native.systemFont, 50 )
            display.newText(sceneGroup, score_data.username, display.contentCenterX+200, y, native.systemFont, 50)
            y = y + 75
        end
        getUserScore(username)
    end)
end
-- "scene:create()"
function scene:create( event )
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    sceneGroup = self.view
    background = display.newImageRect(sceneGroup, "assets/images/splashBg.jpg",900,1425)
    background.anchorX = 0.5
    background.anchorY = 1
    -- Place background image in center of screen
    background.x = display.contentCenterX
    background.y = display.contentHeight
    scoreboard = display.newImageRect(sceneGroup, "assets/images/scoreboard.png",300, 100)
    scoreboard.anchorX = 0.5
    scoreboard.anchorY = 0.5
    scoreboard.x = centerX
    scoreboard.y = centerY-350
    -- Home Button
    home = display.newImageRect(sceneGroup, "assets/images/home.png",370,370)
    home:scale(0.5, 0.5)
    home.anchorX = 0.5
    home.anchorY = 0.5
    home.x = 100
    home.y = display.contentHeight - 80
    home:addEventListener("tap", goHome)
    sceneGroup:insert(home)

   continue = display.newImageRect("assets/images/continue.png",431,116)
   continue:scale(0.7, 0.7)
   continue.x = display.contentWidth - 175
   continue.y = display.contentHeight - 75
   continue:addEventListener("tap", nextScene)
   sceneGroup:insert(continue)

    getScoresG2(event.params.username)
  
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene