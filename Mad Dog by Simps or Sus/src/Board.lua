Board = Class{}

shinyChance = 10

function Board:init(x, y, lvl)
    self.x = x
    self.y = y
    self.matches = {}
    self.lvl = lvl
    self.checking = false
    self.reset = false

    self.initialize(self.lvl)
end

function Board:initialize(lvl)
    self.tiles = {}
    for tY = 1, 5 do
        table.insert(self.tiles, {})
        for tX = 1, 5 do
            local count = math.random(1, math.min(3, self.lvl))
            local color = math.min(math.random(1, 9 * self.lvl), math.random(36))
            local t = Tile(tX, tY, color, count)
            if math.random(shinyChance == 1) and self.lvl >= 4 then
                t.shiny = true
            end
            table.insert(self.tiles[tY], t)
        end
    end

    while self:calculatematch() do
        self.initialize(self.lvl)
    end
end

function Board:calculatematch()
    local matches = {}

    local matchNum = 1

    for y = 1, 5 do
        local colormatch = self.tiles[y][1].color
        local countmatch = self.tiles[y][1].count
        matchNum = 1

        for x = 2, 5 do
            if self.tiles[y][x].color == colormatch and  self.tiles[y][x].count == countmatch then
                matchNum = matchNum + 1
            else
                colormatch = self.tiles[y][x].color
                countmatch = self.tiles[y][x].count
                if matchNum >= 3 then
                    local match = {}

                    for x2 = x - 1, x - matchNum, -1 do
                        table.insert(match, self.tiles[y][x2])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                if x >= 4 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}
            for x = 5, 5 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end
            table.insert(matches, match)
        end
    end

    for x = 1, 5 do
        local colormatch = self.tiles[1][x].color
        local countmatch = self.tiles[1][x].count

        matchNum = 1

        for y = 2, 5 do
            if self.tiles[y][x].color == colormatch and self.tiles[y][x].count == countmatch then
                matchNum = matchNum + 1
            else
                colormatch = self.tiles[y][x].color
                countmatch = self.tiles[y][x].count

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                if y >= 4 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}

            for y = 5, 5 - matchNum + 1, -1 do
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
        for j, tile in pairs(match) do
            self.tiles[tile.gy][tile.gx] = nil
        end
    end

    self.matches = {}
end

function Board:gettiles()
    local tweens = {}

    for x = 1, 5 do
        local space = false
        local spacey = 0

        local y = 5
        while y >= 1 do
            local tile = self.tiles[y][x]

            if space then
                if tile then
                    self.tiles[spacey][x] = tile
                    tile.gy = sy
                    self.tiles[y][x] = nil
                    tweens[tile] = {
                        y = (tile.gy - 1) * 200
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

    for x = 1, 5 do
        for y = 5, 1, -1 do
            local tile = self.tiles[y][x]

            if not tile then
                local count = math.random(1, math.min(3, self.lvl))
                local color = math.min(math.random(1, 9 * self.lvl), math.random(36))
                local t = Tile(tX, tY, color, count)
                t.y = -200
                if math.random(shinyChance = 1) and self.lvl >= 4 then
                    t.shiny = true
                end

                self.tiles[y][x] = t

                tweens[t] = {
                    y = (t.gy - 1) * 200
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
