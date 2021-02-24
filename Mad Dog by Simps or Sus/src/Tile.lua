Tile = Class{}

function Tile:init(x, y, color, count)
    self.gx = x
    self.gy = y

    self.x = (self.gx - 1) * 100
    self.y = (self.gy - 1) * 100

    self.color = color
    self.count = count
    self.shiny = false
end

function Tile:render(x, y)
    love.graphics.draw(gTextures.bone, gFrames.tiles[self.color][self.count], self.x + x, self.y + y)
    if self.shiny then
        love.graphics.draw(gTextures.double, self.x + x, self.y + y)
    end
end