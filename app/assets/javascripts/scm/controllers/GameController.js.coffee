
#= require scm/controllers/GameLoopController
#= require scm/controllers/CarController

SCM = this.SCM

SCM.controllers.GameController = SCM.controllers.GameLoopController.extend {

  world: null
  car: null
  mediator: null
  scaleFactorBinding: 'mediator.scaleFactor'

  debugMode: false

  init: ->
    @_super()
    mediator = @get 'mediator'
    world = new Box2D.Dynamics.b2World( new Box2D.Common.Math.b2Vec2(0,0), true)

    # use start point from Raphael path for car
    path = mediator.get('track').get('path')

    car = SCM.controllers.CarController.create {
      delegate: this,
      scaleFactor: mediator.get('scaleFactor')
    }

    car.setPath path
    car.createInWorld world

    carData = mediator.get('car')
    carData.set 'width', car.get('width')
    carData.set 'length', car.get('length')

    if @get 'debugMode'
      scaleFactor = mediator.get('scaleFactor')
      @_setupDebugMode(world, scaleFactor)

    @set 'world', world
    @set 'car', car
    @set 'path', path

    @start(@update)

  update: (deltaT, now) ->

    car = @get 'car'
    car.update(deltaT)
    car.accelerate()

    carData = @get('mediator').get('car')

    carData.set 'position', {
      x: car.get('x'),
      y: car.get('y'),
      rotation: car.get('rotation')
    }

    world = @get 'world'
    world.Step(1/60, 10, 10)
    world.ClearForces()
    if @get 'debugMode' then world.DrawDebugData()

  _setupDebugMode: (world, scaleFactor) ->
    debugDraw = new Box2D.Dynamics.b2DebugDraw()
    debugDraw.SetSprite(document.getElementById("debug-viewport").getContext("2d"))
    debugDraw.SetDrawScale(scaleFactor)
    debugDraw.SetFillAlpha(0.3)
    debugDraw.SetLineThickness(1.0)
    debugDraw.SetFlags(Box2D.Dynamics.b2DebugDraw.e_shapeBit | Box2D.Dynamics.b2DebugDraw.e_jointBit)

    world.SetDebugDraw(debugDraw)
}