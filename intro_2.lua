
local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------
 
function updateDialog(dialog, str)
   return function()
      dialog.text = dialog.text .. str
    end
end

function typeWriter(dialog, str)
   for i = 1, #str do
       local letter = str:sub(i,i)
       local step = 50
       timer.performWithDelay(500 + step * i, updateDialog(dialog, letter))
   end
end

function nextScene(event)
   local options =
   {
       effect = "crossFade",
       time = 400,
   }
   composer.gotoScene("select", options)
end

-- prevent memory loss
function checkMemory()
   collectgarbage( "collect" )
   local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
   --print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
end

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   
   local background = display.newImageRect("assets/images/splashBg.jpg",900,1425)
   background.anchorX = 0.5
   background.anchorY = 1
   -- Place background image in center of screen
   background.x = display.contentCenterX
   background.y = display.contentHeight
   sceneGroup:insert(background)

   local introtext_content = "We need you to stop Panda before it's too late! Don't worry you won't have to complete "
      .."this task alone, you will have Gladys, the world's most powerful AI at your side. Gladys knows a lot but she "
      .."doesn't know how to defeat Panda. Hmm, a portal gun should do the trick. Help Gladys to improve her abilities "
      .."by learning to print and use a 3D portal gun. "

   local introtext_options = {
       text = '',
       x = display.contentCenterX,
       y = 325,
       width = display.contentWidth - 100,     --required for multi-line and alignment
       font = "PTMono-Bold",   
       fontSize = 40,
   }

   local introtext = display.newText( introtext_options )
   typeWriter(introtext, introtext_content)
   sceneGroup:insert(introtext)

   local gladys_options = {
      width = 420,
      height = 420,
      numFrames = 3
   }

   local gladysSheet = graphics.newImageSheet( "assets/images/gladys_sprite.png", gladys_options )
   local gladys = display.newSprite( gladysSheet, { name="gladys", start=1, count=3, time=1000 } )
   gladys:scale(1.5, 1.5)
   gladys.x = 275 
   gladys.y = display.contentHeight - 350
   gladys:play()
   sceneGroup:insert(gladys)

   continue = display.newImageRect("assets/images/continue.png",431,116)
   continue:scale(0.7, 0.7)
   continue.x = display.contentWidth - 175
   continue.y = display.contentHeight - 75
   sceneGroup:insert(continue)

end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      continue:addEventListener("tap", nextScene)
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
     
   composer.removeScene("intro_1") 
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
      continue:removeEventListener("tap", nextScene)
         sceneGroup = nil
     
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
