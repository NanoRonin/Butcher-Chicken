function resetGame()
    score = 0
    state = "playing"
    spawnTimer = 0
    local playerSprite = love.graphics.newImage('sprites/chick.png')
    local playerScale = 0.2

    player = {
        sprite = playerSprite,
        width = playerSprite:getWidth() * playerScale,
        height = playerSprite:getHeight() * playerScale,
        x = love.graphics.getWidth()/2 - playerSprite:getWidth() * playerScale / 2,
        y = love.graphics.getHeight()/2 - playerSprite:getHeight() * playerScale / 2,
        speed = 200,
        scale = playerScale,
    }

    enemies = {}

    hitboxes = false
end

function distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

function addEnemy()
    local sprite = love.graphics.newImage('sprites/butcher.png')
    local scale = 0.2
    local enemy = {
        x = math.random(0, love.graphics.getWidth() - sprite:getWidth() * scale),
        y = -sprite:getHeight() * scale,
        speed = 200,
        sprite = sprite,
        width = sprite:getWidth() * scale,
        height = sprite:getHeight() * scale,
        scale = scale,
    }

    table.insert(enemies, enemy)
end

function love.keypressed(key)
    if state == "dead" and (key == "space" or key == "return") then
        resetGame()
    end

    if state == "playing" and key == "e" then
        if hitboxes then
            hitboxes = false
        else
            hitboxes = true
        end
    end
end

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
        x2 < x1 + w1 and
        y1 < y2 + h2 and
        y2 < y1 + h1
end
