local gameStateEnd = {}

function gameStateEnd.load()
    
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
end

return gameStateEnd