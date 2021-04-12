This repository contains multiple test applications for benchmarking and load testing. See the individual folders' README.md files for information on each test.

## What's new here

This branch intends to create a better benchmarking experience.

Targets:
- Path-independent
- Sufficient comments
- Faster build speed. Build first, benchmark second
- Customization through python scripts. Seperate built-in and custom scripts

The phlociphy of the new benchmark scripts is "Do one thing and do it well." The core script is only in charge of compiling the libraries correctly. It's designed to be universal, customization is realized by your own scripts.

You should **NOT** change built-in scripts to modify compilation behavior unless you are developing the benchmark suite itself. If you want to make chages to them, you need to make sure they are universal changes that applies to other testing senarios as well. You could easily customize build procedure by editing customized python scripts. (eg: Override compilatioin parameters, Preload a library, Write a log file, Initialize execution envionment .etc)

You should **NOT** commit anything that is related to your own program unless you are developing the benchmark suite itself. Changes must be universal to other programs. Check CONTRIBUTION.md for more development guidelines.

The typical testing workflow is like this:
- Clone and initialize this repo
- Take a look at the ReadMe.md and learn the funcitonality of different scripts/folders. Most importantly, you need to figure out which scripts you need to modify. Only check and change scripts as instrcted. You don't need to change/understand other scripts. This design is to seperate things you should know and things you don't need to care about.
- Customize python scripts. The most common tasks should already been provided in example scripts. So you probably only need to change a few lines of code. Understanding those scripts is necessary. Otherwise you won't have control over the the compilation process.
- Run built-in scripts. Those scripts should automatically call your customized scripts.

## How to use

1. Clone this repo into your home folder
    ```
    git clone https://github.com/akopytov/sysbench.git
    ```
2. Switch to dev-steven branch
    ```
    git checkout dev-steven
    ```
3. Only init git submodules that you want to test
    eg: If you only want to test mysql
    ```
    cd ROOT_FOLDER_OF_THIS_REPO
    git submodule init #Init local submodule config
    git submodule update --init --recursive realworldapps/mysql/src
    ```
    eg: If you want to test everything
    ```
    cd ROOT_FOLDER_OF_THIS_REPO
    git submodule update --init --recursive --depth=1
    ```