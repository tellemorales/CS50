PlayState = Class{__includes = BaseState}

function PlayState:init()

end

function PlayState:update(dt)

end

function PlayState:render()
    love.graphics.draw(gTextures.bone, gFrames.tiles[1][1][1], 0, 0)
end