local ball = {}

function ball.load()
    Ball = {
        x = 400,
        y = 320,
        width = 15,
        height = 15,
        ballImg = love.graphics.newImage('Assets/Ball.png')
    }
    Ball.ballImg:setFilter("nearest", "nearest")
end

return ball