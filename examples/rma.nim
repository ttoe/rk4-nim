import strutils

import ../src/rk4
import ../src/csv

const
  speciesNames: seq[string] = @["X", "Y"]
  timeRange:    seq[float]  = @[0.0, 200.0, 0.01]
  initPops:     seq[float]  = @[0.5, 0.5]

  # Data output
  outFileName:  string = "rma_data.csv"
  outprecision: int    = 5

  # Model parameters
  k: float = 4.0
  m: float = 0.5
  c: float = 0.2

# Rosezweig-MacArtur model
proc rma(t: float; pops: seq[float]): seq[float] =
  let
    X = pops[0]
    Y = pops[1]
    dX = X*(1 - X/k) - m*X*Y/(1+X)
    dY = -c*Y + m*X*Y/(1+X) 
  return @[dX, dY]

let modelResult = rk4(rma, timeRange, initPops)

writeCsv( outFileName
        , sep="\t"
        , species=speciesNames
        , data=modelResult
        , precision = outPrecision)