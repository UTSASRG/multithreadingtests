# multithreadingtests
Purpose: this package includes the PARSEC and Phoenix benchmark suite. 
However, the original ones are not easy to use. That is the reason why we put here.
Thanks the original author Charlie Curtsinger for his effort when we are testing the 
DTHREADS library.  

Two files (ROOT/Default.mk and ROOT/run_benchmarks.py) that you need to change:
ROOT/Default.mk: 
This is the main control file that you will need to change. If you are using this to evaluate the library,
you will have to change MYLIB_WITH_DIR and MYLIB.

ROOT/run_benchmarks.py:
This is a python script written by Charlie Curtsinger. Since the main purpose is to compare the performace
of MYLIB with pthreads, we can change the setting of all_configs = ['pthread', 'lockperf']
The second one should match the "MYLIB" setting at ROOT/Default.mk. 


ROOT/tests/defines.mk:
There are few settings further. 
HOME=../..: normally, you don't have to change this. 
DATASET_HOME=../../datasets   : where you put the datasets. You don't have to change this. 
NCORES := 32  : How many cores in your machine. If running it on srg1, you don't have to change this. But if you want the program to run slower, you can change this to 8 cores. It will create $NCORES threads in the execution. 

DATASET = large:
We provide two settings (native | large) to run the applications. Not exactly every test case will be changed. Generally, "native" will runs more time, from dozens of seconds to few minutes. "large" will only run few seconds. 

Steps to execute the program:
(1) First, copy the datasets file into "ROOT/datasets" directory. You can get one copy at 
srg1 machine at /home/tongpingliu/projects/multithreadingtests/datasets.tar.gz. If you can't get it,
please get it from the following places:
About the datasets, for all phoenix benchmarks, we can get it from
https://github.com/kozyraki/phoenix.

For parsec, please refer to http://parsec.cs.princeton.edu/ 

(2) Second, setup the Default.mk file. In special case, you have to change ROOT/tests/defines.mk. 

Two ways to run the benchmark. 

(1) You can use run_benchmarks.py by setting up this file correspondingly. Should be easy for you to figure out. 
(2) You can go to "tests/APP" and run directly. If you want to run "pthread", you can run "make eval-pthread". If you want to run MYLIB, you can run "make eval-MYLIB". Where MYLIB should match the one that you set for Default.mk. 

