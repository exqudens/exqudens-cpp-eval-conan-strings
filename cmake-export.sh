#!/bin/bash

SCRIPT_CMAKE_PROGRAM_PATH="${CMAKE_PROGRAM_PATH}"
SCRIPT_CONAN_PROGRAM_PATH="${CONAN_PROGRAM_PATH}"

SCRIPT_MSVC_RUNTIME_LIBRARY='MultiThreadedDLL'
SCRIPT_BUILD_TYPE='Release'
if [ "msvc" == "${1}" ]
then
  SCRIPT_GENERATOR='Visual Studio 16 2019'
elif [ "gcc" == "${1}" ]
then
  SCRIPT_GENERATOR='CodeBlocks - MinGW Makefiles'
else
  echo "Unsupported GENERATOR: '${1}'" && exit 1
fi
if [ "shared" == "${2}" ]
then
  SCRIPT_BUILD_SHARED_LIBS='true'
elif [ "static" == "${2}" ]
then
  SCRIPT_BUILD_SHARED_LIBS='false'
else
  echo "Unsupported BUILD_SHARED_LIBS: '${2}'" && exit 1
fi

"${SCRIPT_CMAKE_PROGRAM_PATH}" -DBUILD_SHARED_LIBS:BOOL="${SCRIPT_BUILD_SHARED_LIBS}" -DCMAKE_MSVC_RUNTIME_LIBRARY:STRING="${SCRIPT_MSVC_RUNTIME_LIBRARY}" -DCMAKE_BUILD_TYPE:STRING="${SCRIPT_BUILD_TYPE}" -DCONAN_PROGRAM_PATH:FILEPATH="${SCRIPT_CONAN_PROGRAM_PATH}" -G "${SCRIPT_GENERATOR}" -S "." -B "build/${1}-${2}" &&\
"${SCRIPT_CMAKE_PROGRAM_PATH}" --build "build/${1}-${2}" --target "exqudens-cpp-eval-conan-strings-lib" &&\
"${SCRIPT_CMAKE_PROGRAM_PATH}" --build "build/${1}-${2}" --target "exqudens-cpp-eval-conan-strings-test" &&\
"${SCRIPT_CMAKE_PROGRAM_PATH}" --build "build/${1}-${2}" --target "exqudens-cpp-eval-conan-strings-lib-cmake-install" &&\
"${SCRIPT_CMAKE_PROGRAM_PATH}" --build "build/${1}-${2}" --target "exqudens-cpp-eval-conan-strings-lib-conan-export-testing" &&\
"${SCRIPT_CMAKE_PROGRAM_PATH}" --build "build/${1}-${2}" --target "exqudens-cpp-eval-conan-strings-package-test-conan-install" &&\
"${SCRIPT_CMAKE_PROGRAM_PATH}" "build/${1}-${2}" &&\
"${SCRIPT_CMAKE_PROGRAM_PATH}" --build "build/${1}-${2}" --target "exqudens-cpp-eval-conan-strings-package-test" &&\
"${SCRIPT_CMAKE_PROGRAM_PATH}" --build "build/${1}-${2}" --target "exqudens-cpp-eval-conan-strings-lib-conan-export" &&\
echo 'BUILD_SUCCESSFUL' ||\
(echo 'BUILD_FAILED' && false)
