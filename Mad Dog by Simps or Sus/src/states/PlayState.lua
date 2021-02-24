PlayState = Class{__includes = BaseState}


function PlayState:init()
    self.ht = nil
    self.score = 0
    self.timer = 120
    self.board = Board(820, 40, 1)
    self.score = 0
    self.scoregoal = 300
    Timer.every(1, function()
        self.timer = self.timer - 1
    end)
    isPause = false
end

function PlayState:update(dt)
    if not isPause then
        if self.timer <= 0 then
            Timer.clear()
            gStateMachine:change()
        end

        if self.score >= self.scoregoal then
            self.scoregoal = self.scoregoal + 50
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
    else

    end
end

function PlayState:highlight()
    local mouseX, mouseY = push:toGame(love.mouse.getPosition())
    local mouseGX, mouseGY = math.floor((mouseX-self.board.x)/100)+1, math.floor((mouseY-self.board.y)/100)+1
    local inside = mouseGX > 0 and mouseGY > 0 and mouseGX < 11 and mouseGY < 11
    if inside then
        if love.mouse.wasClicked(1) then
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

    if love.mouse.wasClicked(1) and inside then
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
end
