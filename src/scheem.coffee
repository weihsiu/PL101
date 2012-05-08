if module?
  peg = require 'pegjs'
  fs = require 'fs'
  parse = peg.buildParser(fs.readFileSync('src/scheem.pegjs', 'utf-8')).parse
else
  parse = Scheem.parse

rootEnv =
  bindings:
    '+': (x, y) -> x + y
    '-': (x, y) -> x - y
    '*': (x, y) -> x * y
    '/': (x, y) -> x / y
    '=': (x, y) -> if x is y then '#t' else '#f'
    '<': (x, y) -> if x < y then '#t' else '#f'
    '>': (x, y) -> if x > y then '#t' else '#f'
    '<=': (x, y) -> if x <= y then '#t' else '#f'
    '>=': (x, y) -> if x >= y then '#t' else '#f'
    'not': (x) -> if x is '#t' then '#f' else '#t'
    'cons': (x, y) -> y.unshift(x); y
    'car': (x) -> x[0]
    'cdr': (x) -> x[1..]
    'alert': (x) -> if module? then console.log(x) else alert(x)
  outer: null

newEnv = (bindings = {}, outer = rootEnv) ->
  bindings: bindings
  outer: outer

lookup = (env, name) ->
  if not env?
    throw "variable #{name} is not bound"
  else if env.bindings.hasOwnProperty(name)
    env.bindings[name]
  else
    lookup(env.outer, name)

update = (env, name, value) ->
  if not env?
    throw "variable #{name} is not bound"
  else if env.bindings.hasOwnProperty(name)
    env.bindings[name] = value
  else
    update(env.outer, name, value)

evalScheem = (expr, env) ->
  if typeof expr is 'number' then expr
  else if typeof expr is 'string' then lookup(env, expr)
  else switch expr[0]
    when 'define'
      env.bindings[expr[1]] = evalScheem(expr[2], env)
      0
    when 'set!'
      update(env, expr[1], evalScheem(expr[2], env))
      0
    when 'quote' then expr[1]
    when 'begin' then (evalScheem(e, env) for e in expr[1..])[-1..-1][0]
    when 'if'
      if evalScheem(expr[1], env) is '#t' then evalScheem(expr[2], env) else evalScheem(expr[3], env)
    when 'let-one'
      bindings = {}
      bindings[expr[1]] = evalScheem(expr[2], env)
      evalScheem(expr[3], newEnv(bindings, env))
    when 'lambda-one'
      (x) ->
        bindings = {}
        bindings[expr[1]] = x
        evalScheem(expr[2], newEnv(bindings, env))
    when 'lambda'
      if typeof expr[1] isnt 'object' then throw 'first argument to lambda has to be a parameter list'
      (args...) ->
        params = expr[1]
        bindings = {}
        bindings[params[i]] = args[i] for i in [0...params.length]
        evalScheem(expr[2], newEnv(bindings, env))
    else
      args = (evalScheem(arg, env) for arg in expr[1..])
      evalScheem(expr[0], env).apply(null, args)

evalScheemString = (scheem, env) -> evalScheem(parse(scheem), env)

module.exports.newEnv = newEnv if module?
module.exports.evalScheem = evalScheem if module?
module.exports.evalScheemString = evalScheemString if module?