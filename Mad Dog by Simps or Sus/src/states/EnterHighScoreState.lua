EnterHighScoreState = Class{__includes = BaseState}

local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}

local highlightedChar = 1

function EnterHighScoreState:init()
    self.x = {
        [1] = VIRTUAL_WIDTH / 2 - 147,
        [2] = VIRTUAL_WIDTH / 2 - 20,
        [3] = VIRTUAL_WIDTH / 2 + 89
    }
    self.y = {
        ['up'] = VIRTUAL_HEIGHT / 2 - 60,
        ['down'] = VIRTUAL_HEIGHT / 2 + 98
    }
    self.width = 61
    self.height = 44
end
function EnterHighScoreState:enter(params)
    self.highScores = params.highScores
    self.score = params.score
    self.scoreIndex = params.scoreIndex
end

function EnterHighScoreState:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local name = string.char(chars[1] .. string.char(chars[2]) .. string.char(chars[3]))

        for i = 10, self.scoreIndex, -1 do
            self.highScores[i + 1] = {
                name = self.highScores[i].name,
                score = self.highScores[i].score
            }
        end

        self.highScores[self.scoreIndex].name = name
        self.highScores[self.scoreIndex].score = self.score

        local scoresStr = ''

        for i = 1, 10 do
            scoresStr = scoresStr .. self.highScores[i].name .. '\n'
            scoresStr = scoresStr .. tostring(self.highScores[i].score) .. '\n'
        end

    --change this to a different file name/create a file
        love.filesystem.write('maddog.lst', scoresStr)

        gStateMachine:change('highscore', {
            highScores = self.highScores
        })
    end

    if love.mouseIn(self.x[1], self.y['up'], self.width, self.height) and isPressed(1) then
        chars[1] = chars[1] + 1
        if chars[1] > 90 then
            chars[1] = 65
        end
        
    elseif love.mouseIn(self.x[2], self.y['up'], self.width, self.height) and isPressed(1) then
        chars[2] = chars[2] + 1
        if chars[2] > 90 then
            chars[2] = 65
        end

    elseif love.mouseIn(self.x[3], self.y['up'], self.width, self.height) and isPressed(1) then
        chars[3] = chars[3] + 1
        if chars[3] > 90 then
            chars[3] = 65
        end
    end

    if love.mouseIn(self.x[1], self.y['down'], self.width, self.height) and isPressed(1) then
        chars[1] = chars[1] - 1
        if chars[1] < 65 then
            chars[1] = 90
        end
    elseif love.mouseIn(self.x[2], self.y['down'], self.width, self.height) and isPressed(1) then
        chars[2] = chars[2] - 1
        if chars[2] < 65 then
            chars[2] = 90
        end

    elseif love.mouseIn(self.x[3], self.y['down'], self.width, self.height) and isPressed(1) then
        chars[3] = chars[3] - 1
        if chars[3] < 65 then
            chars[3] = 90
        end

    end

end

function EnterHighScoreState:render()

    -- up button
    love.graphics.draw(gTextures['up_arrow'], self.x[1], self.y['up'], 0, 0.084, 0.084)
    love.graphics.draw(gTextures['up_arrow'], self.x[2], self.y['up'], 0, 0.084, 0.084)
    love.graphics.draw(gTextures['up_arrow'], self.x[3], self.y['up'], 0, 0.084, 0.084)

    -- down button
    love.graphics.draw(gTextures['down_arrow'], self.x[1], self.y['down'], 0, 0.084, 0.084)
    love.graphics.draw(gTextures['down_arrow'], self.x[2], self.y['down'], 0, 0.084, 0.084)
    love.graphics.draw(gTextures['down_arrow'], self.x[3], self.y['down'], 0, 0.084, 0.084)

    love.graphics.setFont(gFonts['XXLarge'])
    love.graphics.printf('Your score: ' .. tostring(self.score), 0, 300, VIRTUAL_WIDTH , 'center')
    
    love.graphics.setFont(gFonts['XXXLarge'])

    -- identify if mouse hovers to button dimension using aabb collision
    
    if love.mouseIn(self.x[1], self.y['up'], self.width, self.height) then
        love.graphics.draw(gTextures['selected_up_arrow'], self.x[1], self.y['up'], 0, 0.084, 0.084)

    elseif love.mouseIn(self.x[1], self.y['down'], self.width, self.height) then
        love.graphics.draw(gTextures['selected_down_arrow'], self.x[1], self.y['down'], 0, 0.084, 0.084)
    end
    love.graphics.print(string.char(chars[1]), VIRTUAL_WIDTH / 2 - 147, VIRTUAL_HEIGHT / 2)

    if love.mouseIn(self.x[2], self.y['up'], self.width, self.height) then
        love.graphics.draw(gTextures['selected_up_arrow'], self.x[2], self.y['up'], 0, 0.084, 0.084)

    elseif love.mouseIn(self.x[2], self.y['down'], self.width, self.height) then
        love.graphics.draw(gTextures['selected_down_arrow'], self.x[2], self.y['down'], 0, 0.084, 0.084)
    end
    love.graphics.print(string.char(chars[2]), VIRTUAL_WIDTH / 2 - 20, VIRTUAL_HEIGHT / 2)

    if love.mouseIn(self.x[3], self.y['up'], self.width, self.height) then
        love.graphics.draw(gTextures['selected_up_arrow'], self.x[3], self.y['up'], 0, 0.084, 0.084)

    elseif love.mouseIn(self.x[3], self.y['down'], self.width, self.height) then
        love.graphics.draw(gTextures['selected_down_arrow'], self.x[3], self.y['down'], 0, 0.084, 0.084)
    end
    love.graphics.print(string.char(chars[3]), VIRTUAL_WIDTH / 2 + 90, VIRTUAL_HEIGHT / 2)

    love.graphics.setFont(gFonts['XLarge'])
    love.graphics.printf('Press Enter to confirm!', 0, VIRTUAL_HEIGHT - 300,
        VIRTUAL_WIDTH + 30, 'center')
end
