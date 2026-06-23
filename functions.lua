function distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

function addEnemy()
    enemy = {}

    enemy.x = math.random(0, love.graphics.getWidth())
    enemy.y = -100
    enemy.speed = 200
    enemy.sprite = love.graphics.newImage('sprites/butcher.png')
    enemy.width = 100
    enemy.height = 100

    table.insert(enemies, enemy) 
end

