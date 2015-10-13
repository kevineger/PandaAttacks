local composer = require( "composer" )
local scene = composer.newScene()
local question = require("questions")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local currScore = 0
local total = 4
local lives = 3

--local r = Math.random(10)

--circles word when clicked
local function clickError( event )


   circle = display.newCircle(sceneGroup, event.target.x, event.target.y, event.target.width/2)
   circle:setFillColor(0,0,0,0)
   circle.strokeWidth = 3
   circle:setStrokeColor(1,0,0)
   circle.anchorX = 0
   circle.anchorY = 0.75

   --increase score when correct error is clicked
   if event.target.error == true then
      currScore = currScore + 1
      scoreDisplay.text = currScore

   else
      heart[lives]:removeSelf()
      lives = lives-1
   end

   --all errors have been found
   if currScore == total then
      display.newText(sceneGroup, "GAME COMPLETED", centerX, display.contentHeight-100, native.systemFont, 60)

   elseif lives == 0 then
      --gameOver()
   end
end

--sets a string to separate clickable objects
local function setQuestion()

   s = errorCode[2].questionString

   clickableString = {}

   local t = {}
   local x = centerX-200
   local y = centerY-100


   i=1
   for str in string.gmatch(s, "([^%s]+)") do

      -- increase y when special character /n is found
      -- if str == string.gmatch(s, "([^%c]+)") then
      --    y = y +30
      -- end

      clickableString[i] = display.newText(str, x, y, native.systemFont, 50)
      clickableString[i].anchorX = 0
      clickableString[i].anchorY = 1
      clickableString[i].word = str
      clickableString[i].error = false
      clickableString[i]:addEventListener("tap", clickError)

      --x position depends on the question before
      x = clickableString[i].x + (string.len(str)*25)

      i = i + 1

   end

   --sets which objects are errors
   for i = 1, #clickableString do
      for j =1, #errorCode[2].error do
         if clickableString[i].word == errorCode[2].error[j] then 
            clickableString[i].error = true
            break
         end
      end
   end

end


-- "scene:create()"
function scene:create( event )

   sceneGroup = self.view

   background = display.newImageRect(sceneGroup, "assets/images/splashBg.jpg",900,1425)
   background.anchorX = 0.5
   background.anchorY = 1
   -- Place background image in center of screen
   background.x = display.contentCenterX
   background.y = display.contentHeight

   local text = display.newText(sceneGroup,"Question", centerX, 200, native.systemFont, 50)

   scoreDisplay = display.newText(sceneGroup, currScore, 50, 200, native.systemFont, 50)
   local totalDisplay = display.newText(sceneGroup,"/"..total, 90, 200, native.systemFont, 50)

   heart = {}

   local x = 100
   for i = 1, 3 do
      heart[i] = display.newImage(sceneGroup, "assets/images/life.png", x, display.contentHeight-100)
      heart[i]:scale(2,2)
      x = x + 100
   end

   
   
end


-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      setQuestion()

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

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene