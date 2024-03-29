local composer = require( "composer" )
local scene = composer.newScene()

local analytics = require("gameAnal")
local hintDetection = require("hint_mc")

local coins = require("coins_data")
coins.init()

local items = require("items_data")
items.init()

question_generator = require ("questionGenerators.question1_generator")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

function nextLevel(event)
   --analytics.updateTotal("game_1_3", "goYQo4jfYF", "game_1_plays")
   
   if incorrect then incorrect:removeSelf() end
   ans[2]:removeSelf()
   ans[3]:removeSelf()
   ans[4]:removeSelf()
   success = display.newImageRect(sceneGroup, "assets/images/success.png", 600, 200)
   success.anchorX = 0.5
   success.anchorY = 0.5
   success.x = display.contentCenterX
   success.y = 150
   winTimer = timer.performWithDelay(3000,
      function()
         ans[1]:removeSelf()
         local options = {
            effect = "fade",
            time = 500,
            params = { pages=question_generator.getNumPages() }
         }
         composer.gotoScene( "game_1_2", options )
      end, 1)
end

function playAgain()
   composer.gotoScene("game_1")
end

function gameOver()
   ans[1]:removeSelf()
   ans[2]:removeSelf()
   ans[3]:removeSelf()
   ans[4]:removeSelf()
   questionText:removeSelf()
   incorrect:removeSelf()
   gg = display.newImageRect(sceneGroup, "assets/images/gameover.png", 400, 400)
   gg.anchorX = 0.5
   gg.anchorY = 0.5
   gg.x = display.contentCenterX
   gg.y = display.contentCenterY
   retry = display.newImageRect(sceneGroup, "assets/images/playAgain.png", 800, 200)
   retry.anchorX = 0.5
   retry.anchorY = 0.5
   retry.x = display.contentCenterX
   retry.y = display.contentCenterY - 300
   retry:addEventListener("tap", playAgain)
end

function checkAnswer(event)
   print ("Selected answer: " .. event.target.id)
   
   local loadItems = items.load()

   if ( event.target.id == 1 ) then
      analytics.correctAnswerG1()
      updateCoins()
      nextLevel()
   else
      if incorrect then
         print(paramsTable)
         if loadItems ~= nil and loadItems["mc_life"] ~= nil and loadItems["mc_life"] ~= false and paramsTable == nil then
            analytics.incorrectAnswerG1()
            paramsTable = {}
            paramsTable["msg"] = "Uh oh, wrong again! Thanks to your powerup you have one more chance!"
            paramsTable["height"] = 300
            showPopup(paramsTable) 
            items.spend("mc_life")
            items.save()
            event.target:setFillColor(black)
         else
            analytics.incorrectAnswerG1()
            paramsTable = nil
            gameOver()
         end
      else
         --analytics.incorrectAnswerG1()
         event.target:setFillColor(black)
         flashPanda()
         incorrect = display.newImageRect(sceneGroup, "assets/images/incorrect.png", 3362, 837)
         incorrect:scale(0.2, 0.2)
         incorrect.anchorX = 0.5
         incorrect.anchorY = 0.5
         incorrect.x = display.contentCenterX
         incorrect.y = display.contentHeight - 150
      end
   end
end

function flashPanda()
   incorrectPanda = display.newImageRect(sceneGroup, "assets/images/panda.png", 1000, 1000)
   incorrectPanda:scale(0.5, 0.5)
   incorrectPanda.anchorX = 0.5
   incorrectPanda.anchorY = 0.5
   -- Right Side
   incorrectPanda.x = display.contentWidth - 80
   incorrectPanda.y = display.contentHeight - math.random(100, 800)
   incorrectPanda.rotation = 300
end

function showPopup(paramsTable)
   local options = {
      isModal = true,
      effect = "fade",
      time = 400,
      params = paramsTable
   }

   composer.showOverlay( "bonus_popup", options )   
end

