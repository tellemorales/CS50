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
require 'src/Util'


-- Initialize png's
gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
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
    ['bone'] = love.graphics.newImage('graphics/bone.png')
}

-- initialize fonts
gFonts = {
    ['small'] = love.graphics.newFont('fonts/main.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/main.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/main.ttf', 32)
}

-- initialize sounds
gSounds = {
    ['music'] = love.audio.newSource('sounds/music.mp3', 'static'),
    ['snore'] = love.audio.newSource('sounds/snore.mp3', 'static'),
    ['growl'] = love.audio.newSource('sounds/growl.mp3', 'static'),
    ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static')

}

gFrames = {
    ['tiles'] = GenerateTileQuads(gTextures['bone']),
}
