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
   print "Hit start button"
   composer.gotoScene("intro_1")
   if event.phase == "ended" then
      composer.gotoScene("intro_1")
   end
end

function blurBackground(bg, p)
   -- Blur the background
   bg.fill.effect = "filter.blurVertical"
   bg.fill.effect.blurSize = 20
   bg.fill.effect.sigma = 140
   -- l1.fill.effect = "filter.blurHorizontal"
   -- l1.fill.effect.blurSize = 80
   -- l1.fill.effect.sigma = 140
   -- l2.fill.effect = "filter.blurHorizontal"
   -- l2.fill.effect.blurSize = 80
   -- l2.fill.effect.sigma = 140
   p.fill.effect = "filter.blurHorizontal"
   p.fill.effect.blurSize = 80
   p.fill.effect.sigma = 140
   -- After x miliseconds, return the background to original form
   timer.performWithDelay(100,
      function()
         -- audio.play(bassBoom)
         normalBackground(bg, p)
      end, 1)
end

-- normalize the background
function normalBackground(bg, p)
   bg.fill.effect = nil
   -- l1.fill.effect = nil
   -- l2.fill.effect = nil
   p.fill.effect = nil
   timer.performWithDelay(math.random(500, 6000),
      function()
         blurBackground(bg, p)
      end, 1)
end

---------------------------------------------------------------------------------
function toGame(event)
   composer.gotoScene( "finderrors" )
end
-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   -- Set the background
   background = display.newImageRect("assets/images/splashBg.jpg",900,1425)
   background.anchorX = 0.5
   background.anchorY = 1
   -- Place background image in center of screen
   background.x = display.contentCenterX
   background.y = display.contentHeight
   -- screenGroup:insert(background)

   title = display.newImageRect("assets/images/PandaAttacks.png",800,300)
   title:scale(0.7, 0.7)
   title.anchorX = 0.5
   title.anchorY = 1
   title.x = display.contentCenterX
   title.y = display.contentHeight - 900

   play = display.newImageRect("assets/images/play.png",800,300)
   play:scale(0.7, 0.7)
   play.anchorX = 0.5
   play.anchorY = 1
   play.x = display.contentCenterX
   play.y = display.contentHeight - 700
   play:addEventListener("tap", toGame)

   -- -- Adds level one icon
   -- levelOne = display.newImageRect("levelOneGrey.png",700,700)
   -- levelOne:scale(0.5, 0.5)
   -- levelOne.anchorX = 0.5
   -- levelOne.anchorY = 1
   -- levelOne.x = display.contentCenterX - 150
   -- levelOne.y = display.contentHeight - 500
   -- -- screenGroup:insert(levelOne)

   -- -- Adds level two icon
   -- levelTwo = display.newImageRect("levelTwo.png",700,700)
   -- levelTwo:scale(0.5, 0.5)
   -- levelTwo.anchorX = 0.5
   -- levelTwo.anchorY = 1
   -- levelTwo.x = display.contentCenterX + 150
   -- levelTwo.y = display.contentHeight - 500
   -- -- screenGroup:insert(levelTwo)

   -- Load the audio tracks
   backingMusic = audio.loadStream("assets/audio/backgroundMusic.mp3")
   bassBoom = audio.loadSound("assets/audio/drum.mp3")

   -- Animate the scene background
   -- blurBackground(background, levelOne, levelTwo)
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
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
      -- Remove play button event listener
      -- play:removeEventListener("touch", startGame)
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