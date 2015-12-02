local composer = require( "composer" )
local scene = composer.newScene()

local coins = require("coins_data")
coins.init()

local items = require("items_data")
items.init()

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

function goToStore(event)
   local options =
   {
       effect = "crossFade",
       time = 400,
   }
   composer.gotoScene("game_store", options)
end

function goToGameOne(event)
   local options =
   {
       effect = "crossFade",
       time = 400,
   }
   composer.gotoScene("game_1", options)
end

function goToGameTwo(event)
   local options =
   {
       effect = "crossFade",
       time = 400,
   }
   composer.gotoScene("finderrors", options)
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Initialize the scene here.

   -- Select Text
   play = display.newImageRect(sceneGroup, "assets/images/select.png",1000,677)
   play:scale(0.5, 0.5)
   play.anchorX = 0.5
   play.anchorY = 1
   play.x = display.contentCenterX
   play.y = 400

   -- Adds level one icon
   levelOne = display.newImageRect(sceneGroup, "assets/images/levelOneGrey.png",700,700)
   levelOne:scale(0.5, 0.5)
   levelOne.anchorX = 0.5
   levelOne.anchorY = 1
   levelOne.x = display.contentCenterX - 150
   levelOne.y = display.contentHeight - 500

   -- Adds level two icon
   levelTwo = display.newImageRect(sceneGroup, "assets/images/levelTwoGrey.png",700,700)
   levelTwo:scale(0.5, 0.5)
   levelTwo.anchorX = 0.5
   levelTwo.anchorY = 1
   levelTwo.x = display.contentCenterX + 150
   levelTwo.y = display.contentHeight - 500

   -- Home Button
   home = display.newImageRect(sceneGroup, "assets/images/home.png",370,370)
   home:scale(0.5, 0.5)
   home.anchorX = 0.5
   home.anchorY = 0.5
   home.x = 100
   home.y = display.contentHeight - 80

   -- Store Button 
   store = display.newImageRect(sceneGroup, "assets/images/store.png",285,116)
   store.x = display.contentCenterX
   store.y = display.contentCenterY + 300

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
      levelOne:addEventListener("tap", goToGameOne)
      levelTwo:addEventListener("tap", goToGameTwo)
      home:addEventListener("tap", goHome)
      store:addEventListener("tap", goToStore)

      local loadItems = items.load()
      
      if loadItems ~= nil and loadItems["star_bkg"] ~= nil then
        background = display.newImageRect(sceneGroup, "assets/images/star_background.jpg",900,1425)
      else
        background = display.newImageRect(sceneGroup, "assets/images/splashBg.jpg",900,1425)
      end
       
       background.anchorX = 0.5
       background.anchorY = 1
       -- Place background image in center of screen
       background.x = display.contentCenterX
       background.y = display.contentHeight
       sceneGroup:insert(1, background)


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
      home:removeEventListener("tap", goHome)
      store:removeEventListener("tap", goToStore)
      levelOne:removeEventListener("tap", goToGameOne)
      levelTwo:removeEventListener("tap", goToGameTwo)
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