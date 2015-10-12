
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
   composer.gotoScene("intro_2", options)
end

-- prevent memory loss
function checkMemory()
   collectgarbage( "collect" )
   local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
   --print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
end

-- "scene:create()"
function scene:create( event )
	print "game.lua: create"

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

	local panada_options = {
		width = 500,
		height = 318,
		numFrames = 4,
	}

	local pandaSheet = graphics.newImageSheet( "assets/images/panda_sprite.png", panada_options )
	local panda = display.newSprite( pandaSheet, { name="panda", start=1, count=4, time=1000 } )
	panda:scale(1.3, 1.3)
	panda.x = 350 
	panda.y = display.contentHeight - 300
	panda:play()
	sceneGroup:insert(panda)

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
      
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
	  	
		local introtext_content = "Oh no, Panda made his way into our server room! At " 
			.. "first he seemed to be captivated by the computer system's whirling and beeping, " 
			.."but it didn't take long for the sounds to anger him. Panda has now begun to rip "
			.."out the computer cables and hardware."

		local introtext_options = {
		    text = '',
		    x = display.contentCenterX,
		    y = 300,
		    width = display.contentWidth - 100,     --required for multi-line and alignment
		    font = "PTMono-Bold",   
		    fontSize = 40,
		}

		local introtext = display.newText( introtext_options )
		typeWriter(introtext, introtext_content)

		sceneGroup:insert(introtext)

	  	continue:addEventListener("tap", nextScene)
		composer.removeScene("start")	
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
