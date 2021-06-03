#!/bin/bash

cmake -S "." --preset "${1}" &&\
cmake --build --preset "${1}" --target "exqudens-cpp-eval-conan-strings-lib" &&\
cmake --build --preset "${1}" --target "exqudens-cpp-eval-conan-strings-test" &&\
cmake --build --preset "${1}" --target "exqudens-cpp-eval-conan-strings-lib-cmake-install" &&\
cmake --build --preset "${1}" --target "exqudens-cpp-eval-conan-strings-lib-conan-export-testing" &&\
cmake --build --preset "${1}" --target "exqudens-cpp-eval-conan-strings-package-test-conan-install" &&\
cmake -S "." --preset "${1}" &&\
cmake --build --preset "${1}" --target "exqudens-cpp-eval-conan-strings-package-test" &&\
cmake --build --preset "${1}" --target "exqudens-cpp-eval-conan-strings-lib-conan-export-testing-clean" &&\
cmake --build --preset "${1}" --target "exqudens-cpp-eval-conan-strings-lib-conan-export" &&\
echo 'BUILD_SUCCESSFUL' ||\
(echo 'BUILD_FAILED' && false)
