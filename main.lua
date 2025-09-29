if arg[2] == "debug" then
    require("lldebugger").start()
end

wall = require("wall")
player = require("player")
ball = require("ball")
enemy = require("enemy")
gameStateEnd = require("gameStateEnd")
push = require("push")
function love.resize(w, h)
    push:resize(w, h)
end

gameWidth, gameHeight = 800, 600                                  --fixed game resolution
windowWidth1, windowHeight1 = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth1 * .6, windowHeight1 * .7 --make the window a bit smaller than the screen itself

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight,
    { fullscreen = false, stretched = true, resizable = true })

function love.load()
    math.randomseed(os.time())
    love.window.setVSync(-1)
    font = love.graphics.newFont('Fonts/slkscre.ttf', 48)
    love.graphics.setFont(font, 48)


    RandomBall = 0
    Move = 2
    Speed = 800
    playerScore = 0
    enemyScore = 0

    wall.load()
    player.load()
    ball.load()
    enemy.load()
    gameStateEnd.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
end

function CheckCollisionOutofBoundsLeft(OutofBoundsLeft, Ball)
    local wall_left = OutofBoundsLeft.x + OutofBoundsLeft.width
    local ball_left = Ball.x

    return wall_left > ball_left
end

function CheckCollisionOutofBoundsRight(OutofBoundsRight, Ball)
    local wall_right = OutofBoundsRight.x
    local ball_right = Ball.x + Ball.width

    return wall_right < ball_right
end

function WallBall(Ball, WallTop, WallBottom)
    local ball_top = Ball.y
    local ball_bottom = Ball.y + Ball.height

    local wall_top = WallTop.y + WallTop.height
    local wall_bottom = WallBottom.y

    return ball_top < wall_top
        or ball_bottom > wall_bottom
end

function CheckWall1(player, WallTop)
    local player_top = player.y
    local player_bottom = player.y + player.height

    local wall_bottom = WallTop.y + WallTop.height

    return player_top < wall_bottom
end

function CheckWall2(player, WallBottom)
    local player_top = player.y
    local player_bottom = player.y + player.height

    local wall_top = WallBottom.y

    return player_bottom > wall_top
end

function CheckCollisionBall2(player2, Ball)
    local player2_left = player2.x
    local player2_right = player2.x + player2.width
    local player2_top = player2.y
    local player2_bottom = player2.y + player2.height

    local ball_top = Ball.y
    local ball_bottom = Ball.y + Ball.height
    local ball_left = Ball.x
    local ball_right = Ball.x + Ball.width


    return ball_right > player2_left
        and ball_left < player2_right
        and ball_bottom > player2_top
        and ball_top < player2_bottom
end

function love.update(dt)
    --Player1 movement
    if love.keyboard.isDown("s") then
        if (CheckWall2(Player1, WallBottom)) then
            Player1.y = Player1.y + 0
        else
            if love.keyboard.isDown("lshift") then
                Player1.y = Player1.y + Speed * 1.5 * dt
            end
            Player1.y = Player1.y + Speed * dt
        end
    end
    if love.keyboard.isDown("w") then
        if (CheckWall1(Player1, WallTop)) then
            Player1.y = Player1.y + 0
        else
            if love.keyboard.isDown("lshift") then
                Player1.y = Player1.y - Speed * 1.5 * dt
            end
            Player1.y = Player1.y - Speed * dt
        end
    end
    function love.keyreleased(key)
        if Speed == 0 then
            Player1.y = 300
            Player2.y = 300
            if key == "space" then
                Move = 2
                Speed = 800
                RandomBall = 0
                Ball.y = Ball.y + RandomBall * dt
            end
        end
    end

    love.keyreleased(love.keyboard.isDown("space"))

    -- AI logic for Player 2 (smooth movement)
    local ballCenterY = Ball.y + Ball.height / 2
    local player2CenterY = Player2.y + Player2.height / 2

    -- Smoothly interpolate Player 2's movement towards the ball
    local lerpFactor = 3 -- Controls the smoothness (lower value = smoother movement)
    Player2.y = Player2.y + (ballCenterY - player2CenterY) * lerpFactor * dt

    -- Keep Player 2 within the top and bottom walls
    if Player2.y < WallTop.y + WallTop.height then
        Player2.y = WallTop.y + WallTop.height    -- Don't go above top wall
    elseif Player2.y + Player2.height > WallBottom.y then
        Player2.y = WallBottom.y - Player2.height -- Don't go below bottom wall
    end

    --Ball logic
    function BallGo(Move)
        if WallBall(Ball, WallTop, WallBottom) then
            -- Reverse the y-direction of the ball when it collides with top or bottom wall
            RandomBall = -RandomBall
            -- Optionally, you can reset Touch to false or do any other handling here
        end

        if Move == 2 then
            Ball.x = Ball.x - Speed * dt
        elseif Move == 1 then
            Ball.x = Ball.x + Speed * dt
        else
            Ball.x = Ball.x - Speed * dt
        end

        -- Update the ball's vertical position based on its velocity (RandomBall)
        Ball.y = Ball.y + RandomBall * dt
    end

    BallGo(Move)
    if CheckCollisionBall2(Player2, Ball) then
        Move = 0
        Speed = Speed + 10
        RandomBall = math.random(-300, 300)
    end
    if player.CheckCollisionBall1(Player1, Ball) then
        Move = 1
        Speed = Speed + 10

        RandomBall = math.random(-300, 300)
    end

    if CheckCollisionOutofBoundsLeft(OutofBoundsLeft, Ball) then
        Ball.y = 300
        Ball.x = 400
        Speed = 0
        RandomBall = 0
        enemyScore = enemyScore + 1
    end
    if CheckCollisionOutofBoundsRight(OutofBoundsRight, Ball) then
        Ball.y = 300
        Ball.x = 400
        Speed = 0
        RandomBall = 0
        playerScore = playerScore + 1
    end
end

function love.draw()
    push:start()

    r, g, b = love.math.colorFromBytes(255, 157, 35)
    love.graphics.setBackgroundColor(r, g, b)

    love.graphics.draw(Player1.playerImg, Player1.x, Player1.y)
    love.graphics.draw(Player2.enemyImg, Player2.x, Player2.y)
    love.graphics.setColor(love.math.colorFromBytes(50, 50, 50))
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
    love.graphics.draw(Ball.ballImg, Ball.x, Ball.y)
    love.graphics.rectangle('fill', OutofBoundsRight.x, OutofBoundsRight.y, OutofBoundsRight.width,
        OutofBoundsRight.height)
    love.graphics.setColor(love.math.colorFromBytes(50, 50, 50))
    love.graphics.print(playerScore, 300, 50)
    love.graphics.print(enemyScore, 500, 50)
    wall.draw()

    push:finish()
end
