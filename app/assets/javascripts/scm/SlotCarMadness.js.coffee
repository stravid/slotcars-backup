
#= require ../lib/raphael

this.SCM = this.SCM ? {}

class SCM.Game

  cars: []
  started: false

  constructor: (@parentId, @width, @height) ->
    @paper = Raphael @parentId, @width, @height

  loadTrack: (@track) ->
    @track.renderTo @paper

  addCar: (car) ->
    cars.push car

  start: ->
    if started
      @_run()

  _run: ->
    animLoop (deltaTime, now) ->
      moveCars(deltaTime)

