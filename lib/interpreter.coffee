module.exports = class Interpreter
  commandRegExes   : {}
  directionRegExes : {}

  directions:
    left:
      text: ['left']
    right:
      text: ['right']
    forward:
      text: ['forward','forwards']
    back:
      text: ['back','backwards']
    up:
      text: ['up']
    down:
      text: ['down']

  commands:
    fly:
      params: ['direction', 'duration']
      text: ['fly']
    takeoff:
      text: ['takeoff', 'take\\ off', 'start']
    land:
      text: ['land']
    reset:
      text: ['reset']
    rotate: 
      text: ['rotate', 'turn']
  
  constructor: (@drone) ->
    throw new Error("I need a drone!") unless @drone

    for command, obj of @commands
      reg = "(#{obj.text.join('|')})"
      reg += '\\s([\\w]+)'                 if obj.params and 'direction' in obj.params
      reg += '\\sfor\\s([0-9]+)\\sseconds' if obj.params and 'duration' in obj.params

      @commandRegExes[command] = RegExp reg

    for direction, obj of @directions
      @directionRegExes[direction] = "(#{obj.text.join('|')})"

  interpret: (text) ->
    for command, expression of @commandRegExes
      if matches = expression.exec text
        params = @_matchParams(command, matches)
        return @[command](params...)
    return false

  fly: (direction, duration=1) ->
    return unless direction in ['left', 'right', 'forward', 'back']
    @drone[direction](0.2)
      .after duration * 1000, ->
        @stop()
    return true

  rotate: (direction, duration) ->
    
  flip: (direction) ->
    switch direction
      when 'left'
        @drone.animate('flipLeft')        
      when 'right'
        @drone.animate('flipRight')
      when 'flipAhead'
        @drone.animate('flipAhead')
      when 'flipBehind'
        @drone.animate('flipBehind')
      else
        return false
  return true        
    
  stop: ->
    @drone.stop()
    true
    
  takeoff: ->
    @drone.takeoff()
    true
    
  land: ->
    @drone.land()
    true
    
  _matchParams: (command, matches) ->
    return null if typeof @commands[command].params is 'undefined'
    params = for paramName, index in @commands[command].params
      switch paramName
        when 'direction'
          @_matchDirection(matches[index+2])
        when 'duration'
          parseInt matches[index+2], 10
    return params
    
  _matchDirection: (text) ->
    for direction, expression of @directionRegExes
      return direction if expression.match text
    return false

