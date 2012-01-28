
SCM = this.SCM

SCM.controllers.GameLoopController = SC.Object.extend {

  started: false,
  stopped: false,

  requestAnimationFrame: window.mozRequestAnimationFrame ||
                         window.webkitRequestAnimationFrame ||
                         window.msRequestAnimationFrame ||
                         window.oRequestAnimationFrame,

  init: ->
    @set '_proxyRun', $.proxy(@_run, this)
    @_super()

  start: (renderCallback) ->
    unless @get 'started'
      if renderCallback
        @set 'renderCallback', $.proxy(renderCallback, this)

      @_run()
      @set 'started', true
      @set 'stopped', false

  _run: (now) ->
    lastFrame = @get 'lastFrame'

    unless lastFrame
      lastFrame = new Date
      @set 'lastFrame', lastFrame

    unless @stopped
      raf = @get('requestAnimationFrame')

      if raf
        raf = raf @get('_proxyRun')
      else
        raf = setTimeout @get('_proxyRun'), 16

      # Make sure to use a valid time, since:
      # - Chrome 10 doesn't return it at all
      # - setTimeout returns the actual timeout
      now = new Date

      deltaT = now - lastFrame;

      # do not render frame when deltaT is too high
      if deltaT < 160
        @get('renderCallback')(deltaT, now)

      @set 'lastFrame', now

}