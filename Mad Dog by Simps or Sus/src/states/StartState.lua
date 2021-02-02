
StartState = Class{__includes = BaseState}
-- whether we're highlighting "Start" or "High Scores"
local highlighted = 0


function StartState:update(dt)

    if love.keyboard.wasPressed(key) then  
        gSounds['select']:play()
    end

    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('up') then
            highlighted = highlighted - 1
        if highlighted == 0 then
            highlighted = 4 
        end

        
    elseif love.keyboard.wasPressed('down') then
        highlighted = highlighted + 1
        if highlighted == 2 then
            highlighted = 3
        end
        if highlighted == 5 then
            highlighted = 1
        end


    elseif love.keyboard.wasPressed('right') then
        highlighted = highlighted + 1
        if highlighted == 5 then
            highlighted = 1
        end

    elseif love.keyboard.wasPressed('left') then
        highlighted = highlighted - 1
        if highlighted == 0 then
            highlighted = 4
        end
       
    end

    -- we no longer have this globally, so include here
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end


function StartState:render()

    -- get x coordinate of each image
    local x = {
        ['play'] = (VIRTUAL_WIDTH / 2) + 150,
        ['option'] = (VIRTUAL_WIDTH / 2) + 420,
        ['highscore'] = (VIRTUAL_WIDTH / 2) + 150,
        ['quit'] = (VIRTUAL_WIDTH / 2) + 150
    }
    -- get y coordinate of each image
    local y = {
        ['play'] = (VIRTUAL_HEIGHT / 2) - 130,
        ['option'] = (VIRTUAL_HEIGHT / 2) - 130,
        ['highscore'] = (VIRTUAL_HEIGHT / 2) - 25,
        ['quit'] = (VIRTUAL_HEIGHT / 2) + 80
    }
    
    local button_quad = {
        ['play'] = love.graphics.newQuad(0, 220 , 285, 110, gTextures['main_men']:getDimensions()),
        ['selected_play'] = love.graphics.newQuad(0, 330 , 285, 110, gTextures['main_men']:getDimensions()),
        ['option'] = love.graphics.newQuad(769, 0, 470, 110, gTextures['main_men']:getDimensions()),
        ['selected_option'] = love.graphics.newQuad(769, 110, 470, 110, gTextures['main_men']:getDimensions()),
        ['quit'] = love.graphics.newQuad(285, 220, 769, 111, gTextures['main_men']:getDimensions()),
        ['selected_quit'] = love.graphics.newQuad(285, 330, 769, 111, gTextures['main_men']:getDimensions()),
        ['highscore'] = love.graphics.newQuad(0, 0, 769, 110, gTextures['main_men']:getDimensions()),
        ['selected_highscore'] = love.graphics.newQuad(0, 110 , 769, 110, gTextures['main_men']:getDimensions()),
    }

    -- get width
    local w = {
        ['play'] = 285,
        ['option'] = 470,
        ['highscore'] = 769,
        ['quit'] = 769,
    }
    
    -- get height
    local h = {
        ['play'] = 110,
        ['option'] = 110,
        ['highscore'] = 110,
        ['quit'] = 111
    }
    
    
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
         .830, .800,
        -- filter 
         love.graphics.setDefaultFilter("nearest","nearest")
        )
    -- play button
    love.graphics.draw(gTextures['main_men'], button_quad['play'], x['play'], y['play'], 0, .900, .850)
    
    -- option button
    love.graphics.draw(gTextures['main_men'], button_quad['option'], x['option'], y['option'], 0,.790, .850)

    -- highscore button
    love.graphics.draw(gTextures['main_men'], button_quad['highscore'], x['highscore'], y['highscore'], 0, .835, .850)

    -- quit
    love.graphics.draw(gTextures['main_men'], button_quad['quit'], x['quit'], y['quit'], 0, .835, .850)
    
 
           
    
    -- if we're highlighting 1, change image 
    if highlighted == 1 or love.mouseIn(x['play'], y['play'], w['play'], h['play']) then
        love.graphics.draw(gTextures['main_men'], button_quad['selected_play'], x['play'], y['play'], 0, .900, .850)
    
    end


    -- change image if we're highlighting 2
    if highlighted == 2 or love.mouseIn(x['option'], y['option'], w['option'], h['option']) then
        love.graphics.draw(gTextures['main_men'], button_quad['selected_option'], x['option'], y['option'], 0, .790, .850)   
    end


    if highlighted == 3 or love.mouseIn(x['highscore'], y['highscore'], w['highscore'], h['highscore']) then
        love.graphics.draw(gTextures['main_men'], button_quad['selected_highscore'], x['highscore'], y['highscore'], 0, .835, .850)
    end


    if highlighted == 4 or love.mouseIn(x['quit'], y['quit'], w['quit'], h['quit']) then
        love.graphics.draw(gTextures['main_men'], button_quad['selected_quit'], x['quit'], y['quit'], 0, .835, .850) 
    end
end