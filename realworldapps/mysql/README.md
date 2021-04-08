# Mysql test

Version: 5.7.15
## Dirs

```
- config.sh
    Configuration file.
- build.sh
    Compile mysql.
    All arguments of this script is passed into PRE_BUILD_SCRIPT, BUILD_ARG_PROCESS_SCRIPT and AFTER_BUILD_SCRIPT
- src
    Mysql source code
- exampleScripts
    - addExtraArgProcesssor.py: Add extra build arguments defined by an environmental variable. Built for **BUILD_ARG_PROCESS_SCRIPT**
    - addExtraArgProcessorBasedOnArg.py: Read build.sh parameter and add build arguments accordingly. Built for **BUILD_ARG_PROCESS_SCRIPT**
    - install.sh: After complilation, use make install to place compiled binaries into specified folder. Built for **AFTER_BUILD_SCRIPT**
- myscripts
    Please modify scripts in exampleScripts and put it here. Then link it in config.sh.
```

