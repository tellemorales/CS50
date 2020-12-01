push = require 'push'

Class = require 'class'

require 'Paddle'

require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Pong')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    
    
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    player1Score = 0
    player2Score = 0

    gameMode = ''

    side  = ''      
    controls = ''     
    servingPlayer = 1

    winningPlayer = 0

    gameState = 'menu_mode'

   

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)

    if gameState == 'serve' then
        
        if gameMode == 'pvp' then                   
            if servingPlayer == 1 then
                ball.dx = math.random(140, 200)
                ball.dy = math.random(-50, 50)
             elseif servingPlayer == 2 then
                ball.dx = -math.random(140, 200)
                ball.dy = math.random(-50, 50)
            end 
        end 

        

        if servingPlayer == 1 and side == 'left' and gameMode == 'pvc' then
            ball.dx = math.random(140, 200)
            ball.dy = math.random(-50, 50)
         elseif servingPlayer == 2 and side == 'left' and gameMode == 'pvc' then  
            ball.dx = -math.random(140, 200)
            ball.dy = math.random(-50, 50)
            gameState = 'play'
         elseif servingPlayer == 1 and side == 'right' and gameMode == 'pvc'  then
                ball.dx = math.random(140, 200)
                ball.dy = math.random(-50, 50)
                gameState = 'play'
             elseif servingPlayer == 2 and side == 'right' and gameMode == 'pvc' then  
                ball.dx = -math.random(140, 200)
                ball.dy = math.random(-50, 50)
        end
     elseif gameState == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end 

            sounds['paddle_hit']:play()
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    end
              
    if gameMode == 'pvp' then
     if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
     elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
     else
        player1.dy = 0
     end
     

     if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
     elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
     else
        player2.dy = 0
     end
    end
    if gameMode == 'pvc' then   
        up_button = 'w'    
        down_button = 's'
     if controls == 'ws' then            
        up_button = 'w'
        down_button = 's'
     elseif controls == 'ud' then
        up_button = 'up'
        down_button = 'down'
     end

     check_width = 0
     if difficulty == 'easy' then
        check_width = VIRTUAL_WIDTH/4
     elseif difficulty == 'hard' then
        check_width = VIRTUAL_WIDTH/2
     elseif difficulty == 'imp' then
        check_width = VIRTUAL_WIDTH
     end


     plr = player1         
     plr_n = player2
     if side == 'left' then
         plr = player1
        plr_n = player2
     elseif side == 'right' then
         plr = player2 
         plr_n = player1
     end
     if ((ball.x - plr_n.x)^2)^(0.5)  < check_width then 
        if (plr_n.y > (ball.y + ball.height/2))  then                   
            plr_n.dy = -PADDLE_SPEED
         elseif (plr_n.y + plr_n.height < (ball.y + ball.height/2))  then
            plr_n.dy = PADDLE_SPEED
         else
            plr_n.dy = 0
        end
     end

     if love.keyboard.isDown(up_button) then             
        plr.dy = -PADDLE_SPEED
      elseif love.keyboard.isDown(down_button) then
        plr.dy = PADDLE_SPEED
       else
        plr.dy = 0
      end
   
    end

    if gameState == 'play' then
        ball:update(dt)
    end
    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        if gameState ~= 'menu_mode' then
         gameState = 'menu_mode'
         ball:reset()
         player1Score = 0
         player2Score = 0
         player1:reset1()
         player2:reset2()
        else
            love.event.quit()
        end

    elseif key == 'enter' or key == 'return' then
       
        
        if  (gameMode == 'pvp') or (gameMode == 'pvc' and ((side == 'left' and servingPlayer == 1) or (side == 'right' and servingPlayer == 2))) then
            if gameState == 'start' then
              gameState = 'serve'
          elseif gameState == 'serve' then
             gameState = 'play'
         elseif gameState == 'done' then
            gameState = 'serve'
    
    
            ball:reset()

            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end

         end
         elseif  (gameMode == 'pvc') and ((side == 'left' and servingPlayer == 2) or (side == 'right' and servingPlayer == 1)) then
            if gameState == 'start' then
                gameState = 'serve'
            end
            
        end

    end
  
    
    if gameState == 'menu_mode' then
        if key == '1'  then
            gameMode = 'pvp'
            gameState = 'start'
        elseif key == '2' then
            gameMode = 'pvc'
            gameState = 'menu_diff'
        end
    
    
    elseif gameState == 'menu_diff' then 
        if key == '1'  then
            difficulty = 'easy'
            gameState = 'menu_side'
        elseif key == '2' then
            difficulty = 'hard'
            gameState = 'menu_side'
        elseif key == '3' then
            difficulty = 'imp'
            gameState = 'menu_side'
        end
    
    elseif gameState == 'menu_side' then
        
        if key == '1' then
            side = 'left'
            gameState = 'menu_ctrl'
        elseif key == '2' then
            side = 'right'
            gameState = 'menu_ctrl'
        end
        
    elseif gameState == 'menu_ctrl' then
        
        if key == '1' then 
            controls = 'ws'
            gameState = 'start'
        elseif key == '2' then
            controls = 'ud'
            gameState = 'start'
        end        
        

    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 1)
    
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
     elseif gameState == 'serve' then
        if gameMode == 'pvp' then
         love.graphics.setFont(smallFont)
         love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
         love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
         elseif gameMode == 'pvc' then
            if (side == 'left' and servingPlayer == 1) or (side == 'right' and servingPlayer == 2) then
                love.graphics.setFont(smallFont)
             love.graphics.printf("Player's serve!", 0, 10, VIRTUAL_WIDTH, 'center')
             love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
             elseif (side == 'left' and servingPlayer == 2) or (side == 'right' and servingPlayer == 1) then
             love.graphics.setFont(smallFont)
             love.graphics.printf("Computer's serve",  0, 10, VIRTUAL_WIDTH, 'center')
             love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
           end
        end
     elseif gameState == 'play' then
        love.graphics.setFont(smallFont)
        if gameMode == 'pvc' then
         love.graphics.printf('diff: '..difficulty..' side: '..side..' controls: '..controls, 0, 10, VIRTUAL_WIDTH, 'center')
        end
     elseif gameState == 'done' then
        

       if gameMode == 'pvp' then
    love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 50, VIRTUAL_WIDTH, 'center')

       
         elseif gameMode == 'pvc' then
         if (side == 'left' and winningPlayer == 1) or (side == 'right' and winningPlayer == 2) then
           love.graphics.setFont(largeFont)
         love.graphics.printf("Player wins", 0, 10, VIRTUAL_WIDTH, 'center')
         love.graphics.setFont(smallFont)
         love.graphics.printf('Press Enter to restart', 0, 30, VIRTUAL_WIDTH, 'center')
         elseif (side == 'left' and winningPlayer == 2) or (side == 'right' and winningPlayer == 1) then
         love.graphics.setFont(largeFont)
         love.graphics.printf("Computer wins",  0, 10, VIRTUAL_WIDTH, 'center')
         love.graphics.setFont(smallFont)
         love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
         end
       end 
       
     elseif gameState == 'menu_mode' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Welcome to Pong!',0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Choose mode:', 0, 90, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('1. Player vs Player \n 2. Player vs Computer \n', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press escape to quit.', 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'right')
        love.graphics.rectangle('line',150, 100 , VIRTUAL_WIDTH/3.25, 70)
        
     elseif gameState == 'menu_diff' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Choose a difficulty.',0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('1. Easy \n \n \n 2. Hard \n \n \n 3. Impossible' , 0, 50, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'menu_side' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Choose a side.',0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(largeFont)
        love.graphics.printf('\t 1. Left \t\t\t\t\t\t\t 2. Right', 0, 125, VIRTUAL_WIDTH, 'left')
    
    elseif gameState == 'menu_ctrl' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Choose your controls.',0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('1. W-S keys \n \n 2. Arrow keys', 0, 50, VIRTUAL_WIDTH, 'center')
 end

    displayScore()
    if gameState ~= 'menu_mode' and gameState ~= 'menu_diff' and gameState ~= 'menu_side' and gameState ~= 'menu_ctrl' then
     player1:render()
     player2:render()
     ball:render()
    end

    displayFPS()

    push:apply('end')
end

function displayScore()
    if gameState ~= 'menu_mode' and gameState ~= 'menu_diff' and gameState ~= 'menu_side' and gameState ~= 'menu_ctrl' then
     love.graphics.setFont(scoreFont)
     love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,VIRTUAL_HEIGHT / 3)
     love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,VIRTUAL_HEIGHT / 3)
    end
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
