--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- whether a lock and key should spawn
    local lockSpawned = false
    local keySpawned = false

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        -- do not generate empty columns for last two columns for the flag
        if math.random(7) == 1 and x < (width - 2) then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND
            
            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            -- do not generate pillar for last two columns for the flag
            if math.random(8) == 1  and x < (width - 2) then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block
            if math.random(10) == 1   and x < (width - 2)  then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end

            -- generate a key block
            if math.random(5) == 1 and not keySpawned then
                keySpawned = true
                table.insert(objects,

                    -- key block
                    GameObject {
                        texture = 'keys-locks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- randomly pick color of key
                        frame = KEYS[math.random(#KEYS)],
                        collidable = true,
                        consumable = true,
                        solid = false,

                        -- collision function takes itself
                        onConsume = function(player, obj)
                            -- disappear when player takes key
                            obj.hit = true
                            player.hasKey = true
                            gSounds['empty-block']:play()
                        end
                    }
                )
            end

            -- generate a lock block
            if math.random(5) == 1 and not lockSpawned then
                lockSpawned = true
                table.insert(objects,

                    -- lock block
                    GameObject {
                        texture = 'keys-locks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- randomly pick color of lock
                        frame = LOCKS[math.random(#LOCKS)],
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(player, obj)
                            -- if player has the key, remove the lock block
                            if player.hasKey then 
                                obj.hit = true
                                -- generate post
                                local post = GameObject {
                                    texture = 'post',
                                    -- spawn at right end of the map
                                    x = (width - 2) * TILE_SIZE - 8,
                                    y = 3 * TILE_SIZE,
                                    width = 16,
                                    height = 48,
                                    frame = POSTS[math.random(#POSTS)],
                                    hit = false,
                                   
                                }
                                -- spawn flag
                                local flag = GameObject {
                                    texture = 'flags',
                                    -- spawn at right end of map
                                    x = (width - 2) * TILE_SIZE,
                                    y = 5 * TILE_SIZE,
                                    width = 16,
                                    height = 16,
                                    frame = FLAGS[math.random(#FLAGS)],
                                    collidable = true,
                                    hit = false,
                                    solid = true,

                                    onCollide = function(player, obj)
                                        obj.hit = true
                                        obj.solid = false
                                        -- tween the flag upwards along the post
                                        Timer.tween(0.4, {
                                            [obj] = {y = 3 * TILE_SIZE}
                                        })                                        
                                        gSounds['powerup-reveal']:play()

                                        Timer.after(0.8, function () 
                                            -- reload playstate
                                            gStateMachine:change('play', {
                                                mapWidth = player.map.width,
                                                score = player.score
                                            })                                        
                                        end)
                                    end
                                    
                                }
                                
                                gSounds['powerup-reveal']:play()

                                table.insert(objects, post)
                                table.insert(objects, flag)

                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    if not lockSpawned or not keySpawned then 
        gStateMachine:change('play')
    end
    
    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end