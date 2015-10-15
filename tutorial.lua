local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

function nextTutorial()
   composer.gotoScene("tutorial_1")
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
         text = 'Panda Attacks is an educational game that focuses on iterative learning. You will always be prompted on what to do at each stage of the game. To see an overview of the two mini-games, navigate using the buttons below.',
         x = display.contentCenterX,
         y = display.contentCenterY,
         width = display.contentWidth-100,
         fontSize = 40
   }
   introText = display.newText( introTextOptions )
   introText.alpha = 0

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
   elseif ( phase == "did" ) then
      transition.to( introText , { time=1500, alpha=1 } )
      nextBtn:addEventListener("tap", nextTutorial)
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
      nextBtn:removeEventListener("tap", nextTutorial)
      introText:removeSelf();
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