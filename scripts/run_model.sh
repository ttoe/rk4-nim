#! /usr/bin/env bash

### echo "*** Compiling lotka_volterra"
### nim c --verbosity:0 -f -d:release ../examples/lotka_volterra.nim
### echo "*** Running chemostat"
### ../examples/lotka_volterra
### 
### echo "*** Compiling rma"
### nim c --verbosity:0 -f -d:release ../examples/rma.nim
### echo "*** Running chemostat"
### ../examples/rma

echo "*** Compiling chemostat"
### -flto = link time optimization; supposed to inline more
### -O3 = maximum optimizations
### echo "flto"
### nim c -r --passC:"-flto" --verbosity:0 --hints:off -f -d:release ../examples/chemostat.nim
### echo "O3"
### nim c -r --passC:"-O3" --verbosity:0 --hints:off -f -d:release ../examples/chemostat.nim
### echo "flto O3"
### nim c -r --passC:"-flto -O3" --verbosity:0 --hints:off -f -d:release ../examples/chemostat.nim
### echo "nothing"
### nim c -r --verbosity:0 --hints:off -f -d:release ../examples/chemostat.nim
nim --passc:"-fopenmp" --passl:"-fopenmp" --cc:gcc -d:release --hints:off c ../examples/chemostat.nim
# nim --passc:"-fopenmp" --passl:"-fopenmp" --cc:gcc --gcc.exe="/usr/local/Cellar/gcc/7.2.0/bin/gcc-7" --gcc.linkerexe="/usr/local/Cellar/gcc/7.2.0/bin/gcc-7" -d:release --hints:off c ../examples/chemostat.nim
echo "*** Running chemostat"
../examples/chemostat