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

-- local forward references should go here

-- -------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local function addScore()
    parse:createObject("score_2", {["incorrect"] = analytics.getIncorrectAnswerG2(), ["correct"] = analytics.getCorrectAnswerG2(), ["total"] = analytics.getTotalAnswerG2(), ["scorePercent"] = analytics.getScorePercentG2(), ["username"] = userInput.text}, function(e)
        if not e.error then
            local options =
               {
                   effect = "crossFade",
                   time = 400,
                   params = {
                        username = userInput.text
                    }
               }
             composer.gotoScene("scoreboard_2", options)
        end
    end)
    
end

local function skipScore()
    local options =
   {
       effect = "crossFade",
       time = 400,
   }
    composer.gotoScene("select", options)
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    background = display.newImageRect(sceneGroup, "assets/images/splashBg.jpg",900,1425)
    background.anchorX = 0.5
    background.anchorY = 1
    -- Place background image in center of screen
    background.x = display.contentCenterX
    background.y = display.contentHeight
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    local title = display.newText(sceneGroup, "Score "..analytics.getCorrectAnswerG2().."/"..analytics.getTotalAnswerG2().." (correct/attempts)", centerX, 75, native.systemFont, 40)
    local userScore = display.newText(sceneGroup, "Enter a username", centerX, 130, native.systemFont, 40)

    userInput = native.newTextField( centerX, 250, 300, 100 )

    submit = display.newImageRect(sceneGroup, "assets/images/submit.png",480,144)
    submit:scale(0.5, 0.5)
    submit.anchorX = 0.5
    submit.anchorY = 1
    submit.x = centerX-125
    submit.y = 400
    submit:addEventListener("tap", addScore)

    skip = display.newImageRect(sceneGroup, "assets/images/skip.png",296,158)
    skip:scale(0.5, 0.5)
    skip.anchorX = 0.5
    skip.anchorY = 1
    skip.x = centerX+125
    skip.y = 400
    skip:addEventListener("tap", skipScore)
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
        userInput:removeSelf()
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