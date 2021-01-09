--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

-- Load our image
local gold = love.graphics.newImage('gold.png')
local silver = love.graphics.newImage('silver.png')
local bronze = love.graphics.newImage('bronze.png')

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 200, VIRTUAL_WIDTH, 'center')
    
    -- Initialize medal appearance 
     if self.score >= 5 and self.score < 10 then
        love.graphics.setFont(mediumFont)
        love.graphics.printf("Congrats! You won a bronze medal!", 0, 160, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(bronze, (VIRTUAL_WIDTH / 2) - 15, (VIRTUAL_HEIGHT / 2) - 25, 0, .12 , .12)
    elseif self.score >= 10 and self.score < 15 then
        love.graphics.setFont(mediumFont)
        love.graphics.printf("Congrats! You won a silver medal!", 0, 160, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(silver, (VIRTUAL_WIDTH / 2) - 15, (VIRTUAL_HEIGHT / 2) - 25, 0, .12, .12)
    elseif self.sore >= 15 then
        love.graphics.setFont(mediumFont)
        love.graphics.printf("Congrats! You won a gold medal!", 0, 160, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(gold, (VIRTUAL_WIDTH / 2) - 15, (VIRTUAL_HEIGHT / 2) - 25, 0, .12, .12)
    end
end
