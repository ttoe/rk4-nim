{.experimental.}
import strutils, sequtils, future, math, times, threadpool

import ../src/rk4
import ../src/csv
import ../src/util

const
  # Bifurcation
  runBifurcation: bool = true

  # Solution time steps
  tStart:    float = 0.0
  tEnd:      float = 15000.0
  tStep:     float = 0.1
  tLastOut:  float = 5000.0

  timeRange: seq[float] = @[tStart, tEnd, tStep]

  # Data output
  outFileName:  string = "chemostat_data.csv"
  outPrecision: int    = 5
  outTimeFrame: int    = toInt(floor(tLastOut/tStep))
  headerNames: seq[string] = @["time", "S", "C1", "C2", "P", "T"]


  # Initial conditions
  initPops:    seq[float]  = @[0.5, 0.5, 0.5, 0.2, 0.0]

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

# generate some comments about the simulation parameters for the csv.
# the way the bifurcation parameter is determined is suboptimal.
# i'd rather like to specify it once and create a parameter set over which
# the solving can be mapped.
# this way also multiple parameters can be varied against each other 
# and the list of parameter sets can be mapped over in parallel, ideally.
# if the parameters were a hash map this would also not be necessary.

var comment: string = 
  "# bifurcation parameter: " & "si\n" &
  "# d: "    & $d    & "\n" &
  "# si: "   & $si   & "\n" &
  "# gc: "   & $gc   & "\n" &
  "# xc: "   & $xc   & "\n" & 
  "# kmax: " & $kmax & "\n" &
  "# p1: "   & $p1   & "\n" &
  "# p2: "   & $p2   & "\n" &
  "# a: "    & $a    & "\n" &
  "# gp: "   & $gp   & "\n" &
  "# kp: "   & $kp   & "\n" &
  "# xp: "   & $xp   & "\n" &
  "# gtp: "  & $gtp  & "\n" &
  "# ktp: "  & $ktp  & "\n" &
  "# xtp: "  & $xtp  & "\n" 

# Output

writeCsv( outFileName
        , sep="\t"
        , header=headerNames
        , data=modelResult[^outTimeFrame..^1]
        , comment=comment
        , precision=outPrecision)

proc pipe( model: (float, seq[float]) -> seq[float]
         , timeSpan: seq[float] # contains: [timeStart, timeEnd, timeStep] 
         , initialPopulations: seq[float]
         , bifVal: float
         ): seq[seq[float]] =

  echo bifVal
  si = bifVal

  let
    modelResult:    seq[seq[float]] = rk4(chemostat, timeRange, initPops)
    transposed:     seq[seq[float]] = transpose(modelResult[^outTimeFrame..^1])[1..^1]
    bifValMinsMaxs: seq[seq[float]] = transposed.map(minMaxOrLastVals)
    equalized:      seq[seq[float]] = equalizeSeqLengths(bifValMinsMaxs)
    eqWithBifVal:   seq[seq[float]] = transpose(equalized).map(x => concat(@[bifVal], x))
  return eqWithBifVal

# Bifurcation
if runBifurcation:

  const
    bifParStart: float = 2.5
    bifParEnd:   float = 8.0
    bifParStep:  float = 0.1
    numSims:     int   = toInt((bifParEnd-bifParStart)/bifParStep)+1

  echo numSims    

  # start timer
  let startTime = cpuTime()

  var resSeq = newSeq[seq[seq[float]]](numSims)
  parallel:
    for i in 0..(numSims-1): # -1 because starting from 0
      let bifVal = bifParStart+(toFloat(i)*bifParStep)

      resSeq[i] = spawn pipe(chemostat, timeRange, initPops, bifVal)
  
  var data = newSeq[seq[float]](0)
  for res in resSeq:
    for j in res:
      data.add(j)

  let timeTaken = cpuTime()-startTime
  echo "Time for bifurcation: ", timeTaken
  echo "Time per iteration: ", timeTaken/((bifParEnd-bifParStart)/bifParStep)

###       let
###         modelResult:    seq[seq[float]] = rk4(chemostat, timeRange, initPops)
###         transposed:     seq[seq[float]] = transpose(modelResult[^outTimeFrame..^1])[1..^1]
###         bifValMinsMaxs: seq[seq[float]] = transposed.map(minMaxOrLastVals)
###         equalized:      seq[seq[float]] = equalizeSeqLengths(bifValMinsMaxs)
###         eqWithBifVal:   seq[seq[float]] = transpose(equalized).map(x => concat(@[bifVal], x))
   # for i in eqWithBifVal:
      # resSeq.add(i)

  # writeCsv( outFile="bif_chemostat.csv"
  #         , sep="\t"
  #         , header=headerNames
  #         , data=resSeq
  #         , comment=comment
  #         , precision=outPrecision)

###   var
###     bifVal: float = bifParStart
###     allMinsMaxs   = newSeq[seq[float]](0)
###   
###   # This is hacky. Comparing floats is a problem ...
###   # Maybe generate the bifVals als linearly spaced seq
###   while bifVal <= (bifParEnd + 0.5*bifParStep):
###     # SET CSV COMMENT!
###     si = bifVal # determines bifurcation parameter. 
###     echo bifVal
### 
###     let
###       modelResult:    seq[seq[float]] = rk4(chemostat, timeRange, initPops)
###       transposed:     seq[seq[float]] = transpose(modelResult[^outTimeFrame..^1])[1..^1]
###       bifValMinsMaxs: seq[seq[float]] = transposed.map(minMaxOrLastVals)
###       equalized:      seq[seq[float]] = equalizeSeqLengths(bifValMinsMaxs)
###       eqWithBifVal:   seq[seq[float]] = transpose(equalized).map(x => concat(@[bifVal], x))
### 
###     for i in eqWithBifVal:
###       allMinsMaxs.add(i)
### 
###     bifVal += bifParStep