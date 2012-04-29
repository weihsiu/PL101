// (a4/200 f3/500 [(b3/300) (f3/100 f6/200)] (e3/200 b2/300):3)

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
  = note / harmony / elemlist

spaceelem
  = whitespace+ e:elem { return e; }

repeat
  = ":" r:number { return r; }

elemlist
  = "(" e:elem es:spaceelem* ")" r:repeat? {
    var ess = [], i;
    if (r === "") r = 1
    es.unshift(e);
    for (i = 0; i < r; i++) ess = ess.concat(es);
    return buildTree("seq", ess);
  }

spaceelemlist
  = whitespace+ el:elemlist { return el; }

harmony
  = "[" el:elemlist els:spaceelemlist+ "]" {
    els.unshift(el);
    return buildTree("par", els);
  }