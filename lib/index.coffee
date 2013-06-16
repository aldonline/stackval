class StackVal
  constructor: ->
    @_stack = []
  attach: ( f, generator ) =>
    unless typeof f is 'function'
      throw new Error 'function argument required'
    =>
      try
        @_stack.push generator()
        f.apply null, arguments
      finally
        @_stack.pop()
  get: => @_stack[ @_stack.length - 1 ]

module.exports = ->
  s = new StackVal()
  s.get.attach = s.attach
  s.get.get = s.get
  s.get