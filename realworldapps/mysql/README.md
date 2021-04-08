# Mysql test

Version: 5.7.15

## Dirs

```
- config.sh [Check and change]
    Configuration file.
- build.sh  [No change needed]
    Compile mysql.
    All arguments of this script is passed into PRE_BUILD_SCRIPT, BUILD_ARG_PROCESS_SCRIPT and AFTER_BUILD_SCRIPT
- src [No change needed]
    Mysql source code (No modification necessary)
- exampleScripts [Check and change]
    example scripts are used to store some example build scripts. You probably need to change them according to your flavor.
    By editing these scripts and link them in config.sh, you can get a chance to execute your own scripts before and after the test.
    Compiler command is passed directly to your script, and you can use python to change it.
    - addExtraArgProcesssor.py: Add extra build arguments defined by an environmental variable. Built for BUILD_ARG_PROCESS_SCRIPT.
    - addExtraArgProcessorBasedOnArg.py: Read build.sh parameter and add build arguments accordingly. Built for BUILD_ARG_PROCESS_SCRIPT.
    - install.sh: After complilation, use make install to place compiled binaries into specified folder. Built for AFTER_BUILD_SCRIPT.
- myscripts [Check and change]
    Please modify scripts in exampleScripts and put it here. Then link it in config.sh.
    This folder is not mandatory, you can put modified scripts anywhere.
    But this folder will help you organize your folders, so please follow the rules.
- tools [No change needed]
    Other tools required for this test
    - sysbench
    Sysbench is a tool that can send requests to mysql server.
- artifects [No change needed]
    This folder stores other things required during the build. Other scripts can use it anytime.
    - create_database.sql: Initialize mysql scripts for sysbench
    - tests: Test cases used by sysbench
    - sysbench: A compiled sysbench executable. (This file will be install by examplescripts/install.sh)

```

