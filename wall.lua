-- wall.lua
local wall = {}

function wall.load()
    WallTop = {
        x = -10,
        y = 0,
        width = 1000,
        height = 10
    }
    WallBottom = {
        x = -10,
        y = 590,
        width = 1000,
        height = 10
    }
end

--Draw top and bottom wall
function wall.draw()
    love.graphics.rectangle("fill", WallTop.x, WallTop.y, WallTop.width, WallTop.height)
    love.graphics.rectangle("fill", WallBottom.x, WallBottom.y, WallBottom.width, WallBottom.height)
end

return wall
