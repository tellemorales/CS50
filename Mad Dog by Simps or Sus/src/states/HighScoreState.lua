HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
    self.highScores = params.highScores
end

function HighScoreState:update(dt)
    if love.keyboard.wasPressed('escape')
        gStateMachine:change('#NAME NG START SCREEN HERE', {
            highScores = self.highScores
        })
    end
end

function HighScoreState:render()
    love.graphics.setFont(main['medium'])

    for i = 1, 10 do
        local name = self.highScores[i].name or '---'
        local score = self.highScores[i].score or '---'

        --score name
        love.graphics.printf(name .. '.', VIRTUAL_WIDTH / 4,
            60 + i * 13, 50, 'left')
        
        --score 
        love.graphics.print(tostring(score), VIRTUAL_WIDTH / 4 + 38,
        60 + i * 13, 50, 'right')
    end
end

--pano ilagay yung button help