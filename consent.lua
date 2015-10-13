
local composer = require( "composer" )
local scene = composer.newScene()

-- handle if user gave consent
local consent = require( "mydata" )
consent.init()

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

function nextScene()
   local options =
   {
       effect = "crossFade",
       time = 400,
   }
   composer.gotoScene("intro_1", options)
end

---------------------------------------------------------------------------------
 
function saveConsent()
  consent.set(true)
  consent.save()
  nextScene()
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
   
   local background = display.newImageRect("assets/images/splashBg.jpg",900,1425)
   background.anchorX = 0.5
   background.anchorY = 1
   -- Place background image in center of screen
   background.x = display.contentCenterX
   background.y = display.contentHeight
   sceneGroup:insert(background)

   local introtext_content = "By pressing agree you understand that your playing habits will be stored and analyzed for "
    .. "educational purposes."

    local introtext_options = {
      text = introtext_content,
      x = display.contentCenterX,
      y = 325,
      width = display.contentWidth - 100,     --required for multi-line and alignment
      font = typeWriterFont,   
      fontSize = 40
    }

   introtext = display.newText( introtext_options )
   sceneGroup:insert(introtext) 

   local title = display.newImageRect("assets/images/consent.png",676,116)
   title.x = display.contentCenterX
   title.y = 100
   sceneGroup:insert(title)

   agree = display.newImageRect("assets/images/agree.png",316,116)
   agree.x = display.contentCenterX 
   agree.y = display.contentCenterY - 100
   sceneGroup:insert(agree)

   disagree = display.newImageRect("assets/images/disagree.png",458,116)
   disagree.x = display.contentCenterX 
   disagree.y = display.contentCenterY + 100
   sceneGroup:insert(disagree)

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
      agree:addEventListener("tap", saveConsent)
      home:addEventListener("tap", goHome)
      disagree:addEventListener("tap", goHome)
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc. 

      composer.removeScene("start") 
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
      agree:removeEventListener("tap", saveConsent)
      sceneGroup = nil
      home:removeEventListener("tap", goHome)
      disagree:removeEventListener("tap", goHome)
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
