PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.ht = nil
    self.score = 0
    self.timer = 60
    self.caninput = true

    Timer.every(1, function() 
        self.timer = self.timer - 1
    end)
end

function PlayState:enter(params)
    self.lvl = params.lvl
    self.board = params.board or Board(VIRTUAL_WIDTH, 100, self.lvl)
    self.score = params.score or 0
    self.scoregoal = self.lvl * 1.25 * 1000
end

function PlayState:update(dt)
    if self.timer <= 0 then
        Timer.clear()

        -- change to game over state
    end

    if self.score >= self.scoregoal then
        self.timer = 60
        self.board.lvl = self.board.lvl + 1
    end

    if self.ht then
        self:mouseselect()
    else
        self:mousehighlight()
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
                    self.score = self.score + (tile.count * 10) * 2
                else
                    self.score = self.score + tile.count * 10
                end
            end
            self.score = self.score + #match * 50
            self.timer = self.timer + 1
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

function PlayState:mousehighlight()
    local mx, my = push:toGame(love.mouse.getPosition())

    local mgx = math.floor((mx - self.board.x)/200) + 1
    local mgy = math.floor((my - self.board.y)/200) + 1

    if mgx > 0 and mgy > 0 and mgx < 9 and mgy < 9 then
        if love.mouse.wasClicked(1) then
            if not self.ht then
                self.ht = self.board.tiles[mgy][mgx]
            end
        end
    end
end

function PlayState:mouseselect()
    local hx = self.ht.gx
    local hy = self.ht.gy

    local mx, my = push:toGame(love.mouse.getPosition())
    local mgx, mgy = math.floor((mx - self.board.x )/200) + 1, math.floor((my - self.board.y)/200) + 1

    if love.mouse.wasClicked(1) and (hx > 0 and hy > 0 and hx < 6 and hy < 6) then
        if math.abs(mgx-hx) + math.abs(mgy-hy) <= 1 then
            local tx = self.ht.gx
            local ty = self.ht.gy

            local nt = self.board.tiles[mgy][mgy]

            self.ht.gx = nt.gx
            self.ht.gy = nt.gy
            nt.gx = tx
            nt.gy = ty

            self.board.tiles[self.ht.gy][self.ht.gx] = self.ht
            self.board.tiles[nt.gy][nt.gy] = nt

            Timer.tween(0.1, {
                [th] = {x = ts.x, y = ts.y},
                [ts] = {x = th.x, y = th.y}
            }):finish(
                function ()
                    self:calculate()
                end
            )
        else
            self.ht = nil
        end
    end
end