function scene:resumeGame()
    --code to resume game
end

-- set typewriter font depending on device
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

-- Update the dialog text
function updateDialog(dialog, str)
   return function()
      dialog.text = dialog.text .. str
    end
end

-- Split string in to chars and typewrite it with delay
function typeWriter(dialog, str)
   for i = 1, #str do
       local letter = str:sub(i,i)
       step = 50
       timer.performWithDelay(500 + step * i, updateDialog(dialog, letter))
   end
end

function printAnswers()
   local printOrder = math.random(1,4)
   if ( printOrder == 1 ) then
      local padding = 0
      for i = 1,4 do
         padding = padding+150
         printAnswer(i, padding)
         ans[i]:addEventListener("tap", checkAnswer)
      end
   elseif ( printOrder == 2 ) then
      local padding = 0
      for i = 4,1,-1 do
         padding = padding+150
         printAnswer(i, padding)
         ans[i]:addEventListener("tap", checkAnswer)
      end
   elseif ( printOrder == 3 ) then
      printAnswer(2, 150)
      ans[2]:addEventListener("tap", checkAnswer)
      printAnswer(4, 150*2)
      ans[4]:addEventListener("tap", checkAnswer)
      printAnswer(1, 150*3)
      ans[1]:addEventListener("tap", checkAnswer)
      printAnswer(3, 150*4)
      ans[3]:addEventListener("tap", checkAnswer)
   elseif ( printOrder == 4 ) then
      printAnswer(2, 150)
      ans[2]:addEventListener("tap", checkAnswer)
      printAnswer(1, 150*2)
      ans[1]:addEventListener("tap", checkAnswer)
      printAnswer(3, 150*3)
      ans[3]:addEventListener("tap", checkAnswer)
      printAnswer(4, 150*4)
      ans[4]:addEventListener("tap", checkAnswer)
   end
end

function printAnswer(num, padding)
   local answerTextOptions = {
         text = question_generator.getAnswer(num),
         font = native.systemFont,
         x = display.contentCenterX,
         y = 350+padding,
         width = display.contentWidth - 200,
      }
   -- display.newText( answerTextOptions )
   ans[num] = display.newText( answerTextOptions )
   ans[num].id = num
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   sceneGroup = self.view

   --analytics.reset()

   -- Set the coin display
   local curr_coins = coins.load()
   if curr_coins == nil then
      coinText = display.newText(0, 115, display.contentHeight - 45, native.systemFontBold, 40)
   else
      coinText = display.newText(curr_coins, 115, display.contentHeight - 45, native.systemFontBold, 40)
   end
   sceneGroup:insert(coinText)

   -- Add the money bag
   local money = display.newImageRect(sceneGroup, "assets/images/money.png", 200, 272)
   money:scale(0.4, 0.4)
   money.x = 50
   money.y = display.contentHeight - 60
   sceneGroup:insert(money)
end

-- "scene:show()"
function scene:show( event )

   local phase = event.phase
   typeWriterFont = setFont()

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).

      ans = {} 

      local introtext_options = {
         -- sceneGroup,
         text = '',
         x = display.contentCenterX,
         y = 300,
         width = display.contentWidth - 100,
         font = typeWriterFont, 
         fontSize = 45
      }

      questionText = display.newText( introtext_options )

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
      -- Called when the scene is now on screen..
      -- Print the question
      questionTextContent = question_generator.getQuestion(0)
      typeWriter(questionText, questionTextContent)
      sceneGroup:insert(questionText)
      -- Print the answers
      timer.performWithDelay(500+50*string.len(questionTextContent), printAnswers)
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
      if winTimer then timer.cancel(winTimer) end
      
      if gg then
         gg:removeSelf()
         gg = nil
      end
      if retry then 
         retry:removeSelf()
         retry = nil 
      end
      if incorrectPanda then 
         incorrectPanda:removeSelf()
         incorrectPanda = nil
      end
      incorrect = nil
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