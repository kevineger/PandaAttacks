local composer = require( "composer" )
local scene = composer.newScene()
local question = require("questions")
local analytics = require("gameAnal")
local parse = require ("mod_parse")
local envVars = require("globals")

parse:init({
    appId = envVars.appId,
    apiKey = envVars.apiKey
    })

local coins = require("coins_data")
coins.init()

local items = require("items_data")
items.init()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

-- Completely removes all scenes except for the currently active scene
composer.removeHidden()
---------------------------------------------------------------------------------
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local currScore = 0
local total = 4
local questionNum = 1
local errorsFound = {}

--local r = Math.random(10)
local r = 1   
local endTime
local startTime = os.time(os.date('*t'))

function goToWin(event)
   local options =
   {
       effect = "crossFade",
       time = 400,
   }
   composer.gotoScene("winning_2", options)
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

--circles word when clicked
local function clickError( event )
   circleSelect = display.newRoundedRect(sceneGroup, event.target.x, event.target.y, event.target.width, event.target.height, 3)
   circleSelect:setFillColor(0,0,0,0)
   circleSelect.strokeWidth = 3
   circleSelect:setStrokeColor(1,0,0)
   circleSelect.anchorX = 0
   circleSelect.anchorY = 1
  
   --increase score when correct error is clicked
   if event.target.error == true then
      currScore = currScore + 1
      scoreDisplay.text = currScore
      errorsFound[#errorsFound+1] = event.target.word
      analytics.correctAnswerG2()
   else
      endTime = os.time(os.date('*t'))
      analytics.incorrectAnswerG2()
      if lives == 0 then
         -- analytics.sendErrorsFound(errorsFound)
         -- analytics.sendToParse("game_2", {["incorrect"] = analytics.getIncorrectAnswerG2(), ["correct"] = analytics.getCorrectAnswerG2(), ["total"] = analytics.getTotalAnswerG2(), ["gameResult"] = "lose", ["startTime"] = startTime, ["endTime"] = endTime})
         -- analytics.sendToParse("score_2", {["incorrect"] = analytics.getIncorrectAnswerG2(), ["correct"] = analytics.getCorrectAnswerG2(), ["total"] = analytics.getTotalAnswerG2(), ["totalPercent"] = analytics.getScorePercentG2()})
         composer.gotoScene("losing_2")
      elseif lives >= 1 then
         heart[lives]:removeSelf()
      end
      lives = lives-1
      
   end

   --all errors have been found
   if currScore == total then
      --questionNum = questionNum + 1
      --questionDisplay.text = questionNum
      endTime = os.time(os.date('*t'))
      analytics.sendErrorsFound(errorsFound)
      analytics.sendToParse("game_2", {["incorrect"] = analytics.getIncorrectAnswerG2(), ["correct"] = analytics.getCorrectAnswerG2(), ["total"] = analytics.getTotalAnswerG2(), ["gameResult"] = "win", ["startTime"] = startTime, ["endTime"] = endTime})
      updateCoins()
      goToWin()

   end

end

--sets a string to separate clickable objects
local function setCodeBlock(question, err1, err2, err3, err4)

   clickableString = {}

   local t = {}
   local x = 50
   local y = centerY-100

   
   i=1
   for str in string.gmatch(question, "([^%s]+)") do

      if str == "%n" then
         y = y + 50

         x = 50

      elseif str == "%t" then
         x = x + 40

      else

         clickableString[i] = display.newText(sceneGroup ,str, x, y, native.systemFont, 40)
         clickableString[i].anchorX = 0
         clickableString[i].anchorY = 1
         clickableString[i].word = str
         clickableString[i].error = false
         clickableString[i]:addEventListener("tap", clickError)


         --x position depends on the width of the letter before
         x = x + clickableString[i].width + 15

         i = i + 1
      end
   end

   --sets which objects are errors
   for i = 1, #clickableString do
      if clickableString[i].word == err1 or clickableString[i].word == err2 or clickableString[i].word == err3 or clickableString[i].word == err4  then 
         clickableString[i].error = true
      end
   end

end
function setQuestion()
   local query = {
      ["where"] = {["num"] = r}
   }
   parse:getObjects("questions_2", query, function(ev)
      if not ev.error then
         setCodeBlock(ev.results[1].question, ev.results[1].error1, ev.results[1].error2, ev.results[1].error3, ev.results[1].error4 )
      end
   end)
end
function getRandom()
   local query = { ["order"] = "-num", ["limit"] = "1" }
    parse:getObjects( "questions_2", query, function(e)
         qnum = e.results[1].num
         r = math.random(qnum)
         setQuestion()
    end)

end

-- "scene:create()"
function scene:create( event )

   sceneGroup = self.view

   typeWriterFont = setFont()

   analytics.reset()

   local introOptions = {
   text = "Find the errors in the code given below.",
   x = centerX,
   y = 200,
   width = display.contentWidth-100, 
   height = 120,
   font = typeWriterFont, 
   fontSize = 50,
   align = "center"
   }

   local introtext = display.newText(introOptions)
   sceneGroup:insert(introtext)

   circle = display.newCircle(sceneGroup, 75, 75, 30)
   circle:setFillColor(0,0,0,0)
   circle.strokeWidth = 3

   questionDisplay = display.newText(sceneGroup, questionNum, 75, 75, native.systemFont, 50)

   scoreDisplay = display.newText(sceneGroup, currScore, display.contentWidth-120, display.contentHeight-100, native.systemFont, 50)
   local totalDisplay = display.newText(sceneGroup,"/"..total, display.contentWidth-80, display.contentHeight-100, native.systemFont, 50)

   -- Set the coin display
   local curr_coins = coins.load()
   if curr_coins == nil then
      coinText = display.newText(0, 115, display.contentHeight - 95, native.systemFontBold, 40)
   else
      coinText = display.newText(curr_coins, 115, display.contentHeight - 95, native.systemFontBold, 40)
   end
   sceneGroup:insert(coinText)

   -- Add the money bag
   local money = display.newImageRect(sceneGroup, "assets/images/money.png", 200, 272)
   money:scale(0.4, 0.4)
   money.x = 50
   money.y = display.contentHeight - 105
   sceneGroup:insert(money)
   
   getRandom()
end


-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).

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

      heart = {}

      local x = centerX - 100

      lives = 3

      if loadItems ~= nil and loadItems["highlight_life"] ~= nil and loadItems["highlight_life"] ~= false then
         lives = 4
         x = centerX - 150
         items.spend("highlight_life")
         items.save()
      end

      for i = 1, lives do
         heart[i] = display.newImage(sceneGroup, "assets/images/life.png", x, display.contentHeight-100)
         heart[i]:scale(2,2)
         x = x + 100
      end

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