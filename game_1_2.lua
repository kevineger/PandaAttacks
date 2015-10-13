local composer = require( "composer" )
local scene = composer.newScene()

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

function checkAnswers()
   local complete = true;
   if ( textInput1.text == "int i" ) then  
      print "first check"
      textInput1:setTextColor( 0, 138, 46 )
   else
      complete = false
      textInput1:setTextColor( 204, 0, 0 )
   end
   if ( textInput2.text == "length()" ) then
      print "second"
      textInput2:setTextColor( 0, 138, 46 )
   else
      complete = false
      textInput2:setTextColor( 204, 0, 0 )
   end
   if ( textInput3.text == "k++){" ) then 
      textInput3:setTextColor( 0, 138, 46 )
   else
      complete = false
      textInput3:setTextColor( 204, 0, 0 )
   end
   if ( textInput4.text == "k" ) then 
      textInput4:setTextColor( 0, 138, 46 )
   else
      complete = false
      textInput4:setTextColor( 204, 0, 0 )
   end
   -- complete = true
   if complete then
      win()
   end
end

function win()
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
   gg = display.newImageRect("assets/images/success.png", 600, 200)
   gg.anchorX = 0.5
   gg.anchorY = 0.5
   gg.x = display.contentCenterX
   gg.y = display.contentCenterY
   winTimer = timer.performWithDelay(3000,
      function()
         local options = {
            effect = "fade",
            time = 500,
         }
         gg:removeSelf()
         composer.gotoScene( "winning_1", options )
      end, 1)
   submit:removeSelf()
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Set the background
   background = display.newImageRect(sceneGroup, "assets/images/splashBg.jpg",900,1425)
   background.anchorX = 0.5
   background.anchorY = 1
   -- Place background image in center of screen
   background.x = display.contentCenterX
   background.y = display.contentHeight

   submit = display.newImageRect(sceneGroup, "assets/images/submit.png",480,144)
   submit.alpha = 0
   submit:scale(0.5, 0.5)
   submit.anchorX = 0.5
   submit.anchorY = 1
   submit.x = display.contentCenterX
   submit.y = display.contentCenterY+130
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
         -- font = "PTMono-Bold",   
         fontSize = 45
      }
      questionText = display.newText( questionOptions )

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
   textInput4 = native.newTextField( display.contentCenterX+235, display.contentCenterY-38+50, 30, 50 )
   submit.alpha=1
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