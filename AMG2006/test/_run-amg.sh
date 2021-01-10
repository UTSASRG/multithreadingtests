#!/bin/bash

export HPCRUN=/home/johnmc/pkgs-src/hpctoolkit-parallel/hpctoolkit-install/bin/hpcrun
export OMP_NUM_THREADS=8
export OMP_WAIT_POLICY=active
export KMP_BLOCKTIME=infinite
#mpirun  -n 4 hpcrun  -o hpctoolkit-all-measurements -e cycles -t ./amg2006 -P 2 2 1 -n 2 2 4  -r 10 10 10
mpirun  -n 4 ${HPCRUN} -o hpctoolkit-all-measurements -e REALTIME -t ./amg2006 -P 2 2 1 -n 2 2 4  -r 10 10 10
#./amg2006 -P 2 2 1 -n 2 2 4  -r 10 10 10
