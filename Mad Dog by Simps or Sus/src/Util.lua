--[[
    GD50
    Match-3 Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Helper functions for writing Match-3.
]]

--[[
    Given an "atlas" (a texture with multiple sprites), generate all of the
    quads for the different tiles therein, divided into tables for each set
    of tiles, since each color has 6 varieties.
]]
function GenerateTileQuads(atlas)
    local tiles = {}
    local x = 0
    local y = 0
    local counter = 1
    for pack = 1, 4 do
        for column = 1, 9 do
            tiles[counter] = {}
            for row = 1, 3 do
                table.insert(tiles[counter], love.graphics.newQuad(x, y, 100, 100, atlas:getDimensions()))
                y = y + 100
            end
            counter = counter + 1
            x = x + 100
            y = y - 300
        end
        y = y + 300
        x = 0
    end
    return tiles
end

function GenerateLevel(atlas)
    local y = 0
    local levels = {}
    for i=1, 10 do
        table.insert(levels, love.graphics.newQuad(0, y, 400, 51.1, atlas:getDimensions()))
        y = y + 51.1
    end
    return levels
end

function GenerateQuadsMainButtons(atlas)
    local xbutton = 0
    local ybutton = 0

    local counters = 1
    local main_button = {}

        --play
        main_button[counters] = love.graphics.newQuad(xbutton, ybutton, 769, 110,
            atlas:getDimensions())
        counters = counters + 1

    

    return main_button
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end