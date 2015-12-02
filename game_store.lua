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
function goToGames(event)
   local options = {
       effect = "crossFade",
       time = 400,
   }
   composer.gotoScene("select", options)
end

function purchaseMC(event)
   local cost = 15
   purchase(cost, "mc_life")
end

function purchaseBlank(event)
   local cost = 30
   purchase(cost, "blank_ans")
end

function purchaseHighlight(event)
   local cost = 15
   purchase(cost, "highlight_life")
end

function purchaseStar(event)
   local cost = 10
   purchase(cost, "star_bkg")
end

function purchaseGladys(event)
   local cost = 20
   purchase(cost, "green_gladys")
end

function purchasePanda(event)
   local cost = 15
   purchase(cost, "panda_level")
end

function purchase(cost, item) 
   local userCoins = coins.load()
   if userCoins == nil then
      paramsTable = {}
      paramsTable["msg"] = "You have no coins! Play a game to earn coins!"
      paramsTable["height"] = 200
      showPopup(paramsTable)  
   elseif userCoins < cost then
      paramsTable = {}
      paramsTable["msg"] = "You don't have enough coins to purchase that item. Play a game to earn more coins!"
      paramsTable["height"] = 300
      showPopup(paramsTable)  
   elseif userCoins >= cost then
      paramsTable = {}
      paramsTable["msg"] = "Success! You purchased the item!"
      paramsTable["height"] = 200
      showPopup(paramsTable) 
      print(items.load())
      items.purchase(item)
      items.save()
      coins.set(userCoins - cost)
      coins.save()
      coinText.text = userCoins - cost
   end

end

function showPopup(paramsTable)
   local options = {
      isModal = true,
      effect = "fade",
      time = 400,
      params = paramsTable
   }

   composer.showOverlay( "purchase_popup", options )   
end

