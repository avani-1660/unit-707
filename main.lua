-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
--
-- Collision

local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 ) -- ( x, y )
--physics.setDrawMode( "hybrid" )   -- Shows collision engine outlines only

-- Gravity

local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 ) -- ( x, y )
--physics.setDrawMode( "hybrid" )   -- Shows collision engine outlines only

local playerBullets = {} --table that holds the player bullets


local theGround = display.newImageRect( "assets/land.png", 300, 150 )
theGround.x = display.contentCenterX
theGround.y = display.contentHeight
theGround.id = "the ground"
physics.addBody( theGround, "static", { 
    friction = 0.5, 
    bounce = 0.3
    } )

local theGround2 = display.newImage( "assets/land.png" , 300, 200 )
theGround2.x = 1520
theGround2.y = display.contentHeight
theGround2.id = "the ground 2"
physics.addBody( theGround2, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local landSquare = display.newImage( "assets/landSquare.png", 300, 175 )
landSquare.x = 1520
landSquare.y = display.contentHeight - 1000
landSquare.id = "land Square"
physics.addBody( landSquare, "dynamic", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

--left wall

local leftWall = display.newRect( 0, display.contentHeight / 2, 25, display.contentHeight )
-- myRectangle.strokeWidth = 3
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
leftWall.alpha = 0.0
leftWall.id = "left wall"
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.9
    } )

-- Character move

local dPad = display.newImageRect( "assets/d-pad.png", 150, 150)
dPad.x = 75
dPad.y = display.contentCenterY -200

--up arrow 

local upArrow = display.newImageRect( "assets/upArrow.png", 35,25 )
upArrow.x = 75
upArrow.y = display.contentCenterY -256
upArrow.id = "up arrow"

-- down arrow 

local downArrow =display.newImageRect ("assets/downArrow.png" , 35, 25 )
downArrow.x = 75
downArrow.y = display.contentCenterY -144
downArrow.id = "down Arrow"

--right arrow 

local rightArrow = display.newImageRect ("assets/rightArrow.png" , 25,35)
rightArrow.x =130
rightArrow.y = display.contentCenterY-200
rightArrow.id = "right Arrow"

--left Arrow

local leftArrow = display.newImageRect ( "assets/leftArrow.png", 25,35)
leftArrow.x = 20
leftArrow.y = display.contentCenterY -200
leftArrow.id = "left arrow"

--jump button 
local jumpButton = display.newImageRect( "assets/jumpButton.png" , 90,90 )
jumpButton.x = display.contentWidth - 80
jumpButton.y = display.contentHeight - 80
jumpButton.id = "jump button"
jumpButton.alpha = 0.5
 
--shoot button

local shootButton = display.newImageRect( "assets/shootButton.png" , 90, 90)
shootButton.x = display.contentWidth - 250
shootButton.y = display.contentHeight - 80
shootButton.id = "shootButton"
shootButton.alpha = 0.5
 
-- characters 

local theCharacter = display.newImageRect( "assets/Idle.png", 70, 70 )
theCharacter.x =90
theCharacter.y = 125
theCharacter.id = "the character"
physics.addBody( theCharacter, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )


local theCharacter2 = display.newImageRect( "assets/Idle.png" ,70, 70 )
theCharacter2.x = 150
theCharacter2.y =125
theCharacter2.id = "the character"
physics.addBody( theCharacter2, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )


local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

 


function upArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = 0, -- move 0 in the x direction 
        	y = -50, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function downArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = 0, -- move 0 in the x direction 
        	y = 50, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = 50, -- move 0 in the x direction 
        	y = 0, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = -50, -- move 0 in the x direction 
        	y = 0, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
        -- make the character jump
        theCharacter:setLinearVelocity( 0, -750 )
    end

    return true
end

function checkCharacterPosition( event )
    -- check every frame to see if character has fallen
    if theCharacter.y > display.contentHeight + 150 then
        theCharacter.x = display.contentCenterX - 100
        theCharacter.y = display.contentCenterY
    end
end

function shootTouch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleBullet = display.newImageRect( "assets/bullet.png", 50, 50 )
        aSingleBullet.x = theCharacter.x
        aSingleBullet.y = theCharacter.y
        physics.addBody( aSingleBullet, 'dynamic' )
        -- Make the object a "bullet" type object
        aSingleBullet.isBullet = true
        aSingleBullet.isFixedRotation = true
        aSingleBullet.gravityScale = 8
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity( 850, 0)


        table.insert(playerBullets ,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

 function checkPlayerBulletsOutOfBounds()
	-- check if any bullets have gone off the screen
	local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 ,-1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end


-- if character falls off the end of the world, respawn back to where it came from

upArrow:addEventListener( "touch", upArrow )
downArrow:addEventListener( "touch", downArrow )
rightArrow:addEventListener( "touch",rightArrow )
leftArrow:addEventListener( "touch", leftArrow)
jumpButton:addEventListener( "touch", jumpButton )
Runtime:addEventListener( "enterFrame", checkCharacterPosition )
shootButton:addEventListener( "touch", shootTouch )

--theCharacter.collision = characterCollision
--theCharacter:addEventListener( "collision" )
