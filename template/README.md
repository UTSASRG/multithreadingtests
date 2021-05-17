# Example Benchmark

This example benchmark is used to demonstrate how to write and use new benchmark suites and how add a new benchmark suites.

You should be able to understand how a benchmark works by checking source code.

The test is simplified, so it shouldn't be hard. For build.sh and runtest.sh, you only need to have overall understanding of what they are doing in each step.

To create a new benchmark, you can copy this template as a starting point.

## To test this example:

### Preparation

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