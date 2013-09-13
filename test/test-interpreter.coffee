assert      = require('assert')
sinon       = require('sinon')
Interpreter = require('../lib/interpreter')


describe 'The Intepreter', ->
  beforeEach ->
    Interpreter::fly = sinon.spy()
    @interpreter = new Interpreter

  it 'should parse a basic fly instruction', ->  
    console.log @interpreter.fly
    @interpreter.interpret('fly left for 10 seconds')
    assert @interpreter.fly.calledWith('left', 10)