--[[
    Mad Dog Game

    Author: Simps or Sus

    -- RuleState --

    NOTE: All CAPS are considered constants
]] --

-- global input for values
local selected = 1
page = 1
RuleState = Class{__includes = BaseState}

function RuleState:enter(params)
    self.highScores = params.highScores
end

function RuleState:init()

    
    self.x = {
        ['left'] =  (VIRTUAL_WIDTH / 2) - 340,
        ['right'] =  (VIRTUAL_WIDTH / 2) + 280
    }

    self.y = {
        ['left'] = (VIRTUAL_HEIGHT / 2) + 125,
        ['right'] = (VIRTUAL_HEIGHT / 2) + 125
    }

    self.width = 81

    self.height = 63
end

function RuleState:update(dt)

        
    if  love.mouseIn(self.x['right'], self.y['right'], self.width, self.height) and isPressed(1) then
        page = math.min(4, page + 1) 
        gSounds['select']:play()

    elseif love.mouseIn(self.x['left'], self.y['left'], self.width, self.height) and isPressed(1) then
        page = math.max(0, page - 1) 
        gSounds['select']:play()

    end

    if page == 0 then 
        gStateMachine:change('option', {
            highScores = self.highScores
        })
    end
         
end

function RuleState:render()

    local sampTile  = love.graphics.newQuad(0, 0, 200, 200, gTextures['sample']:getDimensions())


    -- menu
    love.graphics.draw(gTextures['menu'], (VIRTUAL_WIDTH / 2) - 450, (VIRTUAL_HEIGHT / 2) - 280, 0, .830, .800)

    --  left arrow
    love.graphics.draw(gTextures['left_arrow'],  self.x['left'], self.y['left'], 0, .300, .270)


    -- rules title
    love.graphics.draw(gTextures['rules'],(VIRTUAL_WIDTH / 2) - 130, (VIRTUAL_HEIGHT / 2) - 170, 0, .830, .800 )

    -- initiates pages on the rule
    if page == 1 then

        -- right arrow
        love.graphics.draw(gTextures['right_arrow'], self.x['right'] , self.y['right'], 0, .300, .270)
        
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('Hello there! ', 640, 445, 260, 'center')
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('Rules are simple: \nPlay and collect points every round in order to win the game and not wake up the sleeping MAD DOG', 650, 500, 700, 'left')

    elseif page == 2 then


         -- right arrow
        love.graphics.draw(gTextures['right_arrow'],  self.x['right'] , self.y['right'], 0, .300, .270)
        
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('Switch and match tiles depending to their number of bone and color at the same time.', 650, 500, 700, 'left')

        love.graphics.draw(gTextures['bone'], sampTile,(VIRTUAL_WIDTH / 2) - 220, (VIRTUAL_HEIGHT / 2) + 80, 0, .350, .350)
        love.graphics.draw(gTextures['bone'], sampTile,(VIRTUAL_WIDTH / 2) - 100, (VIRTUAL_HEIGHT / 2) + 80, 0, .350, .350)
        love.graphics.draw(gTextures['bone'], sampTile,(VIRTUAL_WIDTH / 2) + 20, (VIRTUAL_HEIGHT / 2) + 80, 0, .350, .350)
        
        love.graphics.setFont(gFonts['XLarge'])
        love.graphics.printf('+', 700, 630, 260, 'center')
        love.graphics.printf('+', 820, 630, 260, 'center')
        love.graphics.printf('=', 940, 630, 260, 'center')
        love.graphics.setFont(gFonts['XLarge'])
        love.graphics.printf('Match!', 1040, 635, 260, 'center')

    elseif page == 3 then


        -- right arrow
        love.graphics.draw(gTextures['right_arrow'],   self.x['right'] , self.y['right'], 0, .300, .270)

        love.graphics.setFont(gFonts['XLarge'])
        love.graphics.printf('Power-Up', 850, 455, 260, 'center')
        
        love.graphics.setFont(gFonts['Xmedium'])
        love.graphics.printf('This power-up will be triggered once it is by the side of the tile to be matched, thus having the perks of multiplying the added time and added points by two', 820, 520, 500, 'left')

        love.graphics.draw(gTextures['powerup'],(VIRTUAL_WIDTH / 2) - 300, (VIRTUAL_HEIGHT / 2) - 30, 0, .250, .250 )
        
    elseif page == 4 then

        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('And when timer ticks at zero, you lose and the dog wakes up', 680, 530, 600, 'center')


        
    end

    -- tells whether what is selected by the player
    if love.mouseIn(self.x['right'], self.y['right'], self.width, self.height) and page < 4 then
        love.graphics.draw(gTextures['selected_right_arrow'],  self.x['right'] , self.y['right'], 0, .300, .270)
    end
    
    if love.mouseIn(self.x['left'], self.y['left'], self.width, self.height) then 
        love.graphics.draw(gTextures['selected_left_arrow'],  self.x['left'], self.y['left'], 0, .300, .270)
    end

end