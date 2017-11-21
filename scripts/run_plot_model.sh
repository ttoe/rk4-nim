#! /usr/bin/env bash

echo "*** Compiling lotka_volterra"
nim c --verbosity:0 -f -d:release ../examples/lotka_volterra.nim
echo "*** Running chemostat"
../examples/lotka_volterra

echo "*** Compiling rma"
nim c --verbosity:0 -f -d:release ../examples/rma.nim
echo "*** Running chemostat"
../examples/rma

echo "*** Compiling chemostat"
nim c --verbosity:0 -f -d:release ../examples/chemostat.nim
echo "*** Running chemostat"
../examples/chemostat

echo "*** Plotting data"
python3 plot_data.py
echo "*** Done"
