
local composer = require( "composer" )
local scene = composer.newScene()

local mydata = require( "mydata" )

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

-- prevent memory loss
function checkMemory()
   collectgarbage( "collect" )
   local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
   --print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
end


-- "scene:create()"
function scene:create( event )

   	local sceneGroup = self.view
   
   	gameStarted = false
   	mydata.score = 0

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
	
   	local background = display.newRect(0,0, display.contentWidth ,display.contentHeight)
	background:setFillColor( 255, 255, 255 )  
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)

	local introtext_content = "Oh no, a panda made his way into our server room! At " 
		.. "first the panda seemed captivated by the computer system’s whirling and beeping, " 
		.."but it didn’t take long for the sounds to anger him. He has now begun to rip "
		.."out the computer cables and hardware."

   	local introtext_options = {
	    text = introtext_content,
	    x = 400,
	    y = 200,
	    width = display.contentWidth-100,     --required for multi-line and alignment
	    font = native.systemFont,   
	    fontSize = 40,
	}

   	local introtext = display.newText(introtext_options)
	introtext:setFillColor(0,0,0)
	sceneGroup:insert(introtext)

	panada_options = {
		-- Required params
		width = 500,
		height = 318,
		numFrames = 4,
	}

	pandaSheet = graphics.newImageSheet( "assets/images/panda_sprite.png", panada_options )
	panda = display.newSprite( pandaSheet, { name="panda", start=1, count=4, time=1000 } )
	panda.anchorX = 0.5
	panda.anchorY = 0.5 - 100
	panda.x = display.contentCenterX
	panda.y = display.contentCenterY
	panda:play()
	sceneGroup:insert(panda)

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
	--Runtime:removeEventListener("touch", flyUp)
	--Runtime:removeEventListener("enterFrame", platform)
	--timer.cancel(addColumnTimer)
	--timer.cancel(moveColumnTimer)
	  
	  
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













