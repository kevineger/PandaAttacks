local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references
local backingMusic
local bassBoom

function startGame(event)
   composer.gotoScene("game")
end

function blurBackground(bg, p)
   -- Blur the background
   bg.fill.effect = "filter.blurVertical"
   bg.fill.effect.blurSize = 20
   bg.fill.effect.sigma = 140
   -- Blur the PLAY text
   p.fill.effect = "filter.blurHorizontal"
   p.fill.effect.blurSize = 80
   p.fill.effect.sigma = 200
   -- Display the panda
   displayPanda()
   -- Play the audio
   -- audio.play(bassBoom)
   -- After x miliseconds, return the background to original form
   normalTimer = timer.performWithDelay(300,
      function()
         -- Normalize the background
         normalBackground(bg, p)
         title:scale(0.5, 0.5)
         title.rotation = 0
      end, 1)
end

-- normalize the background
function normalBackground(bg, p)
   bg.fill.effect = nil
   p.fill.effect = nil
   panda:removeSelf()
   blurTimer = timer.performWithDelay(math.random(500, 6000),
      function()
         blurBackground(bg, p)
      end, 1)
end

-- display the panda
function displayPanda()
   panda = display.newImageRect(sceneGroup, "assets/images/panda.png", 1000, 1000)
   panda:scale(0.5, 0.5)
   panda.anchorX = 0.5
   panda.anchorY = 0.5
   -- Increase Title Size
   title:scale(2, 2)
   title.rotation = 20
   local side = math.random(0, 1)
   if ( side == 0 ) then
      -- Left Side
      panda.x = 120
      panda.y = display.contentHeight - math.random(100, 800)
      panda.rotation = 60

   elseif ( side == 1 ) then
      -- Right Side
      panda.x = display.contentWidth - 80
      panda.y = display.contentHeight - math.random(100, 800)
      panda.rotation = 300
   end

end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
   print "Creating Scene"

   sceneGroup = self.view

   -- Load the audio tracks
   backingMusic = audio.loadStream("assets/audio/backgroundMusic.mp3")
   bassBoom = audio.loadSound("assets/audio/drum.mp3")

   -- Set the background
   background = display.newImageRect(sceneGroup, "assets/images/splashBg.jpg",900,1425)
   background.anchorX = 0.5
   background.anchorY = 1
   -- Place background image in center of screen
   background.x = display.contentCenterX
   background.y = display.contentHeight

   title = display.newImageRect(sceneGroup, "assets/images/PandaAttacks.png",800,300)
   title:scale(0.7, 0.7)
   title.anchorX = 0.5
   title.anchorY = 1
   title.x = display.contentCenterX
   title.y = display.contentHeight - 900

   play = display.newImageRect(sceneGroup, "assets/images/play.png",800,300)
   play:scale(0.7, 0.7)
   play.anchorX = 0.5
   play.anchorY = 1
   play.x = display.contentCenterX
   play.y = display.contentHeight - 600

   tutorial = display.newImageRect(sceneGroup, "assets/images/tutorial.png",1300,500)
   tutorial:scale(0.3, 0.3)
   tutorial.anchorX = 0.5
   tutorial.anchorY = 1
   tutorial.x = display.contentCenterX - 200
   tutorial.y = display.contentHeight

   tutorial = display.newImageRect(sceneGroup, "assets/images/credits.png",1300,500)
   tutorial:scale(0.3, 0.3)
   tutorial.anchorX = 0.5
   tutorial.anchorY = 1
   tutorial.x = display.contentCenterX + 200
   tutorial.y = display.contentHeight

   -- Animate the scene background
   blurBackground(background, play)

end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      play:addEventListener("tap", startGame)
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
      -- audio.play(backingMusic)
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
      play:removeEventListener("tap", startGame)
      backingMusic = nil
      bassBoom = nil
      sceneGroup = nil
      timer.cancel(normalTimer)
      timer.cancel(blurTimer)
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
      -- Remove play button event listener
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