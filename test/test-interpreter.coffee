assert      = require('assert')
sinon       = require('sinon')
Interpreter = require('../lib/interpreter')

describe 'The Intepreter', ->
  beforeEach ->
    sinon.stub(Interpreter::, 'fly')
    @interpreter = new Interpreter('drone')

  it 'should parse a basic fly instruction', ->
    @interpreter.interpret('fly left for 10 seconds')
    sinon.assert.calledWith(@interpreter.fly, 'left', 10)
