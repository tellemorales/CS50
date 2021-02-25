PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
    self.highScores = params.highScores
    self.score = params.score
    self.scoreIndex = params.scoreIndex
end

function PauseState:init()
    self.x = 
    self.y = 
    self.width = 
    self.height = 

end

function PauseState:update(dt)

end

function PauseState:render()

end