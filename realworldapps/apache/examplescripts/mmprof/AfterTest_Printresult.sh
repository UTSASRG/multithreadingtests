#!/bin/bash

if [ $TEST_RESULT_LOG_FOLDER == "NULL" ]; then
    echo "Please run \"source config.sh\" first to initialize environment variables"
    exit -1
fi

mkdir -p $TEST_RESULT_LOG_FOLDER

while IFS= read -r line; do
  printf '%s\n' "$line"
  echo "$line" >> $TEST_RESULT_LOG_FOLDER/mysqlresult_$2_memory_$BUILD_TIMESTAMP.log
done

echo "I (AfterTest_Printresult.sh) has saved the testing result to $TEST_RESULT_LOG_FOLDER/apacheresult_$2_memory_$BUILD_TIMESTAMP.log"
