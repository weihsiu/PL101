expr =
  tag: 'par'
  left:
    tag: 'note', pitch: 'c4', dur: 250
  right:
    tag: 'par',
    left:
      tag: 'note', pitch: 'e4', dur: 250
    right:
      tag: 'seq'
      left:
        tag: 'note', pitch: 'c4', dur: 500
      right:
        tag: 'note', pitch: 'e4', dur: 500

depthFirst = (expr, time, func) ->
  switch expr.tag
    when "note" then func(expr, time)
    when "seq"
      [ns1, t1] = depthFirst(expr.left, time, func)
      [ns2, t2] = depthFirst(expr.right, t1, func)
      [ns1.concat(ns2), t2]
    when "par"
      [ns1, t1] = depthFirst(expr.left, time, func)
      [ns2, t2] = depthFirst(expr.right, time, func)
      [ns1.concat(ns2), Math.max(t1, t2)]

compile = (expr) ->
  [ns, _] = depthFirst(expr, 0, (n, t) -> [[tag: "note", pitch: n.pitch, start: t, dur: n.dur], t + n.dur])
  ns

console.log(compile(expr))