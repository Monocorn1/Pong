local player = {}

ball = require("ball")

function player.load()
    ball.load()
    Player1 = {
        x = 0,
        y = 300,
        width = 20,
        height = 100
    }
end

--Check collision with Player and the ball
function player.CheckCollisionBall1(player1, Ball)
    local player1_right = player1.x + player1.width
    local ball_left = Ball.x
    return  ball_left < player1_right
end

return player