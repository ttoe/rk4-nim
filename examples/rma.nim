import strutils

import ../src/rk4

# Initial Conditions & Parameters
const
  # Time parameters
  time_range: seq[float] = @[0.0, 200.0, 0.01]
  init_pops: seq[float]  = @[0.1, 0.1] # Inital populations sizes

  # Data output
  output_file     = true
  outFileName     = "rma_data.csv"
  prec = 4

  # Model parameters
  # r:   float = 0.2
  k: float = 8.0
  m: float = 0.5
  c: float = 0.2

# RMA Model
proc rma(t: float; pops: seq[float]): seq[float] =
  let
    X = pops[0]
    Y = pops[1]

    dX = X*(1 - X/k) - m*X*Y/(1+X)
    dY = -c*Y + m*X*Y/(1+X) 
  return @[dX, dY]

# running the model
let model_result = rk4(rma, time_range, init_pops)

# String to accumulate the result
# initialize out_string as the column names separated with tabs
var out_string: string = "time\tX\tY\n"
if output_file:
  for row in model_result:
    for col in row:
      out_string.add($formatFloat(col, ffDecimal, prec) & "\t")
    out_string.add("\n")
  writeFile(outFileName, out_string)
  echo("Wrote file " & outFileName)
