#! /usr/bin/env bash

echo "Compiling lotka_volterra"
nim c --verbosity:0 -f -r -d:release ../examples/lotka_volterra.nim
echo ""
echo "Compiling rma"
nim c --verbosity:0 -f -r -d:release ../examples/rma.nim
echo ""
echo "Compiling chemostat"
nim c --verbosity:0 -f -r -d:release ../examples/chemostat.nim

python3 plot_data.py