require('functions')

function love.load()
    state = "playing"
    spawnTimer = 0
    player = {}

    player.width = 100
    player.height = 100
    player.x = love.graphics.getWidth()/2 - player.width/2
    player.y = love.graphics.getHeight()/2
    player.speed = 200
    player.sprite = love.graphics.newImage('sprites/chick.png')

    enemies = {}
end

function love.update(dt)
    if state == "playing" then
        spawnTimer = spawnTimer + dt

        if spawnTimer >= 2 then
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
            if player.x - player.width < love.graphics.getHeight() then
                player.x = player.x + player.speed * dt
            end
        end

        for i = #enemies, 1, -1 do
            local v = enemies[i]
            v.y = v.y + v.speed * dt

            if v.y > love.graphics.getHeight() then
                table.remove(enemies, i)
            end

            if distance(
                player.x + player.width/2,
                player.y + player.height/2,
                v.x + v.width/2,
                v.y + v.height/2
            ) < 40 then
                table.remove(enemies, i)
                state = "dead"
            end

            if not state == "playing" then
                table.remove(enemies, i)
            end
        end
    end
    
end

function love.draw()
    love.graphics.draw(player.sprite, player.x, player.y, 0, 0.2, 0.2)
    love.graphics.circle("line", player.x + player.width/2, player.y + player.height/2, 40)
    
    for i,v in ipairs(enemies) do
        love.graphics.draw(v.sprite, v.x, v.y, 0, 0.2, 0.2)

    end
end