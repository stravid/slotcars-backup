
#= require scm/views/GameView

SCM = this.SCM

SCM.states.GameState = SC.State.extend {

  enterState: ->
     SCM.gameView = SCM.views.GameView.create()
     SCM.gameView.appendTo $('#page')
}