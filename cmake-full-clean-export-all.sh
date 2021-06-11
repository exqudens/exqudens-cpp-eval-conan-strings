#!/bin/bash

rm -rfv "${USERPROFILE}/.conan/data/exqudens-cpp-eval-conan-strings-lib/" &&\
rm -rfv "./build/" &&\
"./cmake-export.sh" "cmd-windows-ninja-msvc-host-x64-target-x64-release-shared" &&\
sleep 3s &&\
"./cmake-export.sh" "cmd-windows-ninja-msvc-host-x64-target-x64-release-static" &&\
sleep 3s &&\
"./cmake-export.sh" "cmd-windows-ninja-gcc-host-x64-target-x64-release-shared" &&\
sleep 3s &&\
"./cmake-export.sh" "cmd-windows-ninja-gcc-host-x64-target-x64-release-static"
