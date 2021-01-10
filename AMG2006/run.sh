#!/usr/bin/bash

#export OMP_PLACES=cores
#export OMP_PROC_BIND=close
cd test
./amg2006 -r 20 20 20 
cd ../
