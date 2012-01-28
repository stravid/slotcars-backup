
#= require scm/mediators/GameMediator
#= require scm/views/GameView
#= require scm/controllers/GameController

SCM = this.SCM

SCM.states.GameState = SC.State.extend {

  initialSubstate: 'Initializing',

  Initializing: SC.State.extend {
    enterState: ->
      SCM.gameMediator = SCM.mediators.GameMediator.create()

      SCM.gameView = SCM.views.GameView.create {
        mediator: SCM.gameMediator,
        statechart: @get 'statechart'
      }

      SCM.gameView.appendTo $('#page')

    gameInitialized: ->
      @gotoState 'Loading'
  }

  Loading: SC.State.extend {

    enterState: ->
      SCM.gameMediator.set 'track', SC.Object.create {
        title: 'My First Track',
        author: SC.Object.create {
          name: "Dominik Guzei"
        }
        path: 'M600,200R700,300,400,400,300,200,400,100,600,200z'
      }

      SCM.gameMediator.set 'car', SC.Object.create {
        position: SC.Object.create {
          x: 100,
          y: 100,
          rotation: 30
        }
      }

      @gotoState 'Running'
  }

  Running: SC.State.extend {

    enterState: ->
      SCM.gameController = SCM.controllers.GameController.create {
        mediator: SCM.gameMediator
      }
  }
}