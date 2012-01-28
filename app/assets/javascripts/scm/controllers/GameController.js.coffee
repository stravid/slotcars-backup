
#= require scm/controllers/GameLoopController
#= require scm/controllers/CarController

SCM = this.SCM

SCM.controllers.GameController = SCM.controllers.GameLoopController.extend {

  world: null
  car: null

  mediator: null
  carDataBinding: 'mediator.car'

  debugMode: false

  init: ->
    @_super()
    @_createWorld()

    SC.run.sync()

    mediator = @get 'mediator'
    carData = @get 'carData'

    car = SCM.controllers.CarController.create {
      delegate: this
      world: @get 'world'
      path: mediator.get('track').get('path')
      scaleFactor: mediator.get 'scaleFactor'
      width: carData.get 'width'
      length: carData.get 'length'
    }

    @set 'car', car

    if @get 'debugMode'
      @_setupDebugMode()

  start: ->
    @_super(@update)

  update: (deltaT, now) ->

    car = @get 'car'
    car.update(deltaT)
    car.accelerate()

    @get('carData').set 'position', {
      x: car.get('x'),
      y: car.get('y'),
      rotation: car.get('rotation')
    }

    world = @get 'world'
    world.Step(1/60, 10, 10)
    world.ClearForces()
    if @get 'debugMode' then world.DrawDebugData()

  _createWorld: ->
    @set 'world', new Box2D.Dynamics.b2World( new Box2D.Common.Math.b2Vec2(0,0), true)

  _setupDebugMode: ->
    world = @get 'world'
    scaleFactor = @get 'scaleFactor'

    debugDraw = new Box2D.Dynamics.b2DebugDraw()
    debugDraw.SetSprite(document.getElementById("debug-viewport").getContext("2d"))
    debugDraw.SetDrawScale(scaleFactor)
    debugDraw.SetFillAlpha(0.3)
    debugDraw.SetLineThickness(1.0)
    debugDraw.SetFlags(Box2D.Dynamics.b2DebugDraw.e_shapeBit | Box2D.Dynamics.b2DebugDraw.e_jointBit)

    world.SetDebugDraw(debugDraw)
}