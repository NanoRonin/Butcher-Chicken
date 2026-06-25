require('functions')

function love.load()
    background = love.graphics.newImage('sprites/grassBackground.png')
    defaultFont = love.graphics.getFont()
    deadFont = love.graphics.newFont(40)
    love.window.setFullscreen(true)
    love.window.setTitle("chicken and the butcher")
    timer = 0.25
    resetGame()
end

function love.update(dt)
    delta = dt
    if state == "playing" then
        spawnTimer = spawnTimer + dt
        player.Sprite = love.graphics.newImage('sprites/chick.png')

        if spawnTimer >= timer then
            addEnemy()
            spawnTimer = 0
            timer = timer - 0.0001
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

            if checkCollision(player.x + 20, player.y + 20, 60, 60, v.x + 5, v.y + 5, 75, 75) then
                table.remove(enemies, i)
                state = "dead"
                player.sprite = love.graphics.newImage('sprites/meatChop.png')
            end
        end
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, 5, 5)
    love.graphics.draw(player.sprite, player.x, player.y, 0, 0.2, 0.2)

    if hitboxes then love.graphics.rectangle("line", player.x + 20, player.y + 20, 60, 60) end   
    
    for i,v in ipairs(enemies) do
        love.graphics.draw(v.sprite, v.x, v.y, 0, 0.2, 0.2)
        if hitboxes then love.graphics.rectangle("line", v.x + 5, v.y + 5, 75, 75) end
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
        love.graphics.print(text, x - 50, y)

        text = "Space to replay"
        local x = love.graphics.getWidth() / 2 - deadFont:getWidth(text)/2
        local y = love.graphics.getHeight() / 2 - deadFont:getHeight()/2
        love.graphics.print(text, x, y + 50)

        love.graphics.setFont(defaultFont)
    end
end