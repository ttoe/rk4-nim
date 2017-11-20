import sequtils

proc rk4*( model: proc(time: float; populationSizes: seq[float]): seq[float]
         ; timeSpan: seq[float] # a vector containing 3 values: [timeStart, timeEnd, timeStep] 
         ; initialPopulations: seq[float]
         ) : seq[seq[float]] =

  let
    # resSeqSize: int   = len(initialPopulations) + 1 # plus 1 for time value
    timeEnd:    float = timeSpan[1] # end of simulation
    dt:         float = timeSpan[2] # time step size

  var
    t         = timeSpan[0] # beginning of simulation
    # the end result is a seq of seq[float]
    # the seq[float] contains the time and the populations sizes
    endResult = newSeq[seq[float]](0)
    pops      = initialPopulations

  endResult.add(concat(@[t], initialPopulations)) # add initial time and populations
  t += dt # next time step == current time + step size

  while t <= timeEnd:

    var currentTimeStepResult = newSeq[float](0)
    currentTimeStepResult.add(t) # add time to current time step result sequence

    for i in 0..high(initialPopulations):
      var pops_k2, pops_k3, pops_k4 = pops

      let k1 = dt * (model(t          , pops))[i]

      pops_k2[i] += k1/2.0
      let k2 = dt * (model(t + (dt/2) , pops_k2))[i]

      pops_k3[i] += k2/2.0
      let k3 = dt * (model(t + (dt/2) , pops_k3))[i]

      pops_k4[i] += k3
      let k4 = dt * (model(t + dt     , pops_k4))[i]

      let newY: float = pops[i] + ((k1 + (2*k2) + (2*k3) + k4)/6.0)
      currentTimeStepResult.add(newY) # add population size to current time step result sequence

    pops = currentTimeStepResult[1..high(currentTimeStepResult)]
    endResult.add(currentTimeStepResult)
    t += dt

  return endResult
