import strutils

import ../src/rk4

# Initial Conditions & Parameters
const
  # Time parameters
  timeRange: seq[float] = @[0.0, 100.0, 0.001]
  initPops:  seq[float] = @[0.5, 0.5] # Inital populations sizes

  # Data output
  output_file  = true
  outFileName  = "chemostat_data.csv"
  outPrecision = 4

  # Model parameters
  a: float = 0.5
  b: float = 0.5
  g: float = 0.5
  d: float = 0.5
  
proc lotkaVolterra(t: float; pops: seq[float]): seq[float] =
  let
    X = pops[0]
    Y = pops[1]
    dX: float = a*X - b*X*Y
    dY: float = d*X*Y - g*Y
  return @[dX, dY]

# run model
let model_result = rk4(lotkaVolterra, timeRange, initPops)

# String to accumulate the result
# initialize outString as the column names separated with tabs
var outString: string = "time\tX\tY\n"
if output_file:
  for row in model_result:
    for col in row:
      out_string.add($formatFloat(col, ffDecimal, outPrecision) & "\t")
    out_string.add("\n")
  writeFile(outFileName, outString)
  echo("Wrote file " & outFileName)
