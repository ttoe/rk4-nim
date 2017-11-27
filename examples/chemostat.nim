import strutils

import ../src/rk4
import ../src/csv
import ../src/util

const
  timeRange:   seq[float]  = @[0.0, 5000.0, 0.1]
  initPops:    seq[float]  = @[0.5, 0.5, 0.5, 0.2, 0.0]

  # Bifurcation
  runBifurcation: bool = false

  # Data output
  outFileName  = "chemostat_data.csv"
  headerNames: seq[string] = @["time", "S", "C1", "C2", "P", "T"]
  outPrecision = 5

# Model parameters
var
  d:    float = 0.05
  si:   float = 4.0
  gc:   float = 0.5
  xc:   float = 0.3
  kmax: float = 0.3
  p1:   float = 1.0
  p2:   float = 0.0
  a:    float = 0.29
  gp:   float = 0.5
  kp:   float = 0.5
  xp:   float = 0.3
  gtp:  float = 0.5
  ktp:  float = 0.05
  xtp:  float = 0.3

# Chemostat model
proc chemostat(t: float, pops: seq[float]): seq[float] =
  let
    s  = pops[0]
    c1 = pops[1]
    c2 = pops[2]
    p  = pops[3]
    tp = pops[4]

    kc1: float = kmax - a*p1
    kc2: float = kmax - a*p2

    dS  = d*(si - s) - s*(gc*c1/(kc1 + s) + (gc*c2/(kc2 + s)))
    dC1 = c1*(xc*gc*s/(kc1 + s) - gp*p1*p/(kp + p1*c1 + p2*c2) - d)
    dC2 = c2*(xc*gc*s/(kc2 + s) - gp*p2*p/(kp + p1*c1 + p2*c2) - d)
    dP  = p*(xp*gp*((p1*c1 + p2*c2)/(kp + p1*c1 + p2*c2)) - gtp*tp/(ktp + p) - d)
    dTP = tp*(xtp*gtp*p/(ktp + p) - d)
  return @[dS, dC1, dC2, dP, dTP]

let modelResult = rk4(chemostat, timeRange, initPops)

writeCsv( outFileName
        , sep="\t"
        , header=headerNames
        , data=modelResult
        , precision=outPrecision)

# bifurcation
if runBifurcation:
  const
    bifParStart: float = 0.1
    bifParStep:  float = 0.1
    bifParEnd:   float = 0.3
  
  var
    bifRes = newSeq[seq[float]](0)
    bifVal = bifParStart
  
  # This is hacky. Comparing floats is a problem ...
  # Maybe generate the bifVals als linearly spaced seq
  while bifVal <= (bifParEnd + 0.5*bifParStep):
    si = bifVal
    echo("Running with: " & formatFloat(bifVal, ffDecimal, 3))
  
    let modelResult = rk4(chemostat, timeRange, initPops)
    # taking the last value of time series and then removing first value (time)
    var retArr      = (modelResult[^1])[1..^1]
    retArr.insert(bifVal, 0)
    bifRes.add(retArr)
  
    bifVal += bifParStep
