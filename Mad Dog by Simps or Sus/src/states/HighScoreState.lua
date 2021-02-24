HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
    self.highScores = params.highScores
end



function HighScoreState:update(dt)
    -- return to the start screen if we press escape
    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('start', {
            highScores = self.highScores
        })
    end
end

function HighScoreState:render()
    love.graphics.setFont(gFonts['XXXLarge'])
    love.graphics.setColor(0.64, 0.48, 0)
    love.graphics.printf('High Scores', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1)
    -- iterate over all high score indices in our high scores table
    for i = 1, 10 do
        local name = self.highScores[i].name or '---'
        local score = self.highScores[i].score or '---'

        -- score number (1-10)
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(gFonts['numfont'])
        love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH / 4 + 119, 
            60 + i * 79, 260, 'left')

        -- score name  
        love.graphics.setColor(1,1,0) 
        love.graphics.setFont(gFonts['XXLarge'])
        love.graphics.printf(name, VIRTUAL_WIDTH / 4 + 75, 
            60 + i * 81, 260, 'right')
        
        -- score itself
        love.graphics.setFont(gFonts['numfont'])
        love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 2 + 70,
            60 + i * 80, 260, 'right')
    end
    
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(gFonts['XLarge'])
    love.graphics.printf("Press ESC key to return",
        -20, VIRTUAL_HEIGHT - 100, 2000, 'center')

end
