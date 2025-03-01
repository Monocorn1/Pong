if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
    math.randomseed(os.time())
    RandomBall = 0
    Move = 2
    Player1 = {
        x = 0,
        y = 300,
        width = 20,
        height = 100
    }
    WallTop = {
        x = 0,
        y = 0,
        width = 1000,
        height = 10
    }
    WallBottom = {
        x = 0,
        y = 590,
        width = 1000,
        height = 10
    }
    OutofBoundsLeft = {
        x = -10,
        y = 0,
        width = 10,
        height = 1000
    }
    OutofBoundsRight = {
        x = 800,
        y = 0,
        width = 10,
        height = 1000
    }
    Player2 = {
        x = 780,
        y = 300,
        width = 20,
        height = 100
    }
    Ball = {
        x = 400,
        y = 320,
        width = 20,
        height = 20
    }

    Speed = 300
    HighScore=0
end

function CheckCollisionBall1(player1, Ball)
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

function CheckCollisionOutofBounds(OutofBoundsRight, OutofBoundsLeft, Ball)
    local wall_left = OutofBoundsLeft.x + OutofBoundsLeft.width
    local wall_right = OutofBoundsRight.x
    local ball_left = Ball.x
    local ball_right = Ball.x + Ball.width

    return wall_left>ball_left
    or wall_right<ball_right
end

function WallBall(Ball,WallTop,WallBottom)
    local ball_top = Ball.y
    local ball_bottom = Ball.y + Ball.height

    local wall_top= WallTop.y+WallTop.height
    local wall_bottom= WallBottom.y

    return ball_top<wall_top
    or ball_bottom>wall_bottom
end

function CheckWall1(player, WallTop)
    local player_top = player.y
    local player_bottom = player.y + player.height

    local wall_bottom= WallTop.y+WallTop.height

    return player_top<wall_bottom
end

function CheckWall2(player, WallBottom)
    local player_top = player.y
    local player_bottom = player.y + player.height

    local wall_top= WallBottom.y

    return player_bottom>wall_top
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


    return  ball_right > player2_left
        and ball_left < player2_right
        and ball_bottom > player2_top
        and ball_top < player2_bottom

end

function love.update(dt)
    --Player1 movement
    if love.keyboard.isDown("s") then
        if(CheckWall2(Player1,WallBottom)) then
            Player1.y=Player1.y+0
        else
            if love.keyboard.isDown("lshift") then
                Player1.y = Player1.y + Speed*1.5 *dt
            end
            Player1.y = Player1.y + Speed *dt
        end
    end
    if love.keyboard.isDown("w") then
        if(CheckWall1(Player1,WallTop)) then
            Player1.y=Player1.y+0 
        else
            if love.keyboard.isDown("lshift") then
                Player1.y = Player1.y - Speed*1.5 *dt
            end
            Player1.y = Player1.y - Speed *dt
        end
    end
    function love.keyreleased(key)
        if Speed == 0 then
            HighScore = 0
            if key == "space" then
               Move = 1
               Speed = 300
               RandomBall = math.random(-300, 300)
               Ball.y = Ball.y + RandomBall * dt
            end
        end
     end
        love.keyreleased(love.keyboard.isDown("space"))

 -- AI logic for Player 2
  -- AI logic for Player 2 (smoother movement)
  local ballCenterY = Ball.y + Ball.height / 2
  local player2CenterY = Player2.y + Player2.height / 2

  -- Smoothly interpolate Player 2's movement towards the ball
  local lerpFactor = 0.05  -- This controls the smoothness (0 = instant, 1 = very slow)
  if ballCenterY < player2CenterY then
      Player2.y = Player2.y - lerpFactor * (Speed*15) * dt  -- Move up towards the ball
  elseif ballCenterY > player2CenterY then
      Player2.y = Player2.y + lerpFactor * (Speed*15) * dt  -- Move down towards the ball
  end

 

    -- Keep Player 2 within the top and bottom walls
    if Player2.y < WallTop.y + WallTop.height then
        Player2.y = WallTop.y + WallTop.height  -- Don't go above top wall
    elseif Player2.y + Player2.height > WallBottom.y then
        Player2.y = WallBottom.y - Player2.height  -- Don't go below bottom wall
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
     
    print(RandomBall)
    BallGo(Move)
    if CheckCollisionBall2(Player2, Ball) then
        Move = 0
        Speed=Speed+10
        RandomBall = math.random(-300, 300)
        
        
    end
    if CheckCollisionBall1(Player1, Ball) then
        Move = 1
        Speed=Speed+10
        HighScore=HighScore+1
        
        RandomBall = math.random(-300, 300)
    end

    if CheckCollisionOutofBounds(OutofBoundsRight, OutofBoundsLeft, Ball) then
        Ball.y = 300
        Ball.x = 400
        Speed = 0
        RandomBall = 0
    end
end

function love.draw()
    if CheckCollisionBall1(Player1, Ball) then
        --If there is collision, draw the rectangles filled
        Mode1 = "line"
    else
        --else, draw the rectangles as a line
        Mode1 = "fill"
    end
    if CheckCollisionBall2(Player2, Ball) then
        --If there is collision, draw the rectangles filled
        Mode2 = "line"
    else
        --else, draw the rectangles as a line
        Mode2 = "fill"
    end

    love.graphics.print("Covjecansto: "..HighScore,380, 15)
    love.graphics.print("Roboti: "..0,380, 567)
    love.graphics.rectangle(Mode1, Player1.x, Player1.y, Player1.width, Player1.height)
    love.graphics.rectangle('fill', OutofBoundsLeft.x, OutofBoundsLeft.y, OutofBoundsLeft.width, OutofBoundsLeft.height)
    love.graphics.rectangle('fill', OutofBoundsRight.x, OutofBoundsRight.y, OutofBoundsRight.width, OutofBoundsRight.height)
    love.graphics.rectangle(Mode2, Player2.x, Player2.y, Player2.width, Player2.height)
    love.graphics.rectangle("fill", WallTop.x, WallTop.y, WallTop.width, WallTop.height)
    love.graphics.rectangle("fill", WallBottom.x, WallBottom.y, WallBottom.width, WallBottom.height)
    love.graphics.rectangle('fill', Ball.x, Ball.y, Ball.width, Ball.height)
    
end

