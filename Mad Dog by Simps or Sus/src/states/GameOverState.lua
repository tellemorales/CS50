--[[
    Mad Dog Game

    Author: Simps or Sus

    -- GameOverState--

    NOTE: All CAPS are considered constants
]] --

GameOverState = Class{__includes = BaseState}


function GameOverState:enter(params)
    self.score = params.score
    self.highScores = params.highScores
end

function GameOverState:update(dt)

    -- if enter was pressed check if it is greater than the saved highscore
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local highScore = false

        local scoreIndex = 11

        for i = 10, 1, -1 do 
            local gamescore = self.highScores[i].score or 0 
            if self.score > gamescore then
                HSIndex = isPressed
                highScore = true
            end
        end

        if highScore then
            --change to enter highscore state
            gStateMachine:change('enter highscore', {
                highScores = self.highScores,
                gamescore = self.score,
                scoreIndex = HSIndex
            })
        else 
            -- change to start menu
            gStateMachine:change('start', {
                highScores = self.highScores
            })
        end
    end
end

function GameOverState:render()
    
    love.graphics.setFont(gFonts['large'])

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 + 200 , 64, 128, 136, 4)

    love.graphics.draw(gTextures['background'], 0, 0)

    love.graphics.setColor(1, 1, 1, 0.10)
    love.graphics.draw(gTextures['mad_dog'],
    -- x - axis
     (VIRTUAL_WIDTH / 2) - 525,
    -- y - axis
     (VIRTUAL_HEIGHT / 2) - 600,
    -- rotation
     0,
    -- size 
     1.8, 1.8
    )



    -- render text 
    love.graphics.setColor(1,0,0)
    love.graphics.setFont(gFonts['Giant'])
    love.graphics.printf('GAME OVER!', VIRTUAL_WIDTH / 2 - 1000, 430, 2000, 'center')
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(gFonts['XLarge'])
    love.graphics.printf('Your Final Score: ' .. tostring(self.score), VIRTUAL_WIDTH / 2 - 250, 650, 500, 'center')
    love.graphics.printf('Press Enter', VIRTUAL_WIDTH / 2 - 250, 750, 500, 'center')

end