function scene:resumeGame()
    --code to resume game
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Store Title 
   store = display.newImageRect(sceneGroup, "assets/images/store.png",285,116)
   store.x = display.contentCenterX
   store.y = 75

   -- Back Button
   back = display.newImageRect(sceneGroup, "assets/images/back.png",248,116)
   back.x = 130
   back.y = display.contentHeight - 60

   -- Powerups
   local powerups = display.newImageRect(sceneGroup, "assets/images/powerups.png",496,116)
   powerups:scale(0.75, 0.75)
   powerups.anchorX = 0
   powerups.x = 10
   powerups.y = 200

   mc_life = display.newImageRect(sceneGroup, "assets/images/mc_heart.png",300,282)
   mc_life:scale(0.80, 0.80)
   mc_life.anchorY = 0
   mc_life.anchorX = 0
   mc_life.x = 30
   mc_life.y = 250

   local mc_cost_text = display.newText("15", 100, 505, native.systemFontBold, 40)
   sceneGroup:insert(mc_cost_text)

   local mc_cost_img = display.newImageRect(sceneGroup, "assets/images/coins.png",300,150)
   mc_cost_img:scale(0.30, 0.30)
   mc_cost_img.anchorX = 0
   mc_cost_img.x = 130
   mc_cost_img.y = 505

   blank_ans = display.newImageRect(sceneGroup, "assets/images/blank_life.png",300,288)
   blank_ans:scale(0.80, 0.80)
   blank_ans.anchorY = 0
   blank_ans.x = display.contentCenterX
   blank_ans.y = 250

   local blank_cost_text = display.newText("30", display.contentCenterX - 30, 505, native.systemFontBold, 40)
   sceneGroup:insert(blank_cost_text)

   local blank_cost_img = display.newImageRect(sceneGroup, "assets/images/coins.png",300,150)
   blank_cost_img:scale(0.30, 0.30)
   blank_cost_img.anchorX = 0
   blank_cost_img.x = display.contentCenterX
   blank_cost_img.y = 505

   highlight_life = display.newImageRect(sceneGroup, "assets/images/highlight_heart.png",300,282)
   highlight_life:scale(0.80, 0.80)
   highlight_life.anchorY = 0
   highlight_life.anchorX = 1
   highlight_life.x = display.contentWidth - 30
   highlight_life.y = 250

   local highlight_cost_text = display.newText("15", display.contentWidth - 170, 505, native.systemFontBold, 40)
   sceneGroup:insert(highlight_cost_text)

   local highlight_cost_img = display.newImageRect(sceneGroup, "assets/images/coins.png",300,150)
   highlight_cost_img:scale(0.30, 0.30)
   highlight_cost_img.anchorX = 0
   highlight_cost_img.x = display.contentWidth - 140
   highlight_cost_img.y = 505

   -- Customize
   local custom = display.newImageRect(sceneGroup, "assets/images/customize.png",527,116)
   custom:scale(0.75, 0.75)
   custom.anchorX = 0
   custom.x = 10
   custom.y = 700

   star_bkg = display.newImageRect(sceneGroup, "assets/images/star_background_icon.png",217,269)
   star_bkg:scale(0.80, 0.80)
   star_bkg.anchorY = 0
   star_bkg.anchorX = 0
   star_bkg.x = 30
   star_bkg.y = 770

   local star_cost_text = display.newText("10", 80, 1010, native.systemFontBold, 40)
   sceneGroup:insert(star_cost_text)

   local star_cost_img = display.newImageRect(sceneGroup, "assets/images/coins.png",300,150)
   star_cost_img:scale(0.30, 0.30)
   star_cost_img.anchorX = 0
   star_cost_img.x = 110
   star_cost_img.y = 1011

   gladys_green = display.newImageRect(sceneGroup, "assets/images/green_gladys.png",220,323)
   gladys_green:scale(0.70, 0.70)
   gladys_green.anchorY = 0
   gladys_green.x = display.contentCenterX
   gladys_green.y = 765

   local gladys_cost_text = display.newText("20", display.contentCenterX - 35, 1010, native.systemFontBold, 40)
   sceneGroup:insert(gladys_cost_text)

   local gladys_cost_img = display.newImageRect(sceneGroup, "assets/images/coins.png",300,150)
   gladys_cost_img:scale(0.30, 0.30)
   gladys_cost_img.anchorX = 0
   gladys_cost_img.x = display.contentCenterX
   gladys_cost_img.y = 1011

   panda_level = display.newImageRect(sceneGroup, "assets/images/panda_levels_icon.png",293,359)
   panda_level:scale(0.60, 0.60)
   panda_level.anchorY = 0
   panda_level.anchorX = 1
   panda_level.x = display.contentWidth - 30
   panda_level.y = 765

   local panda_level_text = display.newText("15", display.contentWidth - 170, 1010, native.systemFontBold, 40)
   sceneGroup:insert(panda_level_text)

   local panda_level_img = display.newImageRect(sceneGroup, "assets/images/coins.png",300,150)
   panda_level_img:scale(0.30, 0.30)
   panda_level_img.anchorX = 0
   panda_level_img.x = display.contentWidth - 140
   panda_level_img.y = 1011

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
      mc_life:addEventListener("tap", purchaseMC)
      blank_ans:addEventListener("tap", purchaseBlank)
      highlight_life:addEventListener("tap", purchaseHighlight)
      star_bkg:addEventListener("tap", purchaseStar)
      gladys_green:addEventListener("tap", purchaseGladys)
      panda_level:addEventListener("tap", purchasePanda)

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
      back:removeEventListener("tap", goToGames)
      mc_life:removeEventListener("tap", purchaseMC)
      blank_ans:removeEventListener("tap", purchaseBlank)
      highlight_life:removeEventListener("tap", purchaseHighlight)
      star_bkg:removeEventListener("tap", purchaseStar)
      gladys_green:removeEventListener("tap", purchaseGladys)
      panda_level:removeEventListener("tap", purchasePanda)
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