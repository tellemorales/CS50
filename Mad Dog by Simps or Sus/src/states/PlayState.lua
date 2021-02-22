PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.ht = nil
    self.score = 0
    self.timer = 120
    self.board = Board(VIRTUAL_WIDTH, 720, 40)
    self.score = 0
    self.scoregoal = 500 + (self.board.lvl * 500)
    Timer.every(1, function()
        self.timer = self.timer - 1
    )
end

function PlayState:update(dt)
    if self.timer <= 0 then
        Timer.clear()
        gStateMachine:change()
    end

    if self.score >= self.scoregoal then
        self.timer = 120
        self.board.lvl = self.board.lvl + 1
    end

    local mouseX, mouseY = push:toGame(love.mouse.getPosition())
    local mouseGX, mouseGY = math.floor((mouseX-self.board.x)/200)+1, math.floor((mouseY-self.board.y)/200)+1

    local inside = mouseGY > 0 and mouseGX > 0 and mouseGY < 6 and mouseGX < 6

    if inside then
        if isPressed(1) then
            if not self.ht then
                self.ht = self.board.tiles[mouseGY][mouseGX]
            elseif self.ht = self.board.tiles[mouseGY][mouseGX] then
                self.ht = nil
            elseif math.abs(mouseGX-self.ht.gx) + math.abs(mouseGY-self.ht.gy) > 1
                self.ht = nil
            else
                local tx = self.ht.gx
                local ty = self.ht.gy

                local nt = self.board.tiles[mouseGY][mouseGX]

                self.ht.gx = nt.gx
                self.ht.gy = nt.gy
                nt.gx = tx
                nt.gy = ty

                self.board.tiles[self.ht.gy][self.ht.gx] = self.ht
                self.board.tiles[nt.gy][nt.gy] = nt

                Timer.tween(0.1, {
                    [self.ht] = {x = nt.x, y = nt.y},
                    [nt] = {x = self.ht.x, y = self.ht.y}
                }):finish(
                    function ()
                        self:calculate()
                    end
                )
            end
        end        
    end

    Timer.update(dt)
end

function PlayState:calculate()
    self.ht = nil

    local matches = self.board:calculatematch()

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
                self:calculate()
            end
        )
    end
end

function PlayState:render()
    self.board:render()

    if self.ht then
        love.graphics.setBlendMode('add')
        love.graphics.setColor(1, 1, 1, 96/255)
        love.graphics.rectangle('fill', ((self.ht.gx - 1) * 200) + 720,
            ((self.ht.gy - 1) * 200) + 40)
        love.graphics.setBlendMode('alpha')
    end

    love.graphics.setColor(217/255, 87/255, 99/255, 1)


    local mx, my = push:toGame(love.mouse.getPosition())
    local mgx, mgy = math.floor((mouseX-self.board.x)/200)+1, math.floor((mouseY-self.board.y)/200)+1

    local inside = mouseGY > 0 and mouseGX > 0 and mouseGY < 6 and mouseGX < 6
    if inside then
        love.graphics.setLineWidth(4)
        love.graphics.rectangle('line', ((mgx-1) * 200) + 720,
        ((mgy-1) * 200) + 40)
    end
end
