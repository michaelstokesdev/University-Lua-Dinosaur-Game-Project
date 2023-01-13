function love.load()
    -- initialise starting variables
    obstacles = {}
    groundedY = 300 
    playerY = groundedY
    gameState = "menu"
    timeSinceSpawn = 0
    playerVertVel = 0
    playerGrounded = true
    pressed = false
    obstacleStartSpeed = 100
    clock = 0
    spawnVal = 0
    scoreTimer = 0
    playerSprite = love.graphics.newImage("graphics/DinoSprite.png")
    obstacleSprite = love.graphics.newImage("graphics/ObstacleSprite.png")
end

-- logic for each frame
function love.update(dt)
    if gameState == "playing" then

        -- handle logic for obstacles
        for i, obstacle in ipairs(obstacles) do
            
            -- obstacle hit detection
            if playerY > 280 then
                if obstacle > 150 and obstacle < 190 then
                    gameState = "gameover"
                    return
                end

            end
            -- move obstacles
            obstacles[i] = obstacle - obstacleSpeed * dt
            if obstacle < -10 then
                table.remove( obstacles, i )
            end
        end

        -- set grounded state of player by checking height
        if playerY == groundedY then
            playerGrounded = true
        else
            playerGrounded = false
        end

        -- move player by velocity and set new velocity based on "gravity"
        playerY = playerY - playerVertVel * dt
        playerVertVel = playerVertVel - 500 * dt

        -- ground player if ground hit and reset vertical velocity
        if playerY > groundedY then
            playerY = groundedY
            playerVertVel = 0
        end

        -- add to spawn clock and score timer
        clock = clock + dt
        scoreTimer = scoreTimer + dt
        

        -- if spawn clock value reached reset clock and spawn obstacle
        -- create new random spawn value
        if clock > spawnVal then
            clock = 0
            spawnVal = math.random(1, 5)
            table.insert(obstacles, 760)
        end

        obstacleSpeed = obstacleSpeed + 5 * dt

    elseif gameState == "menu" or gameState == "gameover" then
        if pressed == true then
            -- set default values and change state
            obstacleSpeed = obstacleStartSpeed
            obstacles = {}
            playerY = groundedY
            scoreTimer = 0
            gameState = "playing" 
        end

    end

end

-- draw calls for each frame
function love.draw()
    if gameState == "playing" then

        -- draw floor
        love.graphics.rectangle("fill", 0, 320, 740, 40, 0, 0)

        -- draw player
        love.graphics.draw(playerSprite, 170, playerY)

        -- draw obstacles
        for i, obstacle in ipairs(obstacles) do
            love.graphics.draw(obstacleSprite, obstacle, groundedY)
        end

        -- draw score timer
        mils = string.format("%.1f", scoreTimer)
        love.graphics.print(mils, 0, 0, 0, 2, 2)
    
    elseif gameState == "menu" then

        -- render main menu screen
        love.graphics.rectangle("fill", 0, 320, 740, 40, 0, 0)
        love.graphics.print("Tap To Start Game",50,200,0,2,2)
        love.graphics.draw(playerSprite, 170, playerY)
    
    elseif gameState == "gameover" then

        -- format score and render game over screen
        scoreText = string.format("Score: %.1f", scoreTimer)
        love.graphics.rectangle("fill", 0, 320, 740, 40, 0, 0)
        love.graphics.print("Game Over",200,50,0,2,2)
        love.graphics.print(scoreText,200,100,0,2,2)
        love.graphics.print("Tap to restart",200,150,0,2,2)
        love.graphics.draw(playerSprite, 170, playerY)

    end
    
end

-- press detection for mobile and PC
function love.touchpressed(x, y)
    pressed = true
    if gameState == "playing" then
        if playerGrounded then
            playerVertVel = 300
        end
    end
end

function love.mousepressed(x, y, button)
    pressed = true
    if gameState == "playing" then
        if playerGrounded then
            playerVertVel = 300
        end
    end
end

-- release detection for mobile and PC
function love.touchreleased(x, y)
    pressed = false
end

function love.mousereleased(x, y, button)
    pressed = false
end