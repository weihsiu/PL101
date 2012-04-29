peg = require "pegjs"
assert = require "assert"
fs = require "fs"

grammar = fs.readFileSync "mus.pegjs", "utf-8"
console.log grammar
parse = peg.buildParser(grammar).parse

assertParse = (rule, text, expr) -> assert.deepEqual parse(text, rule), expr

assertParse "note", "a3/200", {tag: "note", pitch: "a3", dur: 200}

assertParse "elemlist", "(a1/100)", {tag: "note", pitch: "a1", dur: 100}

assertParse "elemlist", "(a1/100 b2/200 c3/300)",
  tag: "seq"
  left:
    tag: "note", pitch: "a1", dur: 100
  right:
    tag: "seq"
    left:
      tag: "note", pitch: "b2", dur: 200
    right:
      tag: "note", pitch: "c3", dur: 300

assertParse "harmony", "[(a1/100 b2/200) (b2/200 c3/300)]",
  tag: "par"
  left:
    tag: "seq"
    left:
      tag: "note", pitch: "a1", dur: 100
    right:
      tag: "note", pitch: "b2", dur: 200
  right:
    tag: "seq"
    left:
      tag: "note", pitch: "b2", dur: 200
    right:
      tag: "note", pitch: "c3", dur: 300

assertParse "elemlist", "([(a1/100 b2/200) (b2/200 c3/300)] d4/400)",
  tag: "seq"
  left:
    tag: "par"
    left:
      tag: "seq"
      left:
        tag: "note", pitch: "a1", dur: 100
      right:
        tag: "note", pitch: "b2", dur: 200
    right:
      tag: "seq"
      left:
        tag: "note", pitch: "b2", dur: 200
      right:
        tag: "note", pitch: "c3", dur: 300
  right:
    tag: "note", pitch: "d4", dur: 400

assertParse "elemlist", "({a1/100 a2/200}:2)", 
  tag: "seq"
  left:
    tag: "note", pitch: "a1", dur: 100
  right:
    tag: "seq"
    left:
      tag: "note", pitch: "a2", dur: 200
    right:
      tag: "seq"
      left:
        tag: "note", pitch: "a1", dur: 100
      right:
        tag: "note", pitch: "a2", dur: 200
