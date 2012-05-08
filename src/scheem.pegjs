start
  = whitespace* e:expr whitespace* { return e; }
    
validchar
  = [0-9a-zA-Z_?!+\-=<@#$%^&*/.]

whitespace
  = [ \t\r\n]
  / comment

atom
  = cs:validchar+ {
    var a = cs.join("");
    var n = parseInt(a, 10);
    return isNaN(n) ? a : n;
  }
    
quoteexpr
  = "'" e:expr { return ["quote", e]; }

spaceexpr
  = whitespace+ e:expr { return e; }
    
exprlist
  = "(" whitespace* e:expr? es:spaceexpr* whitespace* ")" { es.unshift(e); return es; }
    
comment
  = ";;" [^\r\n]*

expr
  = atom / quoteexpr / exprlist
    