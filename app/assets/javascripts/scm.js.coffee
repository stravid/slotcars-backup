
SCM = SC.Application.create {

    ready: ->

      SCM.statechart = SC.Statechart.create {

        initialState: 'Game',

        Game: SCM.states.GameState
      }

      SCM.statechart.initStatechart();

      @_super()

}

# create namespaces
SCM.models = {}
SCM.views = {}
SCM.controllers = {}
SCM.mediators = {}
SCM.states = {}
SCM.templates = {}

# export SCM to global namespace
this.SCM = SCM