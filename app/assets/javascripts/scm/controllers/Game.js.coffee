
this.SCM = this.SCM ? {}

class SCM.Game

  started: false
  stopped: false

  requestAnimationFrame: window.mozRequestAnimationFrame ||
                         window.webkitRequestAnimationFrame ||
                         window.msRequestAnimationFrame ||
                         window.oRequestAnimationFrame

  start: (renderCallback) ->
    unless started
      @renderCallback = renderCallback ? @renderCallback
      @_run()
      @started = true
      @stopped = false

  _run: (now) ->
    @lastFrame ?= new Date

    unless @stopped
      raf = @requestAnimationFrame ? setTimeout(@_run, 16)

      # Make sure to use a valid time, since:
      # - Chrome 10 doesn't return it at all
      # - setTimeout returns the actual timeout
      now = now && now > 1E4 ? now : new Date;
      deltaT = now - lastFrame;

      # do not render frame when deltaT is too high
      if deltaT < 160
        @renderCallback(deltaT, now);

      lastFrame = now;

