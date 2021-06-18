#!/bin/bash

rm -rfv "${USERPROFILE}/.conan/data/exqudens-cpp-eval-conan-strings-lib/" &&\
rm -rfv "./build/" &&\
"./cmake-export.sh" "cmd-windows-ninja-msvc-release-shared" &&\
sleep 3s &&\
"./cmake-export.sh" "cmd-windows-ninja-msvc-release-static" &&\
sleep 3s &&\
"./cmake-export.sh" "cmd-windows-ninja-gcc-release-shared" &&\
sleep 3s &&\
"./cmake-export.sh" "cmd-windows-ninja-gcc-release-static"
