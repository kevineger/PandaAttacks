local composer = require( "composer" )
local analytics = require("gameAnal")
local parse = require ("mod_parse")
local envVars = require("globals")

parse:init({
    appId = envVars.appId,
    apiKey = envVars.apiKey
    })

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
function goHome(event)

   local options =
   {
       effect = "crossFade",
       time = 400,
   }
   composer.gotoScene("start", options)

end

-- -------------------------------------------------------------------------------

function sendQuestion(qnum)
    parse:createObject("questions_2", {["question"] = question.text, ["error1"] = error1.text, ["error2"]=error2.text, ["error3"]=error3.text, ["error4"]=error4.text, ["num"]=qnum}, function(e)
            if not e.error then
                print("sent Question")
                local options =
                {
                effect = "crossFade",
                time = 400,
                }

                composer.gotoScene("select", options)
            else
                print (e.error)
            end
        end)
end
function submitQ()

    local query = { ["order"] = "-num", ["limit"] = "1" }
    parse:getObjects( "questions_2", query, function(e)
         qnum = e.results[1].num + 1
         sendQuestion(qnum)
    end)

    -- question:removeSelf()
    -- error1:removeSelf()
    -- error2:removeSelf()
    -- error3:removeSelf()
    -- error4:removeSelf()

end
-- "scene:create()"
function scene:create( event )

    sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    background = display.newImageRect(sceneGroup, "assets/images/splashBg.jpg",900,1425)
    background.anchorX = 0.5
    background.anchorY = 1
    -- Place background image in center of screen
    background.x = display.contentCenterX
    background.y = display.contentHeight

    createQ = display.newImageRect(sceneGroup, "assets/images/create_questions.png",300, 100)
    createQ.anchorX = 0.5
    createQ.anchorY = 0.5
    createQ.x = centerX
    createQ.y = centerY-500

    note= display.newText(sceneGroup, "Create a question for game 2 ( %n for new line, %t for tab )", centerX, centerY-390, display.contentWidth-100, 100, native.systemFont, 40 )

    -- Home Button
    home = display.newImageRect(sceneGroup, "assets/images/home.png",370,370)
    home:scale(0.5, 0.5)
    home.anchorX = 0.5
    home.anchorY = 0.5
    home.x = 100
    home.y = display.contentHeight - 80
    home:addEventListener("tap", goHome)
    sceneGroup:insert(home)

    setupInputs()
    
    submit = display.newImageRect(sceneGroup, "assets/images/submit.png", 480, 144)
    submit:scale(0.5, 0.5)
    submit.anchorX = 0.5
    submit.anchorY = 0.5
    submit.x = centerX
    submit.y = centerY+300
    submit:addEventListener("tap", submitQ)
    sceneGroup:insert(submit)
end
function setupInputs()
    labelq= display.newText(sceneGroup, "Question", centerX-200, centerY-300, native.systemFont, 50 )
    question = native.newTextField( centerX, centerY-150, display.contentWidth-100, 200 )
    question.font = native.newFont( native.systemFont, 40 )
    label1 = display.newText(sceneGroup, "Error 1", centerX-200, centerY+30 )
    error1 = native.newTextField( centerX-200, centerY+100, 100, 80 )
    error1.font = native.newFont( native.systemFont, 40 )
    label2 = display.newText(sceneGroup, "Error 2", centerX-75, centerY+30 )
    error2 = native.newTextField( centerX-75, centerY+100, 100, 80 )
    error2.font = native.newFont( native.systemFont, 40 )
    label3 = display.newText(sceneGroup, "Error 3", centerX+75, centerY+30 )
    error3 = native.newTextField( centerX+75, centerY+100, 100, 80 )
    error3.font = native.newFont( native.systemFont, 40 )
    label4 = display.newText(sceneGroup, "Error 4", centerX+200, centerY+30 )
    error4 = native.newTextField( centerX+200, centerY+100, 100, 80 )
    error4.font = native.newFont( native.systemFont, 40 )
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
    question:removeSelf()
    error1:removeSelf()
    error2:removeSelf()
    error3:removeSelf()
    error4:removeSelf()
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