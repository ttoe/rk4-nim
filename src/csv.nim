import sequtils, strutils

proc floatsToStrings(seqFloat: seq[float], precision: int = 5): seq[string] =
  return map( seqFloat
            , proc(f: float): string = formatFloat(f, ffDecimal, precision))

proc writeCsv*(outFile: string; sep: string, species: seq[string]; data: seq[seq[float]], precision: int = 5): void =
  let
    header: string = "time" & sep & join(species, sep=sep)
    rowStrings: seq[string] =
      map(data, proc(sf: seq[float]): string =
        join(floatsToStrings(sf, precision=precision), sep=sep))
    outString: string = header & "\n" & join(rowStrings, sep="\n")
  writeFile(outFile, outString)
