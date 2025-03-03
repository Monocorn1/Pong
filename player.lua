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
    local player1_left = player1.x
    local player1_right = player1.x + player1.width
    local player1_top = player1.y
    local player1_bottom = player1.y + player1.height

    local ball_top = Ball.y
    local ball_bottom = Ball.y + Ball.height
    local ball_left = Ball.x
    local ball_right = Ball.x + Ball.width


    return  ball_right > player1_left
        and ball_left < player1_right
        and ball_bottom > player1_top
        and ball_top < player1_bottom
end

return player