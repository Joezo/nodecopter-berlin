assert      = require('assert')
sinon       = require('sinon')
Interpreter = require('../lib/interpreter')


describe 'The Intepreter', -> 
  Interpreter::fly = sinon.spy()
  this.interpreter = new Interpreter

  it 'should parse a basic fly instruction', ->  
  this.interpreter.interpretate('fly left for 10 seconds')
  assert(this.interpreter.fly.calledWith('left', 10))