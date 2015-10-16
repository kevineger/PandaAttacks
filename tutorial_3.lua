local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

function nextTutorial()
   composer.gotoScene("start")
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Set the background
   background = display.newImageRect(sceneGroup, "assets/images/splashBg.jpg",900,1425)
   background.anchorX = 0.5
   background.anchorY = 1
   -- Place background image in center of screen
   background.x = display.contentCenterX
   background.y = display.contentHeight

   local introTextOptions = {
         text = 'In game 2 you are given a piece of code with bugs. Click on the piece of code that is incorrect. You have three lives to find all the bugs in the code segment.',
         x = display.contentCenterX,
         y = display.contentCenterY-300,
         width = display.contentWidth-100,
         fontSize = 40
   }
   introText = display.newText( introTextOptions )
   introText.alpha = 0

   screenShot = display.newImageRect(sceneGroup, "assets/images/tutorialGame2.png",388,627)
   screenShot.anchorX = 0.5
   screenShot.anchorY = 0.5
   screenShot.x = display.contentCenterX
   screenShot.y = display.contentCenterY+200

   nextBtn = display.newImageRect(sceneGroup, "assets/images/next.png",400,200)
   nextBtn:scale(.7,.7)
   nextBtn.anchorX = 1
   nextBtn.anchorY = 1
   nextBtn.x = display.contentWidth
   nextBtn.y = display.contentHeight
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      nextBtn:addEventListener("tap", nextTutorial)
   elseif ( phase == "did" ) then
      transition.to( introText , { time=1500, alpha=1 } )
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
      nextBtn:addEventListener("tap", nextTutorial)
      screenShot:removeSelf()
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