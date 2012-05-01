if module?
  peg = require 'pegjs'
  fs = require 'fs'
  parse = peg.buildParser(fs.readFileSync('src/scheem.pegjs', 'utf-8')).parse
else
  parse = Scheem.parse

evalScheem = (expr, env) ->
  if typeof expr is 'number' then expr
  else if typeof expr is 'string'
    if not env.hasOwnProperty(expr) then throw "variable " + expr + " is not bound"
    env[expr]
  else switch expr[0]
    when 'define'
      env[expr[1]] = evalScheem(expr[2], env)
      0
    when 'set!'
      if not env.hasOwnProperty(expr[1]) then throw "variable " + expr[1] + " is not defined"
      env[expr[1]] = evalScheem(expr[2], env)
      0
    when '+' then evalScheem(expr[1], env) + evalScheem(expr[2], env)
    when '-' then evalScheem(expr[1], env) - evalScheem(expr[2], env)
    when '*' then evalScheem(expr[1], env) * evalScheem(expr[2], env)
    when '/' then evalScheem(expr[1], env) / evalScheem(expr[2], env)
    when '='
      if evalScheem(expr[1], env) is evalScheem(expr[2], env) then '#t' else '#f'
    when '<'
      if evalScheem(expr[1], env) < evalScheem(expr[2], env) then '#t' else '#f'
    when 'quote' then expr[1]
    when 'begin' then (evalScheem(e, env) for e in expr[1..])[-1..-1][0]
    when 'cons'
      list = evalScheem(expr[2], env)
      list.unshift(evalScheem(expr[1], env))
      list
    when 'car' then evalScheem(expr[1], env)[0]
    when 'cdr' then evalScheem(expr[1], env)[1..]
    when 'if'
      if evalScheem(expr[1], env) is '#t' then evalScheem(expr[2], env) else evalScheem(expr[3], env)

evalScheemString = (scheem, env) -> evalScheem(parse(scheem), env)

module.exports.evalScheem = evalScheem if module?
module.exports.evalScheemString = evalScheemString if module?