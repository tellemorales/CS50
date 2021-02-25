PlayState = Class{__includes = BaseState}


function PlayState:enter(params)
    self.highScores = params.highScores
end

function PlayState:init()
    self.button = {
        ['resume'] = love.graphics.newQuad(907, 0 , 395, 91, gTextures['pause_menu']:getDimensions()),
        ['selected_resume'] = love.graphics.newQuad(907, 91 , 395, 91, gTextures['pause_menu']:getDimensions()),
        ['restart'] = love.graphics.newQuad(512, 0, 395, 91, gTextures['pause_menu']:getDimensions()),
        ['selected_restart'] = love.graphics.newQuad(512, 91, 395, 91, gTextures['pause_menu']:getDimensions()),
        ['main_menu'] = love.graphics.newQuad(0, 0, 512, 91, gTextures['pause_menu']:getDimensions()),
        ['selected_main_menu'] = love.graphics.newQuad(0, 91, 512, 91, gTextures['pause_menu']:getDimensions())
    }
    self.x = {
        ['pause'] = 10,
        ['resume'] = (VIRTUAL_WIDTH / 2) - 155,
        ['main'] = (VIRTUAL_WIDTH / 2) - 200
    }
    self.y = {
        ['pause'] = 10,
        ['resume'] =  (VIRTUAL_HEIGHT / 2) - 120,
        ['restart'] = (VIRTUAL_HEIGHT / 2) - 20,
        ['main'] = (VIRTUAL_HEIGHT / 2) + 80
    }
    self.width = {
        ['pause'] = gTextures.pause:getWidth(),
        ['resume'] = 367,
        ['main'] = 476
    }
    self.height = {
       ['pause'] = gTextures.pause:getHeight(),
       ['resume'] = 81,
       ['main'] = 81
    }
    self.ht = nil
    self.timer = 120
    self.score = 0
    self.board = Board(820, 40, 1)
    self.scoregoal = 300
    Timer.every(1, function()
        self.timer = self.timer - 1

        if self.timer <= 10 then
            gSounds['timer']:play()
        end
    end)
    isPause = false
end



function PlayState:update(dt)
    pausepage = 1

    if love.mouseIn(self.x['pause'], self.y['pause'], self.width['pause'], self.height['pause']) and isPressed(1) then
        isPause = true
        gSounds['pause']:play()
    end




    if not isPause then
        if self.timer <= 0 then
            Timer.clear()
            gStateMachine:change('gameover',{
                highScores = self.highScores,
                gamescore = self.score
            })
            gSounds['timer']:pause()
            gSounds['gameover']:play()
            gSounds['music']:pause()
        end

        if self.score >= self.scoregoal then
            self.scoregoal = self.scoregoal + 50

            gSounds['levelup']:play()

            if self.board.level < 5 then  
                self.timer = 120 * (self.board.level + 1)
                self.board.level = self.board.level + 1
            end        
        end

        if self.ht then
            self:select()
        else
            self:highlight()
        end

        Timer.update(dt)
    elseif isPause then
        gSounds['music']:pause()
        pausepage = 2

        if love.mouseIn(self.x['resume'], self.y['resume'], self.width['resume'], self.height['resume']) and isPressed(1) then
                isPause = false
                pausepage = 1
                gSounds['music']:play()
                gSounds['select']:play()
        elseif love.mouseIn(self.x['resume'], self.y['restart'], self.width['resume'], self.height['resume']) and isPressed(1) then
            gStateMachine:change('play', {
                highScores = self.highScores
            })
            gSounds['music']:setLooping(true)
            gSounds['music']:play()
            gSounds['select']:play()
            
        elseif love.mouseIn(self.x['main'], self.y['main'], self.width['main'], self.height['main']) and isPressed(1) then
            gStateMachine:change('start', {
                highScores = self.highScores
            })
            gSounds['music']:play()
            gSounds['select']:play()
        end
    end
end

function PlayState:highlight()
    local mouseX, mouseY = push:toGame(love.mouse.getPosition())
    local mouseGX, mouseGY = math.floor((mouseX-self.board.x)/100)+1, math.floor((mouseY-self.board.y)/100)+1
    local inside = mouseGX > 0 and mouseGY > 0 and mouseGX < 11 and mouseGY < 11
    if inside then
        if isPressed(1) then
            if self.ht == nil then
                self.ht = self.board.tiles[mouseGY][mouseGX]
            end
        end
    end
end

function PlayState:select()
    local hx = self.ht.gx
    local hy = self.ht.gy
    local mouseX, mouseY = push:toGame(love.mouse.getPosition())
    local mouseGX, mouseGY = math.floor((mouseX-self.board.x)/100)+1, math.floor((mouseY-self.board.y)/100)+1
    local inside = mouseGX > 0 and mouseGY > 0 and mouseGX < 11 and mouseGY < 11

    if isPressed(1) and inside then
        gSounds['select']:play()
        if math.abs(mouseGX - hx) + math.abs(mouseGY - hy) <= 1 then
            local highTile = self.board.tiles[hy][hx]
            local swapTile = self.board.tiles[mouseGY][mouseGX]

            self.board:swap(mouseGX, mouseGY, hx, hy)

            Timer.tween(0.1, {
                [highTile] = {x = swapTile.x, y = swapTile.y},
                [swapTile] = {x = highTile.x, y = highTile.y}
            })
            :finish(function()
                self:calculate(mouseGX, mouseGY, hx, hy)                
            end)
        else
            self.ht = nil
        end
    end
