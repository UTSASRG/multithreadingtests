project(tempaltetest)
cmake_minimum_required(VERSION 3.10)

set (CMAKE_CXX_STANDARD 11)


option(BUILD_WITH_TEST_LIB "Compile with test lib" OFF)

set(TEST_LIB_LOCATION "" CACHE STRING "The location of testlib")


add_executable(testapp main.cpp)

if(BUILD_WITH_TEST_LIB)
    message(STATUS "I'll build with testlib at ${TEST_LIB_LOCATION}")
    target_compile_definitions(testapp PRIVATE USE_TESTLIB=1)
    include_directories(${TEST_LIB_LOCATION}/include)
    add_library(testlib SHARED ${TEST_LIB_LOCATION}/mainlib.cpp)
    target_link_libraries(testapp testlib)
    install(TARGETS testlib)
endif()

install(TARGETS testapp)