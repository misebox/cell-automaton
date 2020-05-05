import sequtils

import nimbox

type
  Line = seq[bool]
  Mtx = seq[Line]

proc judge(line: Line, i: int): bool =
  var a: int = 0
  a = a or (if i > 0 and line[i-1]: 0b100 else: 0)
  a = a or (if line[i]: 0b010 else: 0)
  a = a or (if i < line.len - 1 and line[i+1]: 0b001 else: 0)
  case a:
  of 0b100: true
  of 0b011: true
  of 0b010: true
  of 0b001: true
  else: false

proc automaton(line: Line, n: int): Mtx =
  var mtx: Mtx = @[line]
  for r in 0 ..< n:
    let prev = mtx[r]
    var row: Line = @[]
    for c in 0 ..< prev.len:
      row.add(judge(prev, c))
    mtx.add(row)
  mtx

proc main() =
  let nb = newNimbox()
  defer: nb.shutdown

  let half = nb.width div 2
  let line = toSeq(0..<nb.width).mapIt(it == half)
  let mtx = automaton(line, nb.height - 2)

  nb.print(0, 0, $nb.width & "x" & $nb.height)
  for r in 0 ..< mtx.len:
    for c in 0 ..< mtx[r].len: 
      let s = if mtx[r][c]: "#" else: " "
      nb.print(c, r, s)


  nb.present()

  while true:
    let evt = nb.peekEvent(100)
    case evt.kind:
    of EventType.Key:
      break
    else:
      continue


when isMainModule:
  main()