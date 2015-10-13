
local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
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

function setFont()
  local platform = system.getInfo("platformName")
    
    local customFont = native.systemFontBold

    if ( platform == "Mac OS X" or platform == "iPhone OS" ) then
        return "PTMono-Bold"
    elseif ( platform == "Android") then
      return "PTMono.ttc"
    end

    return customFont
end

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   
   typeWriterFont = setFont()

   local background = display.newImageRect("assets/images/splashBg.jpg",900,1425)
   background.anchorX = 0.5
   background.anchorY = 1
   -- Place background image in center of screen
   background.x = display.contentCenterX
   background.y = display.contentHeight
   sceneGroup:insert(background)

   local sprite_options = {
      width = 420,
      height = 420,
      numFrames = 2
   }

   local spriteSheet = graphics.newImageSheet( "assets/images/winning_1.png", sprite_options )
   local sprite = display.newSprite( spriteSheet, { name="sprite", start=1, count=2, time=800 } )
   sprite:scale(1.3, 1.3)
   sprite.x = display.contentCenterX
   sprite.y = display.contentCenterY + 150
   sprite:play()
   sceneGroup:insert(sprite)

   continue = display.newImageRect("assets/images/continue.png",431,116)
   continue:scale(0.7, 0.7)
   continue.x = display.contentWidth - 175
   continue.y = display.contentHeight - 75
   sceneGroup:insert(continue)

   -- Home Button
   home = display.newImageRect(sceneGroup, "assets/images/home.png",370,370)
   home:scale(0.5, 0.5)
   home.anchorX = 0.5
   home.anchorY = 0.5
   home.x = 100
   home.y = display.contentHeight - 80
   sceneGroup:insert(home)

end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      continue:addEventListener("tap", nextScene)
      home:addEventListener("tap", goHome)
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
      
      local introtext_content = "Great job, you made a portal gun and you unlocked the INSERT GAME TITLE. "
        .. "Now, continue your misson and stop Panda!"

      local introtext_options = {
          text = '',
          x = display.contentCenterX,
          y = 325,
          width = display.contentWidth - 100,     --required for multi-line and alignment
          font = typeWriterFont,   
          fontSize = 40,
      }

      local introtext = display.newText( introtext_options )
      typeWriter(introtext, introtext_content)
      sceneGroup:insert(introtext)  


   composer.removeScene("game_1") 
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
      home:removeEventListener("tap", goHome)     
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
