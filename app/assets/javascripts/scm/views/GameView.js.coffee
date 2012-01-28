
SCM = this.SCM

SCM.views.GameView = SC.View.extend {
  templateName: 'scm_templates_game'
  elementId: 'game'

  # width and height are dictated by viewport size
  width: 0
  height: 0

  statechart: null
  mediator: null
  trackDataBinding: 'mediator.track'
  carDataBinding: 'mediator.car'
  scaleFactorBinding: 'mediator.scaleFactor'

  track: null
  car: null

  didInsertElement: ->
    viewportElement = @$('#game-viewport')

    # size of game is dictated by viewport element
    @set 'width', viewportElement.outerWidth()
    @set 'height', viewportElement.outerHeight()

    # Raphael is used for drawing the game
    paper = Raphael viewportElement[0], @get('width'), @get('height')
    @set 'paper', paper

    @get('statechart').send('gameInitialized')

  trackDataPathChanged: SC.observer (->
    trackData = @get('trackData')
    previousTrack = @get('track')

    # remove previous track path from paper
    if previousTrack
      previousTrack.remove()

    # draw updated track path
    if trackData
      @set 'track', @_createTrackFromPath trackData.get('path')

    # there is no track anymore
    else
      @set 'track', null

  ), 'trackData.path'

  carPositionChanged: SC.observer (->
    carData = @get 'carData'
    car = @get 'car'

    if carData
      unless car
        car = @_createCar(carData)

      @_updateCarPosition(carData)

    else
      if car then car.remove()
      @set 'car', null

  ), 'carData.position'

  _createTrackFromPath: (pathData) ->
    track = @get('paper').path(pathData)
    track.attr {
      stroke: '#000',
      'stroke-width': 40
    }

  _createCar: (carData) ->
    scaleFactor = @get 'scaleFactor'
    width = carData.get('width') * 2 * scaleFactor
    length = carData.get('length') * 2 * scaleFactor

    car = @get('paper').rect(0, 0, width, length);
    car.attr {
      fill: '#ff0000'
    }

    @set 'width', width
    @set 'length', length
    @set 'car', car

    return car

  _updateCarPosition: (carData) ->
    car = @get 'car'
    scaleFactor = @get 'scaleFactor'

    position = carData.get 'position'
    width = @get 'width'
    length = @get 'length'

    # positions in box2d are centered in bodies
    x = (position.x * scaleFactor) - width / 2
    y = (position.y * scaleFactor) - length / 2

    # angles in box2d are given in radians
    rotation = Raphael.deg(position.rotation)

    car.transform "t#{x},#{y},r#{rotation}"
}