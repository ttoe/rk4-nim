import sequtils, strutils, future

proc floatsToStrings(seqFloat: seq[float], precision: int = 5): seq[string] =
  return seqFloat.map(f => formatFloat(f, ffDecimal, precision))

proc writeCsv*( outFile: string
              , sep: string
              , header: seq[string]
              , data: seq[seq[float]]
              , comment: string = ""
              , precision: int = 5
              ) : void =
  let
    rowStrings: seq[string] = data.map(sf =>  join(floatsToStrings(sf, precision=precision), sep=sep))
    outString:  string      = comment & join(header, sep=sep) & "\n" & join(rowStrings, sep="\n")
  writeFile(outFile, outString)
