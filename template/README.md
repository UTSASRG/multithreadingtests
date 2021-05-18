# Example Benchmark

This example benchmark is used to demonstrate how to write and use new benchmark suites and how add a new benchmark suites.

You should be able to understand how a benchmark works by checking source code.

The test is simplified, so it shouldn't be hard. For build.sh and runtest.sh, you only need to have overall understanding of what they are doing in each step.

To create a new benchmark, you can copy this template as a starting point.

The main program is placed in **src** and will need a library in **lib** to compile.

A seperate pseodu allotor that will hook main function and execute before it will be added by a custom arg parsing script.

## To test this example:

1. Link example scripts to myscripts

   ```
   ln -s ../examplescripts/steven/* .
   ```
   
2. Add the following lines to customization zone of config.sh to setup build scripts

   ```
   export PRE_BUILD_SCRIPT="$TEST_ROOT_DIR/myscripts/PreBuild.sh"
   
   export BUILD_ARG_PROCESS_SCRIPT="$TEST_ROOT_DIR/myscripts/ArgProcessor.py"
   
   export AFTER_BUILD_SCRIPT="$TEST_ROOT_DIR/myscripts/AfterBuild.sh"
   
   export PRE_TEST_SCRIPT="$TEST_ROOT_DIR/myscripts/PreTest.sh"
   
   export AFTER_TEST_SCRIPT="$TEST_ROOT_DIR/myscripts/AfterTest.sh"
   ```
   
3. Build
   ```
    #cd to benchmark root dir
    cd template

    #Use build.sh to build an application with build name normal (Different build versions can be distinguished by build name. And your scripts have the chance to make differnt changes based on the build name). In this case, the build name is "normal"
    ./build.sh normal

   
   ```
   
4. Run test

   ```
    #Run the test
    ./runtest.sh start normal
   ```

The result is a json file, you could use your favourite tools to process it without any hassle.

## Example results

### Not specifying any hook in config.sh

If you don't add scripts in config.sh, then all the processing scripts will not run. And the pseudo allocator won't be linked. You will get the following output.

But this benchmark (and all other benchmarks) should compile successfully without any modification.

Since all scripts are unused, the pseudo allocator won't be linked.

```
st@PW:~/Projects/multithreadingtests/template$ ./runtest.sh start normal
Load configuration
Starting template (log prefix: template_20210518101119) [Async]
  Log sneakpeek: 
  I'll then allocate 1MB memory to simulate actual memory usage.
  I'll then read and print input.
  Test library was linked. 1+2=3
Results placed in /home/st/Projects/multithreadingtests/template/logs/testresult/template_20210518101119.json
Results also hardlinked to ./results.json

st@PW:~/Projects/multithreadingtests/template$ cat logs/testresult/template_20210518101119.log 
Benchmark running, I'll sleep for 1sec to simulate actual computation.
I'll then allocate 1MB memory to simulate actual memory usage.
I'll then read and print input.
Test library was linked. 1+2=3
```

### Specifying every hook in config.sh

Don't forget to put scripts to myscripts folder as discussed before.\

```
st@PW:~/Projects/multithreadingtests/template$ ./runtest.sh start normal
Load configuration
Executing your pre-test script /home/st/Projects/multithreadingtests/template/myscripts/PreTest.sh
I'm PreTest.sh. I'm executing.
Starting template (log prefix: template_20210518131758) [Async]
  Log sneakpeek: 
  I'll then allocate 1MB memory to simulate actual memory usage.
  I'll then read and print input.
  This is a smaple input.Test library was linked. 1+2=3
Results placed in /home/st/Projects/multithreadingtests/template/logs/testresult/template_20210518131758.json
Results also hardlinked to ./results.json

st@PW:~/Projects/multithreadingtests/template$ cat logs/testresult/template_20210518131758.log
I'm a test allocator that execute before main.
Benchmark running, I'll sleep for 1sec to simulate actual computation.
I'll then allocate 1MB memory to simulate actual memory usage.
I'll then read and print input.
This is a smaple input.Test library was linked. 1+2=3
```

You can see outputs like "xecuting your pre-test script ..." This is built by output.
You can also see "I'm a test allocator that execute before main." which means the allocator has been linked by your customized scripts.

