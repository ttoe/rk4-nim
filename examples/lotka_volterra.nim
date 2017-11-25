import strutils

import ../src/rk4
import ../src/csv

const
  speciesNames: seq[string] = @["X", "Y"]  
  timeRange:    seq[float]  = @[0.0, 100.0, 0.001]
  initPops:     seq[float]  = @[0.5, 0.5]

  # Data output
  outFileName  = "lv_data.csv"
  outPrecision = 5

  # Model parameters
  a: float = 0.5
  b: float = 0.4
  g: float = 0.3
  d: float = 0.2
  
# Lotka-Volterra model
proc lotkaVolterra(t: float, pops: seq[float]): seq[float] =
  let
    X  = pops[0]
    Y  = pops[1]
    dX = a*X - b*X*Y
    dY = d*X*Y - g*Y
  return @[dX, dY]

let modelResult = rk4(lotkaVolterra, timeRange, initPops)

writeCsv( outFileName
        , sep="\t"
        , species=speciesNames
        , data=modelResult
        , precision = outPrecision)
