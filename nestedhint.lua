local composer = require( "composer" )

local scene = composer.newScene()
print("Hit ScopeHint Class")

function dismissHint(event)
	composer.hideOverlay( "fade", 400 )
	print("dismissing")
end

-- "scene:create()"
function scene:create( event )
	print("Creating Overlay")
	local group = self.view

	hint = display.newGroup()

	local backgroundOverlay = display.newRect (group, display.contentCenterX, display.contentCenterY+130, display.contentWidth - 200, 200)
	backgroundOverlay.anchorX = 0.5
	backgroundOverlay.anchorY = 0.5
	backgroundOverlay:setFillColor( black )
	backgroundOverlay.alpha = 0.9
	backgroundOverlay.isHitTestable = true
	backgroundOverlay:addEventListener ("tap", dismissHint)

	local typoString = "Verify the structure of\nyour nested for loop."

	local options = {
	    text = typoString,     
	    x = display.contentCenterX,
	    y = display.contentCenterY+160,
	    width = display.contentWidth - 300,     --required for multi-line and alignment
	    height = 200,
	    font = native.systemFontBold,   
	    align = "center"
	}
	local hintText = display.newText(options)

	hintText.anchorX = 0.5
	hintText.anchorY = 0.5

	hint:insert(backgroundOverlay)
	hint:insert(hintText)

end

function scene:show( event )
	print("Scene show")
end


function scene:hide( event )
	print("hiding hint")
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object

    if ( phase == "will" ) then
        -- Call the "resumeGame()" function in the parent scene
        hint:removeSelf()
        parent:resumeGame()
    end
end

-- By some method (a "resume" button, for example), hide the overlay
composer.hideOverlay( "fade", 400 )

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene