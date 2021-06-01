#!/bin/bash

rm -rfv "${USERPROFILE}/.conan/data/exqudens-cpp-eval-conan-strings-lib/" &&\
rm -rfv "./build/" &&\
"./cmake-export.sh" "msvc-16-shared" &&\
sleep 3s &&\
"./cmake-export.sh" "msvc-16-static" &&\
sleep 3s &&\
"./cmake-export.sh" "gcc-10-shared" &&\
sleep 3s &&\
"./cmake-export.sh" "gcc-10-static"
