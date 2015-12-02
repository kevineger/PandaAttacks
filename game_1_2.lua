local composer = require( "composer" )
local scene = composer.newScene()

local analytics = require("gameAnal")
local typoDetection = require("typo_detection")

local coins = require("coins_data")
coins.init()

local items = require("items_data")
items.init()

question_generator = require ("questionGenerators.question2_generator")

---------------------------------------------------------------------------------
--Typewriter---------------------------------------------------------------------
---------------------------------------------------------------------------------
function updateDialog(dialog, str)
   return function()
      dialog.text = dialog.text .. str
    end
end

function typeWriter(dialog, str)
   for i = 1, #str do
       local letter = str:sub(i,i)
       step = 50
       timer.performWithDelay(500 + step * i, updateDialog(dialog, letter))
   end
end
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
--CustomFunc---------------------------------------------------------------------
---------------------------------------------------------------------------------
local startTime = os.time(os.date('*t'))

function checkAnswers()
   -- Options table for the overlay scene "pause.lua"
   composer.hideOverlay( "typohint" )
   local typos = {}

   local complete = true;
   if ( textInput1.text == "int i" ) then  
      textInput1:setTextColor( 0, 138, 46 )
   else
      complete = false
      if (typoDetection.isTypo("int i", textInput1.text, 2)) then
         typos[#typos + 1] =  textInput1.text
      end
      textInput1:setTextColor( 204, 0, 0 )
   end
   if ( textInput2.text == "length()" ) then
      textInput2:setTextColor( 0, 138, 46 )
   else
      complete = false
      if (typoDetection.isTypo("length()", textInput2.text, 3)) then
         typos[#typos + 1] =  textInput2.text
      end
      textInput2:setTextColor( 204, 0, 0 )
   end
   if ( textInput3.text == "k++){" ) then 
      textInput3:setTextColor( 0, 138, 46 )
   else
      complete = false
      if (typoDetection.isTypo("k++){", textInput3.text, 3)) then
         typos[#typos + 1] =  textInput3.text
      end
      textInput3:setTextColor( 204, 0, 0 )
   end
   if ( textInput4.text == "k" ) then 
      textInput4:setTextColor( 0, 138, 46 )
   else
      complete = false
      if (typoDetection.isTypo("k", textInput4.text, 0)) then
         typos[#typos + 1] =  textInput4.text
      end
      textInput4:setTextColor( 204, 0, 0 )
   end
   -- complete = true
   if complete then
      local endTime = os.time(os.date('*t'))
      analytics.correctAnswerG1()
      analytics.sendToParse("game_1", {["incorrect"] = analytics.getIncorrectAnswerG1(), ["correct"] = analytics.getCorrectAnswerG1(), ["total"] = analytics.getTotalAnswerG1(), ["gameResult"] = "win", ["startTime"] = startTime, ["endTime"] = endTime})
      updateCoins()
      win()
   else
     analytics.incorrectAnswerG1()
   end

   -- Show hint if Typo
   local options = {
      isModal = true,
      effect = "fade",
      time = 400,
      params = typos
   }

   if (next(typos) ~= nil) then
      composer.showOverlay( "typohint", options )
   elseif (textInput1.text == "i") then
      composer.showOverlay( "scopehint", options )
   elseif (textInput4.text == "i") then
      composer.showOverlay( "nestedhint", options )
   end

end

function win()
   analytics.updateTotal("game_1_3", "goYQo4jfYF", "game_2_plays")

   questionText:removeSelf()
   loopText1:removeSelf()
   loopText2:removeSelf()
   loopText3:removeSelf()
   loopText4:removeSelf()
   loopText5:removeSelf()
   loopText6:removeSelf()
   loopText7:removeSelf()
   loopText8:removeSelf()
   loopText9:removeSelf()
   textInput1:removeSelf()
   textInput2:removeSelf()
   textInput3:removeSelf()
   textInput4:removeSelf()
   success = display.newImageRect("assets/images/success.png", 600, 200)
   success.anchorX = 0.5
   success.anchorY = 0.5
   success.x = display.contentCenterX
   success.y = display.contentCenterY
   winTimer = timer.performWithDelay(3000,
      function()
         local options = {
            effect = "fade",
            time = 500,
         }
         success:removeSelf()
         composer.gotoScene( "winning_1", options )
      end, 1)
   submit:removeSelf()
end

-- set typewrite font depending on device
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

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view
   typeWriterFont = setFont()

   submit = display.newImageRect(sceneGroup, "assets/images/submit.png",480,144)
   submit.alpha = 0
   submit:scale(0.5, 0.5)
   submit.anchorX = 0.5
   submit.anchorY = 1
   submit.x = display.contentCenterX
   submit.y = display.contentCenterY+130

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

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      local questionOptions = {
         -- sceneGroup,
         text = '',
         x = display.contentCenterX,
         y = 300,
         width = display.contentWidth - 150,
         font = typeWriterFont,   
         fontSize = 45
      }
      questionText = display.newText( questionOptions )

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
      questionTextContent = question_generator.getQuestion(event.params)
      typeWriter(questionText, questionTextContent)
      sceneGroup:insert(questionText)

      submit:addEventListener("tap", checkAnswers)

      -- Delayed display of text
      timer.performWithDelay( 1, showText )
      -- Delayed display of inputs
      timer.performWithDelay( 1, showInputs )
   end
end

function showText()
   local loopText1Options = {
         text = 'for(',
         x = display.contentCenterX-300,
         y = display.contentCenterY-140, 
         fontSize = 40
      }
   local loopText2Options = {
         text = '=0; i<pages.',
         x = display.contentCenterX-60,
         y = display.contentCenterY-140,
         fontSize = 40
      }
   local loopText3Options = {
         text = '; i++){',
         x = display.contentCenterX+220,
         y = display.contentCenterY-140,
         fontSize = 40
   }
   local loopText4Options = {
         text = 'sentences = pages[i].getSentences();',
         x = display.contentCenterX+15,
         y = display.contentCenterY-90,
         fontSize = 40
   }
   local loopText5Options = {
         text = 'for(int k=0; k<sentences.length();',
         x = display.contentCenterX-20,
         y = display.contentCenterY-40,
         fontSize = 40
   }
   local loopText6Options = {
         text = 'transferSentence(sentences[',
         x = display.contentCenterX-40,
         y = display.contentCenterY+10,
         fontSize = 40
   }
   local loopText7Options = {
         text = ']);',
         x = display.contentCenterX+272,
         y = display.contentCenterY+10,
         fontSize = 40
   }
   local loopText8Options = {
         text = '}',
         x = display.contentCenterX-300,
         y = display.contentCenterY+60,
         fontSize = 40
   }
   local loopText9Options = {
         text = '}',
         x = display.contentCenterX-315,
         y = display.contentCenterY+110,
         fontSize = 40
   }

   loopText1 = display.newText( loopText1Options )
   loopText1.alpha = 0
   transition.to( loopText1 , { time=1500, alpha=1 } )

   loopText2 = display.newText( loopText2Options )
   loopText2.alpha = 0
   transition.to( loopText2 , { time=1500, alpha=1 } )

   loopText3 = display.newText( loopText3Options )
   loopText3.alpha = 0
   transition.to( loopText3 , { time=1500, alpha=1 } )

   loopText4 = display.newText( loopText4Options )
   loopText4.alpha = 0
   transition.to( loopText4 , { time=1500, alpha=1 } )

   loopText5 = display.newText( loopText5Options )
   loopText5.alpha = 0
   transition.to( loopText5 , { time=1500, alpha=1 } )

   loopText6 = display.newText( loopText6Options )
   loopText6.alpha = 0
   transition.to( loopText6 , { time=1500, alpha=1 } )

   loopText7 = display.newText( loopText7Options )
   loopText7.alpha = 0
   transition.to( loopText7 , { time=1500, alpha=1 } )

   loopText8 = display.newText( loopText8Options )
   loopText8.alpha = 0
   transition.to( loopText8 , { time=1500, alpha=1 } )

   loopText9 = display.newText( loopText9Options )
   loopText9.alpha = 0
   transition.to( loopText9 , { time=1500, alpha=1 } )
      
end

function showInputs()
   textInput1 = native.newTextField( display.contentCenterX-220, display.contentCenterY-136, 90, 50 )
   textInput2 = native.newTextField( display.contentCenterX+110, display.contentCenterY-136, 121, 50 )
   textInput3 = native.newTextField( display.contentCenterX+320, display.contentCenterY-88+50, 90, 50 )
   local loadItems = items.load()

   if loadItems ~= nil and loadItems["blank_ans"] ~= nil and loadItems["blank_ans"] ~= false then
      textInput3.text = 'k++){'
      textInput3:setTextColor(0,0,0)
      items.spend("blank_ans")
      items.save()
   end
   textInput4 = native.newTextField( display.contentCenterX+235, display.contentCenterY-38+50, 30, 50 )
   submit.alpha=1
end

function scene:resumeGame()
    --code to resume game
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
      timer.cancel(winTimer)
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