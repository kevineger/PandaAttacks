local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Set the background
   background = display.newImageRect(sceneGroup, "assets/images/splashBg.jpg",900,1425)
   background.anchorX = 0.5
   background.anchorY = 1
   -- Place background image in center of screen
   background.x = display.contentCenterX
   background.y = display.contentHeight

   -- Select Text
   play = display.newImageRect(sceneGroup, "assets/images/play.png",800,300)
   play:scale(0.7, 0.7)
   play.anchorX = 0.5
   play.anchorY = 1
   play.x = display.contentCenterX
   play.y = display.contentHeight - 600

   -- Adds level one icon
   levelOne = display.newImageRect(sceneGroup, "assets/images/levelOneGrey.png",700,700)
   levelOne:scale(0.5, 0.5)
   levelOne.anchorX = 0.5
   levelOne.anchorY = 1
   levelOne.x = display.contentCenterX - 150
   levelOne.y = display.contentHeight - 500

   -- Adds level two icon
   levelTwo = display.newImageRect(sceneGroup, "assets/images/levelTwo.png",700,700)
   levelTwo:scale(0.5, 0.5)
   levelTwo.anchorX = 0.5
   levelTwo.anchorY = 1
   levelTwo.x = display.contentCenterX + 150
   levelTwo.y = display.contentHeight - 500
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

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene