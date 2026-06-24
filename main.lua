if os.getenv("LOVE2D_TOOLS") then pcall(require, "_love2d_tools_bridge") end
require('functions')

function love.load()
    background = love.graphics.newImage('sprites/grassBackground.png')
    defaultFont = love.graphics.getFont()
    deadFont = love.graphics.newFont(40)
    love.window.setFullscreen(true)
    love.window.setTitle("chicken and the butcher")
    resetGame()
end

function love.update(dt)
    delta = dt
    if state == "playing" then
        spawnTimer = spawnTimer + dt
        player.Sprite = love.graphics.newImage('sprites/chick.png')

        if spawnTimer >= 0.25 then
            addEnemy()
            spawnTimer = 0
        end

        if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
            if player.y > 0 then
                player.y = player.y - player.speed * dt
            end
        end

        if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
            if player.y + player.height < love.graphics.getHeight() then
                player.y = player.y + player.speed * dt
            end
        end

        if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
            if player.x > 0 then
                player.x = player.x - player.speed * dt 
            end
        end

        if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
            if player.x + player.width < love.graphics.getWidth() then
                player.x = player.x + player.speed * dt
            end
        end

        for i = #enemies, 1, -1 do
            local v = enemies[i]
            v.y = v.y + v.speed * dt

            if v.y > love.graphics.getHeight() then
                score = score + 1
                table.remove(enemies, i)
            end

            if distance(
                player.x + player.width/2,
                player.y + player.height/2,
                v.x + v.width/2,
                v.y + v.height/2
            ) < 80 then
                table.remove(enemies, i)
                state = "dead"
                player.sprite = love.graphics.newImage('sprites/meatChop.png')
            end
        end
    end

    if state == "dead" then
        player.Sprite = love.graphics.newImage('sprites/meatChop.png')
    end    
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, 5, 5)
    love.graphics.draw(player.sprite, player.x, player.y, 0, 0.2, 0.2)
    love.graphics.circle("line", player.x + player.width/2, player.y + player.height/2, 40)
    
    for i,v in ipairs(enemies) do
        love.graphics.draw(v.sprite, v.x, v.y, 0, 0.2, 0.2)
        love.graphics.rectangle("line", v.x , v.y, 100, 100)
    end

    if state == "playing" then
        local scoreText = "Assassination attempts survived: " .. score
        local scoreX = love.graphics.getWidth() / 2 - deadFont:getWidth(scoreText)/2
        love.graphics.setFont(deadFont)
        love.graphics.print(scoreText, scoreX, 10)
        love.graphics.setFont(defaultFont)
    end
    

    local fpsText = "FPS: " .. love.timer.getFPS()
    local fpsX = love.graphics.getWidth() - defaultFont:getWidth(fpsText) - 10
    love.graphics.print(fpsText, fpsX, 10)

    if state == "dead" then
        player.sprite = love.graphics.newImage('sprites/meatChop.png')
        love.graphics.setFont(deadFont)

        local text = "You survived " .. score .. " assassination attempts"
        local x = love.graphics.getWidth() / 2 - deadFont:getWidth(text) / 2
        local y = love.graphics.getHeight() / 2 - deadFont:getHeight() / 2
        love.graphics.print(text, x, y)

        text = "Space to replay"
        local x = love.graphics.getWidth() / 2 - deadFont:getWidth(text)/2
        local y = love.graphics.getHeight() / 2 - deadFont:getHeight()/2
        love.graphics.print(text, x, y + 100)

        love.graphics.setFont(defaultFont)
    end
end