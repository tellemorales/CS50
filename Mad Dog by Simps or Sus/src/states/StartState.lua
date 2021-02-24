
StartState = Class{__includes = BaseState}
-- whether we're highlighting "Start" or "High Scores"


function StartState:enter(params)
    self.highScores = params.highScores
end


function StartState:init()
    self.button = {
        ['play'] = love.graphics.newQuad(0, 220 , 285, 110, gTextures['main_men']:getDimensions()),
        ['selected_play'] = love.graphics.newQuad(0, 330 , 285, 110, gTextures['main_men']:getDimensions()),
        ['option'] = love.graphics.newQuad(769, 0, 470, 110, gTextures['main_men']:getDimensions()),
        ['selected_option'] = love.graphics.newQuad(769, 110, 470, 110, gTextures['main_men']:getDimensions()),
        ['quit'] = love.graphics.newQuad(285, 220, 769, 111, gTextures['main_men']:getDimensions()),
        ['selected_quit'] = love.graphics.newQuad(285, 330, 769, 111, gTextures['main_men']:getDimensions()),
        ['highscore'] = love.graphics.newQuad(0, 0, 769, 110, gTextures['main_men']:getDimensions()),
        ['selected_highscore'] = love.graphics.newQuad(0, 110 , 769, 110, gTextures['main_men']:getDimensions()),
    }

    self.x = {
        ['play'] = (VIRTUAL_WIDTH / 2) + 140,
        ['option'] = (VIRTUAL_WIDTH / 2) + 430,
        ['highscore'] = (VIRTUAL_WIDTH / 2) + 140,
        ['quit'] = (VIRTUAL_WIDTH / 2) + 140
    }

    self.y = {
        ['play'] = (VIRTUAL_HEIGHT / 2) - 130,
        ['option'] = (VIRTUAL_HEIGHT / 2) - 130,
        ['highscore'] = (VIRTUAL_HEIGHT / 2) - 15,
        ['quit'] = (VIRTUAL_HEIGHT / 2) + 100
    }


    self.width = {
        ['play'] = 257,
        ['option'] = 371,
        ['highscore'] = 661,
        ['quit'] = 661,
    }

    self.height = {
        ['play'] = 93,
        ['option'] = 93,
        ['highscore'] = 93,
        ['quit'] = 94
    }


end



function StartState:update(dt)

    if isPressed(key) then  
        gSounds['select']:play()
    end

    if love.mouseIn(self.x['play'], self.y['play'], self.width['play'], self.height['play']) and isPressed(1) then
        gStateMachine:change('play', {
            highScores = self.highScores
        })
        
    elseif love.mouseIn(self.x['option'], self.y['option'], self.width['option'], self.height['option']) and isPressed(1) then
        gStateMachine:change('option', {
            highScores = self.highScores
        })

    elseif love.mouseIn(self.x['highscore'], self.y['highscore'], self.width['highscore'], self.height['highscore']) and isPressed(1) then
        gStateMachine:change('highscore', {
            highScores = self.highScores
        })

    elseif love.mouseIn(self.x['quit'], self.y['quit'], self.width['quit'], self.height['quit']) and isPressed(1) then
        love.event.quit()
    end

    -- we no longer have this globally, so include here
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end


function StartState:render()
    
    -- title
    love.graphics.draw(gTextures['logo'],
        -- x - axis
         (VIRTUAL_WIDTH / 2) - 1100,
        -- y - axis
         (VIRTUAL_HEIGHT / 2) - 400,
        -- rotation
         0,
        -- size 
         .700, .700,
        -- fiter
         love.graphics.setDefaultFilter("nearest", "nearest")
        )
    
    -- menu
    love.graphics.draw(gTextures['menu'], 
        -- x - axis
         (VIRTUAL_WIDTH / 2) - 5,
        -- y - axis
         (VIRTUAL_HEIGHT / 2) - 280,
        -- rotation
         0,
        -- size
         .850, .800,
        -- filter 
         love.graphics.setDefaultFilter("nearest","nearest")
        )
    
   -- play button
    love.graphics.draw(gTextures['main_men'], self.button['play'], self.x['play'], self.y['play'], 0, .900, .850)
    
    -- option button
    love.graphics.draw(gTextures['main_men'], self.button['option'], self.x['option'], self.y['option'], 0,.790, .850)

    -- highscore button
    love.graphics.draw(gTextures['main_men'], self.button['highscore'], self.x['highscore'], self.y['highscore'], 0, .860, .850)

    -- quit
    love.graphics.draw(gTextures['main_men'], self.button['quit'], self.x['quit'], self.y['quit'], 0, .860, .850)
 
           
    
    -- if mouse hovers, change image 

    if love.mouseIn(self.x['play'], self.y['play'], self.width['play'], self.height['play']) then
        love.graphics.draw(gTextures['main_men'], self.button['selected_play'], self.x['play'], self.y['play'], 0, .900, .850)
    
    end

    if love.mouseIn(self.x['option'], self.y['option'], self.width['option'], self.height['option']) then
        love.graphics.draw(gTextures['main_men'], self.button['selected_option'], self.x['option'], self.y['option'], 0, .790, .850)   
    end


    if love.mouseIn(self.x['highscore'], self.y['highscore'], self.width['highscore'], self.height['highscore']) then
        love.graphics.draw(gTextures['main_men'], self.button['selected_highscore'], self.x['highscore'], self.y['highscore'], 0, .860, .850)
    end


    if love.mouseIn(self.x['quit'], self.y['quit'], self.width['quit'], self.height['quit']) then
        love.graphics.draw(gTextures['main_men'], self.button['selected_quit'], self.x['quit'], self.y['quit'], 0, .860, .850) 
    end
end
