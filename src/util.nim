import sequtils, future

proc maximaIxs*(fs: seq[float]): seq[int] =
  var maxIxs = newSeq[int](0)
  for i in 1..(fs.high-1):
    if (fs[i] > fs[i-1] and fs[i] > fs[i+1]) or fs[i-1] == fs[i] and fs[i] == fs[i+1]:
      maxIxs.add(i)
  return maxIxs

proc minimaIxs*(fs: seq[float]): seq[int] =
  return maximaIxs(fs.map(x => x * (-1)))

proc maximaVals*(fs: seq[float]): seq[float] =
  return maximaIxs(fs).map(i => fs[i])

proc minimaVals*(fs: seq[float]): seq[float] =
  return minimaIxs(fs).map(i => fs[i])

# proc removeConsecutiveMaxIxsAndKeepMiddleOne
