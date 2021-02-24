--[[
    Mad Dog Game

    Author: Simps or Sus

    -- OptionState --

    NOTE: All CAPS are considered constants
]] --

-- value of game volume set to default
local game_vol = 1

-- rectangle speed 
local RECT_SPEED = 200
-- position of rectangle that adjusts the volume in terms of x
local pos_rec = 1268

OptionState = Class{__includes = BaseState}

function OptionState:enter(params)
    self.highScores = params.highScores
end


function OptionState:init()

    -- main menu button initiation
    self.buttons = {
        ['return'] = love.graphics.newQuad(0, 0, 512, 91, gTextures['option_menu']:getDimensions()),
        ['selected_return'] = love.graphics.newQuad(0, 91, 512, 91, gTextures['option_menu']:getDimensions())
    } 

    self.x = {
        ['return'] = (VIRTUAL_WIDTH / 2) - 190,
        ['right_arrow'] = (VIRTUAL_WIDTH / 2) + 280,
        ['paddleX'] = 910,
        ['paddleY'] = pos_rec,
        ['plus'] = 1293,
        ['minus'] = 886
    }

    self.y = {
        ['return'] = (VIRTUAL_HEIGHT / 2) - 10,
        ['right_arrow'] = (VIRTUAL_HEIGHT / 2) + 125,
        ['paddleX'] = 452,
        ['paddleY'] = 423.5,
        ['operator'] = 414
    }

    self.width = {
        ['return'] = 425,
        ['arrow'] = 81,
        ['paddleX'] = 388,
        ['paddleY'] = 16,
        ['plus'] = gFonts['XXXLarge']:getWidth('+'),
        ['minus'] = gFonts['XXXLarge']:getWidth('-')

    }

    self.height = {
        ['return'] = 71,
        ['arrow'] = 63,
        ['paddleX'] = 8,
        ['paddleY'] = 64,
        ['plus'] = gFonts['XXXLarge']:getHeight('+'),
        ['minus'] = gFonts['XXXLarge']:getHeight('-')
    }
    
    

    
end


function OptionState:update(dt)

    -- value to be deduced per decrement of speed of the rectangle
    local vol_adjust_value = (1 + 0) / 56

    if love.mouseIn(self.x['return'], self.y['return'], self.width['return'], self.height['return']) and isPressed(1) then
        gStateMachine:change('start', {
          highScores = self.highScores
        })
        gSounds['select']:play()
    end

    if love.mouseIn(self.x['right_arrow'], self.y['right_arrow'], self.width['arrow'], self.height['arrow']) and isPressed(1) then
        page = 1
        gStateMachine:change('rules', {
            highScores = self.highScores
        })
        gSounds['select']:play()
    end

    if love.mouse.isDown(1) then

        if love.mouseIn(self.x['minus'], self.y['operator'], self.width['minus'], self.height['minus']) then 

        -- add negative rectangle speed to musicY
            pos_rec = math.max(930, pos_rec - RECT_SPEED * dt)
            game_vol = math.max(0, game_vol - vol_adjust_value)
        
        elseif love.mouseIn(self.x['plus'], self.y['operator'], self.width['plus'], self.height['plus']) then
        -- add positive rectangle speed to musicY
            pos_rec = math.min(1268, pos_rec + RECT_SPEED * dt)
            game_vol = math.min(1, game_vol + vol_adjust_value)
        end
    end

    gSounds['music']:setVolume(game_vol)

end


function OptionState:render()

    -- menu
    love.graphics.draw(gTextures['menu'], (VIRTUAL_WIDTH / 2) - 450, (VIRTUAL_HEIGHT / 2) - 280, 0, .830, .800)
    
    -- main menu button
    love.graphics.draw(gTextures['option_menu'], self.buttons['return'], self.x['return'], self.y['return'], 0, .830, .800 )
    
    --right arrow
    love.graphics.draw(gTextures['right_arrow'],  self.x['right_arrow'] , self.y['right_arrow'], 0, .300, .270)

    if love.mouseIn(self.x['return'], self.y['return'], self.width['return'], self.height['return']) then
        love.graphics.draw(gTextures['option_menu'], self.buttons['selected_return'], self.x['return'], self.y['return'], 0, .830, .800 )
    end

    if love.mouseIn(self.x['right_arrow'], self.y['right_arrow'], self.width['arrow'], self.height['arrow']) then
        love.graphics.draw(gTextures['selected_right_arrow'], self.x['right_arrow'] , self.y['right_arrow'], 0, .300, .270)
    end
         

    -- render text
    love.graphics.setColor(56, 56, 56, 234)
    musicX = love.graphics.rectangle('fill', 930, 452, 348, 8, 4)

    musicY = love.graphics.rectangle('fill', pos_rec, 423.5, 16, 64, 4)
    
    love.graphics.setFont(gFonts['XXXLarge'])
    plus = love.graphics.printf('+', 1293, 414, 260, 'left')
    minus = love.graphics.printf('-', 886, 414, 260, 'left')

    love.graphics.setFont(gFonts['XXLarge'])
    love.graphics.printf('Music:', 640, 423, 260, 'center')


end