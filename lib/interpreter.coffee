module.exports = class Interpreter
  commandRegExes   : {}
  directionRegExes : {}
  texts = []

  directions:
    left:
      text: ['left']
    right:
      text: ['right']
    front:
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
      params: ['direction', 'duration']
      text: ['rotate', 'turn']
    flip:
      params: ['direction']
      text: ['flip', 'loop']
  
  constructor: (@drone) ->
    throw new Error("I need a drone!") unless @drone

    for command, obj of @commands
      reg = "(#{obj.text.join('|')})"
      reg += '\\s([\\w]+)'                    if obj.params and 'direction' in obj.params
      reg += '\\sfor\\s([\\w]+)\\ssecond(s?)' if obj.params and 'duration' in obj.params

      @commandRegExes[command] = RegExp reg

    for direction, obj of @directions
      @directionRegExes[direction] = "(#{obj.text.join('|')})"

  interpret: (text) ->    
    @texts = text.split('then')    
    @_popFirstCommand()    
    return texts.length > 0;

  fly: (direction, duration=1, callback) ->
    console.log("flying #{direction} for #{duration}")
    @drone.after(0, ->
      @[direction](0.2)
      @animateLeds('redSnake', 5, 2)
    ).after(duration * 1000, ->
      @stop()
      callback?()
    )
    return true

  rotate: (direction, duration, callback) ->
    @drone.after(0, ->
      switch direction
        when 'left'
          @clockwise(0.5)
        when 'right'
          @counterClockwise(0.5)
    ).after(duration * 1000, ->
      @stop()
      callback?()
    )  
    
    
  flip: (direction, callback) ->
    switch direction
      when 'left'
        @drone.animate('flipLeft', 1500)        
      when 'right'
        @drone.animate('flipRight', 1500)
      when 'front'
        @drone.animate('flipAhead', 1500)
      when 'back'
        @drone.animate('flipBehind', 1500)
      else
        return false
    callback?()
    return true        
    
  stop: (callback) ->
    console.log('Stop')
    @drone.stop(callback)    
   
  takeoff: (callback) ->
    console.log('Taking off')
    @drone.takeoff(callback)
    @drone.animateLeds('redSnake', 5, 2)
    true
    
  land: ->
    console.log('Land')
    @drone.land()
    @drone.animateLeds('redSnake', 5, 2)
    true
    
  
  _popFirstCommand: =>    
    text = @texts[0]
    @texts.shift()
    for command, expression of @commandRegExes
      if matches = expression.exec text
        params = @_matchParams(command, matches)
        if typeof params is 'undefined'
          return false
        else
          return @[command](params..., @_popFirstCommand)

  _matchParams: (command, matches) ->
    return [] if typeof @commands[command].params is 'undefined'
    params = []
    for paramName, index in @commands[command].params
      switch paramName
        when 'direction'
          if direction = @_matchDirection(matches[index+2])
            params.push direction
          else
            return undefined
        when 'duration'
          if duration = params.push @_matchDuration(matches[index+2])
            params.push duration
          else
            return undefined
    return params
    
  _matchDirection: (text) ->
    for direction, expression of @directionRegExes
      return direction if expression.match text
    return false

  _matchDuration: (text) ->
    strings = ['one','two','three','four','five','six','seven','eight','nine','ten']
    int = parseInt(text, 10)
    int = strings.indexOf(text) + 1 if isNaN(int) and text in strings
    return int
  
