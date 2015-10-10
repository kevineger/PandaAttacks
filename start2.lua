local composer = require ("composer")
local scene = composer.newScene()

-------------------------------------------------------------------------------------
-----Helper Functions----------------------------------------------------------------

-- function startGame(event)
-- 	-- Start Game
-- end

-- blur the background
function blurBackground(bg, l1, l2)
	-- Blur the background
	bg.fill.effect = "filter.blurVertical"
	bg.fill.effect.blurSize = 20
	bg.fill.effect.sigma = 140
	l1.fill.effect = "filter.blurHorizontal"
	l1.fill.effect.blurSize = 80
	l1.fill.effect.sigma = 140
	l2.fill.effect = "filter.blurHorizontal"
	l2.fill.effect.blurSize = 80
	l2.fill.effect.sigma = 140
	-- After x miliseconds, return the background to original form
	timer.performWithDelay(100,
		function()
			normalBackground(bg, l1, l2)
		end, 1)
end

-- normalize the background
function normalBackground(bg, l1, l2)
	bg.fill.effect = nil
	l1.fill.effect = nil
	l2.fill.effect = nil
	timer.performWithDelay(math.random(500, 6000),
		function()
			blurBackground(bg, l1, l2)
		end, 1)
end

-------------------------------------------------------------------------------------
-----Scene Functions-----------------------------------------------------------------

function scene:create(event)
	local screenGroup = self.view
	local phase = event.phase

	print "Phase"

	if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
  	elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.

	-- Set the background
	background = display.newImageRect("splashBg.jpg",900,1425)
	background.anchorX = 0.5
	background.anchorY = 1
	-- Place background image in center of screen
	background.x = display.contentCenterX
	background.y = display.contentHeight
	-- Insert background in to screen
	screenGroup:insert(background)

	-- Adds level one icon
	levelOne = display.newImageRect("levelOneGrey.png",700,700)
	levelOne:scale(0.5, 0.5)
	levelOne.anchorX = 0.5
	levelOne.anchorY = 1
	levelOne.x = display.contentCenterX - 150
	levelOne.y = display.contentHeight - 500
	screenGroup:insert(levelOne)

	-- Adds level one icon
	levelTwo = display.newImageRect("levelTwo.png",700,700)
	levelTwo:scale(0.5, 0.5)
	levelTwo.anchorX = 0.5
	levelTwo.anchorY = 1
	levelTwo.x = display.contentCenterX + 150
	levelTwo.y = display.contentHeight - 500
	screenGroup:insert(levelTwo)

	-- Load the audio track
	-- audio.loadStream("backgroundMusic.mp3")

	-- Animate the scene background
	blurBackground(background, levelOne, levelTwo)
   	end


end

function scene:enterScene( event )

end

function scene:exitScene( event )

end

function scene:destroyScene( event )

end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene