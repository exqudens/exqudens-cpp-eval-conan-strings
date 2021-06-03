#!/bin/bash

rm -rfv "${USERPROFILE}/.conan/data/exqudens-cpp-eval-conan-strings-lib/" &&\
rm -rfv "./build/" &&\
"./cmake-export.sh" "cmd-msvc-16-shared" &&\
sleep 3s &&\
"./cmake-export.sh" "cmd-msvc-16-static" &&\
sleep 3s &&\
"./cmake-export.sh" "cmd-gcc-10-shared" &&\
sleep 3s &&\
"./cmake-export.sh" "cmd-gcc-10-static"
