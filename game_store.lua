local composer = require( "composer" )
local scene = composer.newScene()

local coins = require("coins_data")
coins.init()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
function goToGames(event)
   local options =
   {
       effect = "crossFade",
       time = 400,
   }
   composer.gotoScene("select", options)
end


function updateCoins()
   if coins.load() == nil then
      coins.set(5)
      coinText.text = 5;
   else
      local coin_val = coins.load() + 5
      coins.set(coin_val)
      coinText.text = coin_val;
   end
   coins.save()
end

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

   -- Store Title 
   store = display.newImageRect(sceneGroup, "assets/images/store.png",285,116)
   store.x = display.contentCenterX
   store.y = 75

   -- Back Button
   back = display.newImageRect(sceneGroup, "assets/images/back.png",248,116)
   back.x = 130
   back.y = display.contentHeight - 60

   -- Powerups Button
   local powerups = display.newImageRect(sceneGroup, "assets/images/powerups.png",496,116)
   powerups:scale(0.50, 0.50)
   powerups.anchorX = 0
   powerups.x = 10
   powerups.y = 175

   -- Set the coin display
   local curr_coins = coins.load()
   if curr_coins == nil then
      coinText = display.newText(0, display.contentWidth - 30, display.contentHeight - 45, native.systemFontBold, 40)
   else
      coinText = display.newText(curr_coins, display.contentWidth - 30, display.contentHeight - 45, native.systemFontBold, 40)
   end
   sceneGroup:insert(coinText)

   -- Add the money bag
   local money = display.newImageRect(sceneGroup, "assets/images/money.png", 200, 272)
   money:scale(0.4, 0.4)
   money.x = display.contentWidth - 105
   money.y = display.contentHeight - 60
   sceneGroup:insert(money)
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      back:addEventListener("tap", goToGames)
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
      back:removeEventListener("tap", goToGames)
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