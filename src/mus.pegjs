// (a4/200 f3/500 [(b3/300) (f3/100 f6/200)] {e3/200 b2/300}:3)

{
  function buildTree(tag, ns) {
    return ns.length === 1 ? ns[0] : {tag: tag, left: buildTree(tag, [ns[0]]), right: buildTree(tag, ns.slice(1))};
  }
}

start
  = elemlist

whitespace
  = [ \t\r\n]

number
  = a:[1-9] b:[0-9]* { return parseInt(a + b.join(""), 10); }

pitch
  = a:[a-g] b:[0-8] { return a + b; }

duration
  = number

note
  = p:pitch "/" d:duration { return {tag: "note", pitch: p, dur: d}; }

elem
  = note / harmony / repeat

spaceelem
  = whitespace+ e:elem { return e; }

elemlist
  = "(" e:elem es:spaceelem* ")" {
    es.unshift(e);
    return buildTree("seq", es);
  }

spaceelemlist
  = whitespace+ el:elemlist { return el; }

harmony
  = "[" el:elemlist els:spaceelemlist+ "]" {
    els.unshift(el);
    return buildTree("par", els);
  }

repeat
  = "{" e:elem es:spaceelem* "}:" t:number {
    var ess = [], i;
    es.unshift(e);
    for (i = 0; i < t; i++) ess = ess.concat(es);
    return buildTree("seq", ess);
  }