local enemy = {}

function enemy.load() 
    Player2 = {
        x = 780,
        y = 300,
        width = 10,
        height = 100,
        enemyImg = love.graphics.newImage('Assets/Enemy.png')
    }
    Player2.enemyImg:setFilter("nearest", "nearest")
end

return enemy