end

function PlayState:calculate(x1, y1, x2, y2)
    self.ht = nil

    local matches = self.board:calculatematch()

    if not matches and x1 > 0 then
        local tile1 = self.board.tiles[y2][x2]
        local tile2 = self.board.tiles[y1][x1]

        -- swap tile information
        local tempX, tempY = tile2.x, tile2.y
        local tempgridX, tempgridY = tile2.gx, tile2.gy

        -- swap places in the board
        local tempTile = tile1
        self.board.tiles[tile1.gy][tile1.gx] = tile2
        self.board.tiles[tile2.gy][tile2.gx] = tempTile

        -- swap coordinates and tile grid positions
        tile2.x, tile2.y = tile1.x, tile1.y
        tile2.gx, tile2.gy = tile1.gx, tile1.gy
        tile1.x, tile1.y = tempX, tempY
        tile1.gx, tile1.gy = tempgridX, tempgridY
    end

    if matches then
        for a, match in pairs(matches) do
            for b, tile in pairs(match) do
                if tile.shiny then
                    self.score = self.score + (tile.count * 20)
                    self.timer = math.min(120, self.timer + 2)
                else
                    self.score = self.score + (tile.count * 10)
                    self.timer = math.min(120, self.timer + 1)
                end
            end
        end

        self.board:removematch()

        local fall = self.board:gettiles()

        Timer.tween(0.25, fall):finish(
            function()
                self:calculate(0,0,0,0)
            end
        )
    end
end

function PlayState:render()

    if pausepage == 1 then
        self.board:render()

        love.graphics.draw(gTextures.pause, 10, 10)

        love.graphics.setColor(110/255, 61/255, 22/255, 1)
        love.graphics.rectangle('fill', 100, 150, 600, 600, 25, 25)

        if self.board.level == 1 then
            love.graphics.draw(gTextures.levels, gFrames.levels[2], 200, 200)
        elseif self.board.level == 2 then
            love.graphics.draw(gTextures.levels, gFrames.levels[4], 200, 200)
        elseif self.board.level == 3 then
            love.graphics.draw(gTextures.levels, gFrames.levels[6], 200, 200)
        elseif self.board.level == 4 then
            love.graphics.draw(gTextures.levels, gFrames.levels[8], 200, 200)
        elseif self.board.level == 5 then
            love.graphics.draw(gTextures.levels, gFrames.levels[10], 200, 200)
        end

        love.graphics.setColor(1,1,1,1)

        love.graphics.setFont(gFonts.XXLarge)
        love.graphics.print("SCORE: ", 235, 300)
        love.graphics.print("GOAL: ", 235, 375)
        love.graphics.print("TIME: ", 235, 450)

        love.graphics.setFont(gFonts.num)
        love.graphics.print(self.score, 500, 290)
        love.graphics.print(self.scoregoal, 450, 365)
        love.graphics.print(self.timer, 450, 440)

        love.graphics.draw(gTextures.dog, 50, 600)

        if self.ht then
            love.graphics.setBlendMode('add')
            love.graphics.setColor(1, 1, 1, 96/255)
            love.graphics.rectangle('fill', ((self.ht.gx - 1) * 100) + 820,
                ((self.ht.gy - 1) * 100) + 40, 100, 100)
            love.graphics.setBlendMode('alpha')
        end

        love.graphics.setColor(217/255, 87/255, 99/255, 1)


        local mx, my = push:toGame(love.mouse.getPosition())
        local mgx, mgy = math.floor((mx-self.board.x)/100)+1, math.floor((my-self.board.y)/100)+1

        local inside = mgy > 0 and mgx > 0 and mgy < 11 and mgx < 11
        if inside then
            love.graphics.setLineWidth(4)
            love.graphics.rectangle('line', ((mgx-1) * 100) + 820,
            ((mgy-1) * 100) + 40, 100, 100)
        end
    elseif pausepage == 2 then
         -- menu
        love.graphics.draw(gTextures['menu'], (VIRTUAL_WIDTH / 2) - 450, (VIRTUAL_HEIGHT / 2) - 280, 0, .830, .800)

        -- resume button
        love.graphics.draw(gTextures['pause_menu'], self.button['resume'], self.x['resume'], self.y['resume'], 0, .930, .900)

        -- restart button
        love.graphics.draw(gTextures['pause_menu'], self.button['restart'], self.x['resume'], self.y['restart'] , 0, .930, .900)
        -- main menu button
        love.graphics.draw(gTextures['pause_menu'], self.button['main_menu'], self.x['main'], self.y['main'], 0, .930, .900)

        if love.mouseIn(self.x['resume'], self.y['resume'], self.width['resume'], self.height['resume']) then
            love.graphics.draw(gTextures['pause_menu'], self.button['selected_resume'], self.x['resume'], self.y['resume'], 0, .930, .900)
    
        elseif love.mouseIn(self.x['resume'], self.y['restart'], self.width['resume'], self.height['resume']) then
            love.graphics.draw(gTextures['pause_menu'], self.button['selected_restart'], self.x['resume'], self.y['restart'] , 0, .930, .900)

        elseif love.mouseIn(self.x['main'], self.y['main'], self.width['main'], self.height['main']) then
            love.graphics.draw(gTextures['pause_menu'], self.button['selected_main_menu'], self.x['main'], self.y['main'], 0, .930, .900)
        end
    end
end
