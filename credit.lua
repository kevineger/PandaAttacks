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

---------------------------------------------------------------------------------
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
   typeWriterFont = setFont()
   -- Set the background
   local background = display.newImageRect(sceneGroup, "assets/images/splashBg.jpg",900,1425)
   background.anchorX = 0.5
   background.anchorY = 1
   -- Place background image in center of screen
   background.x = display.contentCenterX
   background.y = display.contentHeight
   sceneGroup:insert(background)

   -- Title Text
   local title = display.newImageRect(sceneGroup, "assets/images/credits_title.png",519,356)
   title.x = display.contentCenterX
   title.y = 200
   sceneGroup:insert(title)

   -- Home Button
   home = display.newImageRect(sceneGroup, "assets/images/home.png",370,370)
   home:scale(0.5, 0.5)
   home.x = 100
   home.y = 150
   sceneGroup:insert(home)

end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      home:addEventListener("tap", goHome)
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.

      local text_content = "Background Image: https://pixabay.com/en/room-background-dark-shadow-wall-315257/"
      	.. "\n\nNumber 1: https://thenounproject.com/search/?q=number%20one&i=60413"
      	.. "\n\nNumber 2: https://thenounproject.com/search/?q=number+two&i=61038"
      	.. "\n\nDrum Audio: https://www.freesound.org/people/Taira%20Komori/sounds/213324/"
      	.. "\n\nSoundtrack: http://incompetech.com/music/royalty-free/index.html?isrc=USUAN1100640"
      	.. "\n\nPanda: http://vector.me/browse/330110/panda02"
      	.. "\n\nComputers: http://vector.me/browse/129833/web_virtualization_server_clip_art"
      	.. "\n\nElectric Spark: http://vector.me/browse/105213/electric_spark_clip_art"
      	.. "\n\nGladys: http://vector.me/browse/193991/robot_carrying_things_clip_art"
      	.. "\n\nPortal: http://vector.me/browse/426498/whirlpool"
      	.. "\n\nPortal Gun: http://vector.me/browse/690762/futuristic_gun"

      local text_options = {
          text = text_content,
          x = display.contentCenterX,
          y = 900,
          width = display.contentWidth - 100,     --required for multi-line and alignment
          font = typeWriterFont,   
          fontSize = 40,
      }

      local introtext = display.newText( text_options )
      sceneGroup:insert(introtext)
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
      home:removeEventListener("tap", goHome)
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