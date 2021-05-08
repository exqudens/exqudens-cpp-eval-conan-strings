#!/bin/bash

SCRIPT_CMAKE_PROGRAM="${CMAKE_PROGRAM}"
SCRIPT_CONAN_PROGRAM="${CONAN_PROGRAM}"

SCRIPT_BUILD_SHARED_LIBS='true'
if [ "static" == "${1}" ]
then
  SCRIPT_BUILD_SHARED_LIBS='false'
fi

SCRIPT_MSVC_RUNTIME_LIBRARY='MultiThreadedDLL'
SCRIPT_BUILD_TYPE='Release'
SCRIPT_GENERATOR='Visual Studio 16 2019'

"${SCRIPT_CMAKE_PROGRAM}" -DBUILD_SHARED_LIBS:BOOL="${SCRIPT_BUILD_SHARED_LIBS}" -DCMAKE_MSVC_RUNTIME_LIBRARY:STRING="${SCRIPT_MSVC_RUNTIME_LIBRARY}" -DCMAKE_BUILD_TYPE:STRING="${SCRIPT_BUILD_TYPE}" -DCMAKE_CONAN_PROGRAM:FILEPATH="${SCRIPT_CONAN_PROGRAM}" -G "${SCRIPT_GENERATOR}" -S "." -B "build" &&\
"${SCRIPT_CMAKE_PROGRAM}" --build "build" --target "library-exqudens-cpp-eval-conan-strings-conan-export-testing" &&\
echo 'BUILD_SUCCESSFUL' ||\
(echo 'BUILD_FAILED' && false)
