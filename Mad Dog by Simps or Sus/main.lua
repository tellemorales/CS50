--[[
    Mad Dog Game

    Author: Simps or Sus

    -- main --

    NOTE: All CAPS are considered constants
]] --

-- require dependencies content
require 'src/Dependencies'

-- initialize physical dimension
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- initialize virtual dimension
VIRTUAL_WIDTH = 1920
VIRTUAL_HEIGHT = 1080


function love.load()

    -- set window title
    love.window.setTitle('Mad Dog')
    
    -- initialize nearest-neigbhor filters
    love.graphics.setDefaultFilter('nearest', 'nearest')

     -- initialize virtual resolution
     push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = false,
        canvas = true
    })

    -- set music loop
    gSounds['music']:setLooping(true)
    gSounds['music']:play()


    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['option'] = function() return OptionState() end,
        ['rules'] = function() return RuleState() end,
        ['highscore'] = function() return HighScoreState() end,
        ['enter highscore'] = function() return EnterHighScoreState() end
    }
    gStateMachine:change("start", {
        highScores = loadHighScores()
    })

    love.keyboard.keysPressed = {}
    
    globalInput = {}

    -- create a global mouse x y table
    currentMousePos = {["x"] = nil, ["y"] = nil}

end

function love.mouseIn(x, y, width, height)
    if (currentMousePos.x >= x and currentMousePos.x <= x + width) and 
        (currentMousePos.y >= y and currentMousePos.y <= y + height) then
            return true
        else
            return false
    end
end

function love.update(dt)
    -- gather the current x y of mouse
    x, y = love.mouse.getPosition()
    -- "recalibrate" the x y since the game is in virtual reso due to push
    currentMousePos.x, currentMousePos.y = push:toGame(x, y)

    gStateMachine:update(dt)
    
    globalInput = {}

    -- reset the key that was pressed
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end

end

function love.mousepressed(x, y, button, istouch, presses)
    globalInput[button] = true
end


function isPressed(key)
    return globalInput[key]
end

function love.draw()
    push:start()

    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], 
        -- draw at coordinates 0, 0
        0, 0, 
        -- no rotation
        0,
        -- scale factors on X and Y axis so it fills the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    gStateMachine:render()

    push:finish()
end

function loadHighScores()
    love.filesystem.setIdentity('maddog')

    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.getInfo('maddog.lst') == nil then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'MDG\n'
            scores = scores .. tostring(i * 1000) .. '\n'
        end

        love.filesystem.write('maddog.lst', scores)
    end

    -- flag for whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a name and a score
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('maddog.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    return scores

    
end

