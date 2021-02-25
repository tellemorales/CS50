--[[
    Mad Dog Game

    Author: Simps or Sus
    
    -- Dependencies --

    A file to organize all necessary dependecies for our project.
]] -- 

Class = require 'library/class'

push = require 'library/push'

Timer = require 'library/knife.timer'
-- source folder
require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/OptionState'
require 'src/states/RuleState'
require 'src/states/EnterHighScoreState'
require 'src/states/HighScoreState'
require 'src/states/GameOverState'
require 'src/Util'
require 'src/Board'
require 'src/Tile'



-- Initialize png's
gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['mad_dog'] = love.graphics.newImage('graphics/mad_dog.png'),
    ['menu'] = love.graphics.newImage('graphics/main_menu.png'),
    ['pause'] = love.graphics.newImage('graphics/pause.png'),
    ['main_men'] = love.graphics.newImage('graphics/main_buttons.png'),
    ['pause_menu'] = love.graphics.newImage('graphics/pause_buttons.png'),
    ['quit_buttons'] = love.graphics.newImage('graphics/quit_button.png'),
    ['quit_menu'] = love.graphics.newImage('graphics/quit_menu.png'),
    ['clock'] = love.graphics.newImage('graphics/clock.png'),
    ['dog'] = love.graphics.newImage('graphics/dog.png'),
    ['powerup'] = love.graphics.newImage('graphics/powerup.png'),
    ['option_menu'] = love.graphics.newImage('graphics/option_buttons.png'),
    ['zzz'] = love.graphics.newImage('graphics/z.png'),
    ['logo'] = love.graphics.newImage('graphics/logo.png'),
    ['bone'] = love.graphics.newImage('graphics/bone.png'),
    ['left_arrow'] = love.graphics.newImage('graphics/left_arrow.png'),
    ['selected_left_arrow'] = love.graphics.newImage('graphics/selected_left_arrow.png'),
    ['right_arrow'] = love.graphics.newImage('graphics/right_arrow.png'),
    ['selected_right_arrow'] = love.graphics.newImage('graphics/selected_right_arrow.png'),
    ['up_arrow'] = love.graphics.newImage('graphics/up_arrow.png'),
    ['selected_up_arrow'] = love.graphics.newImage('graphics/up_arrow_selected.png'),
    ['down_arrow'] = love.graphics.newImage('graphics/down_arrow.png'),
    ['selected_down_arrow'] = love.graphics.newImage('graphics/down_arrow_selected.png'),
    ['rules'] = love.graphics.newImage('graphics/title_rule.png'),
    ['double'] = love.graphics.newImage('graphics/tile_x2.png'),
    ['levels'] = love.graphics.newImage('graphics/levels.png'),
}

-- initialize fonts
gFonts = {
    ['small'] = love.graphics.newFont('fonts/main.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/main.ttf', 16),
    ['Xmedium'] = love.graphics.newFont('fonts/main.ttf', 24),
    ['large'] = love.graphics.newFont('fonts/main.ttf', 32),
    ['XLarge'] = love.graphics.newFont('fonts/main.ttf', 48),
    ['XXLarge'] = love.graphics.newFont('fonts/main.ttf', 64),
    ['XXXLarge'] = love.graphics.newFont('fonts/main.ttf', 94),
    ['Giant'] = love.graphics.newFont('fonts/main.ttf', 128),
    ['numfont'] = love.graphics.newFont('fonts/number.ttf', 66),
    ['num'] = love.graphics.newFont('fonts/number.ttf', 64),
}

-- initialize sounds
gSounds = {
    ['music'] = love.audio.newSource('sounds/music.mp3', 'stream'),
    ['snore'] = love.audio.newSource('sounds/snore.mp3', 'static'),
    ['growl'] = love.audio.newSource('sounds/growl.mp3', 'static'),
    ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['gameover'] = love.audio.newSource('sounds/game_over.mp3', 'static'),
    ['levelup'] = love.audio.newSource('sounds/level_up.mp3', 'static')

}

gFrames = {
    ['tiles'] = GenerateTileQuads(gTextures['bone']),
    ['levels'] = GenerateLevel(gTextures['levels']),
}

