
class StackVal
  constructor: ->
    @_stack = []
  ###
  Combinator that returns a function with an attached stack value.
  Whenever you execute this function  the generator function will be executed
  and the resulting value will will be accessible to any downstack function.
  ###
  attach: ( f, generator ) =>
    unless typeof f is 'function'
      throw new Error 'function argument required'
    =>
      try
        @_stack.push generator()
        f.apply null, arguments
      finally
        @_stack.pop()
  ###
  Gets a stackval that was attached to an upstack function
  will throw an error if there is no upstack function with a value
  attached
  ###
  get: =>
    if @defined()
      @_stack[ @_stack.length - 1 ]
    else
      throw new Error 'No stackval found upstack'
   
  ###
  true if there is a value attached upstack
  ###
  defined: => @_stack.length isnt 0

module.exports = ->
  s = new StackVal()
  # Main export is a function
  # that takes either one or two parameters
  # f( ) --> f.get() --> delegates to StackVal::get
  # f( f, generator ) --> f.attach(f, generator) --> delegates to StackVal::attach
  # f.defined() --> StackVal::defined()
  main = -> 
    a = arguments
    if a.length is 2
      s.attach a[0], a[1]
    else
      s.get()
  main.attach  = -> s.attach.apply s, arguments
  main.get     = -> s.get.apply s, arguments
  main.defined = -> s.defined.apply s, arguments
  main