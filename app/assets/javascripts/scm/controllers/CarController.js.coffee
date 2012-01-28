
SCM = this.SCM
Point2D = Box2D.Common.Math.b2Vec2

SCM.controllers.CarController = SC.Object.extend {

  x: 0
  y: 0
  rotation: 0

  speed: 0
  acceleration: 0.002
  brake: 0.004
  maxSpeed: 0.3

  width: 0.75
  length: 1.50

  density: 1
  friction: 1
  restitution: 0.3

  mainJointForce: 300
  mainJointDamping: 0
  mainJointOffset: 0.8

  backJointForce: 200
  backJointDamping: 5
  backJointOffset: 0

  bodyDef: null
  fixtureDef: null
  body: null

  world: null
  path: null
  scaleFactor: null

  init: ->
    @_setToStartPosition()
    @_setupBodyDefinitions()
    @_materialize()

  setSpeed: (value) ->
    if value <= @get('maxSpeed') && value >= 0
      @set 'speed', value

  accelerate: ->
    @setSpeed @get('speed') + @get('acceleration')

  deAccelerate: ->
    @setSpeed @get('speed') - @get('brake')

  update: (deltaT) ->
    @drive @get('speed') * deltaT

    body = @get 'body'
    center = body.GetWorldCenter()

    @set 'x', center.x
    @set 'y', center.y
    @set 'rotation', body.GetAngle()

  drive: (distance) ->
    scaleFactor = @get 'scaleFactor'
    path = @get 'path'
    positionOnPath = @get 'positionOnPath'
    positionOnPath += distance

    if positionOnPath >= Raphael.getTotalLength(path)
      positionOnPath = 0

    mainPoint = Raphael.getPointAtLength(path, positionOnPath)
    backPoint = Raphael.getPointAtLength(path, positionOnPath - @get('mainJointOffset') * scaleFactor)

    mainPoint = new Point2D(mainPoint.x / scaleFactor, mainPoint.y / scaleFactor)
    backPoint = new Point2D(backPoint.x / scaleFactor, backPoint.y / scaleFactor)

    @get('mainJoint').SetTarget(mainPoint)
    @get('backJoint').SetTarget(backPoint)

    @set 'positionOnPath', positionOnPath

  _setToStartPosition: ->
    # set car to start point of path
    @set 'positionOnPath', 0
    startPoint = Raphael.getPointAtLength @get('path'), 0

    scaleFactor = @get 'scaleFactor'
    # Raphael calcs with pixels
    @set 'x', startPoint.x / scaleFactor
    @set 'y', startPoint.y / scaleFactor

  _materialize: ->
    world = @get 'world'
    body = world.CreateBody @get('bodyDef')
    body.CreateFixture @get('fixtureDef')

    @set 'body', body

    mainJoint = @_createMouseJoint {
      offset: @get('mainJointOffset')
      damping: @get('mainJointDamping')
      force: @get('mainJointForce')
    }

    @set 'mainJoint', mainJoint

    backJoint = @_createMouseJoint {
      offset: @get('backJointOffset')
      damping: @get('backJointDamping')
      force: @get('backJointForce')
    }

    @set 'backJoint', backJoint

  _setupBodyDefinitions: ->
    bodyDef = new Box2D.Dynamics.b2BodyDef()
    bodyDef.type = Box2D.Dynamics.b2Body.b2_dynamicBody
    bodyDef.position.x = @get 'x'
    bodyDef.position.y = @get 'y'

    @set 'bodyDef', bodyDef

    fixtureDef = new Box2D.Dynamics.b2FixtureDef()
    fixtureDef.density = @get 'density'
    fixtureDef.friction = @get 'friction'
    fixtureDef.restitution = @get 'restitution'
    fixtureDef.shape = new Box2D.Collision.Shapes.b2PolygonShape()
    fixtureDef.shape.SetAsBox @get('width'), @get('length')

    @set 'fixtureDef', fixtureDef

  _createMouseJoint: (config) ->
    body = @get 'body'
    world = @get 'world'

    md = new Box2D.Dynamics.Joints.b2MouseJointDef()
    md.bodyA = world.GetGroundBody()
    md.bodyB = body

    md.target.Set( body.GetWorldCenter().x, body.GetWorldCenter().y + config.offset)

    md.collideConnected = true
    md.dampingRatio = config.damping
    md.maxForce = config.force * body.GetMass()

    return world.CreateJoint(md)
}