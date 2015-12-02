local composer = require( "composer" )
local scene = composer.newScene()

local items = require("items_data")
items.init()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

-- Completely removes all scenes except for the currently active scene
composer.removeHidden()

function goHome(event)
   local options =
   {
       effect = "crossFade",
       time = 400,
   }
   composer.gotoScene("start", options)
end

function nextScene(event)
   local options =
   {
       effect = "crossFade",
       time = 400,
   }
   composer.gotoScene("select", options)
end

---------------------------------------------------------------------------------
 
 --concatinates a letter to the text displayed
function updateDialog( event )
  dialogTimer = event.source
  local letter = introtext_content:sub(i,i)
  introtext.text = introtext.text .. letter
  i = i + 1
end

--calls updateDialog on a delay 
function typeWriter()
  i = 1
  timer.performWithDelay(50, updateDialog, string.len(introtext_content))
end

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

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view

   typeWriterFont = setFont()

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.

   continue = display.newImageRect("assets/images/continue.png",431,116)
   continue:scale(0.7, 0.7)
   continue.x = display.contentWidth - 175
   continue.y = display.contentHeight - 75
   sceneGroup:insert(continue)

   -- Home Button
   home = display.newImageRect(sceneGroup, "assets/images/home.png",370,370)
   home:scale(0.5, 0.5)
   home.anchorX = 0.5
   home.anchorY = 0.5
   home.x = 100
   home.y = display.contentHeight - 80
   sceneGroup:insert(home)
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      continue:addEventListener("tap", nextScene)
      home:addEventListener("tap", goHome)


    local loadItems = items.load()
    
    local sprite_options = {
        width = 719,
        height = 576,
        numFrames = 9
    }

    if loadItems ~= nil and loadItems["green_gladys"] ~= nil then
        spriteSheet = graphics.newImageSheet( "assets/images/winning_2_custom.png", sprite_options )
    else
        spriteSheet = graphics.newImageSheet( "assets/images/winning_2.png", sprite_options )
    end

    local sprite = display.newSprite( spriteSheet, { name="sprite", start=1, count=9, time=1000 } )
    sprite:scale(1.3, 1.3)
    sprite.x = display.contentCenterX
    sprite.y = display.contentCenterY + 170
    sprite:play()
    sceneGroup:insert(sprite)

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
      
      introtext_content = "Success! You fixed the portal gun and used it to trap Panda in an "
      .. "infinte portal loop."

      local introtext_options = {
          text = '',
          x = display.contentCenterX,
          y = 325,
          width = display.contentWidth - 100,     --required for multi-line and alignment
          font = typeWriterFont,   
          fontSize = 40,
      }

      introtext = display.newText( introtext_options )
      sceneGroup:insert(introtext)  
      typeWriter()


      composer.removeScene("game_2") 
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
      continue:removeEventListener("tap", nextScene)
      sceneGroup = nil
      home:removeEventListener("tap", goHome)
      timer.cancel(dialogTimer)
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
