Board = Class{}

shinyChance = 10

function Board:init(x, y, lvl)
    math.randomseed(os.time())
    self.x = x
    self.y = y
    self.matches = {}
    self.level = lvl
    self.checking = false
    self.reset = false
    self.tiles = {}
    self:Tileinitialize()
end

function Board:Tileinitialize()
    self.tiles = {}
    
    for tY = 1, 10 do
        table.insert(self.tiles, {})
        for tX = 1, 10 do
            local count = math.random(1, math.min(3, self.level))
            local color = math.min(math.random(1, 9 * self.level), math.random(36))
            local t = Tile(tX, tY, color, count)
            
            if math.random(shinyChance) == 1 and self.level >= 4 then
                t.shiny = true
            end
            table.insert(self.tiles[tY], t)
        end
    end
    
    while self:calculatematch() do
        self:Tileinitialize(self.level)
    end
end

function Board:calculatematch()
    local matches = {}

    local matchNum = 1

    for y = 1, 10 do
        local colormatch = self.tiles[y][1].color
        --local countmatch = self.tiles[y][1].count
        matchNum = 1

        for x = 2, 10 do
            if self.tiles[y][x].color == colormatch --[[and self.tiles[y][x].count == countmatch]] then
                matchNum = matchNum + 1
            else
                colormatch = self.tiles[y][x].color
                --countmatch = self.tiles[y][x].count
                if matchNum >= 3 then
                    local match = {}

                    for x2 = x - 1, x - matchNum, -1 do
                        table.insert(match, self.tiles[y][x2])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                if x >= 9 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}
            for x = 10, 10 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end
            table.insert(matches, match)
        end
    end

    for x = 1, 10 do
        local colormatch = self.tiles[1][x].color
        --local countmatch = self.tiles[1][x].count

        matchNum = 1

        for y = 2, 10 do
            if self.tiles[y][x].color == colormatch --[[and self.tiles[y][x].count == countmatch]] then
                matchNum = matchNum + 1
            else
                colormatch = self.tiles[y][x].color
                --countmatch = self.tiles[y][x].count

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                if y >= 9 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}

            for y = 10, 10 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    self.matches = matches

    return #self.matches > 0 and self.matches or false
end

function Board:removematch()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gy][tile.gx] = nil
        end
    end

    self.matches = {}
end

function Board:gettiles()
    local tweens = {}

    for x = 1, 10 do
        local space = false
        local spacey = 0

        local y = 10
        while y >= 1 do
            local tile = self.tiles[y][x]

            if space then
                if tile then
                    self.tiles[spacey][x] = tile
                    tile.gy = spacey
                    self.tiles[y][x] = nil
                    tweens[tile] = {
                        y = (tile.gy - 1) * 100
                    }
                    space = false
                    y = spacey
                    spacey = 0
                end
            elseif tile == nil then
                space = true
                if spacey == 0 then
                    spacey = y
                end
            end
            y = y - 1
        end
    end

    for x = 1, 10 do
        for y = 10, 1, -1 do
            local tile = self.tiles[y][x]

            if not tile then
                local count = math.random(1, math.min(3, self.level))
                local color = math.min(math.random(1, 9 * self.level), math.random(36))
                local t = Tile(x, y, color, count)
                t.y = -100
                if math.random(shinyChance) == 1 and self.level >= 4 then
                    t.shiny = true
                end

                self.tiles[y][x] = t

                tweens[t] = {
                    y = (t.gy - 1) * 100
                }
            end
        end
    end

    return tweens
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end

function Board:swap(x1, y1, x2, y2)
    local tile1 = self.tiles[y1][x1]
    local tile2 = self.tiles[y2][x2]

    local tempX = tile1.gx
    local tempY = tile1.gy

    -- swapping
    tile1.gx = tile2.gx
    tile1.gy = tile2.gy
    tile2.gx = tempX
    tile2.gy = tempY

    self.tiles[tile1.gy][tile1.gx] =
    tile1

    self.tiles[tile2.gy][tile2.gx] = tile2
end