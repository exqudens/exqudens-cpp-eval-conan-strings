#!/bin/bash

rm -rfv "${USERPROFILE}/.conan/data/exqudens-cpp-eval-conan-strings-lib/" &&\
rm -rfv "./build/" &&\
"./cmake-export.sh" "msvc" "shared" &&\
sleep 3s &&\
rm -rfv "./build/" &&\
"./cmake-export.sh" "msvc" "static" &&\
sleep 3s &&\
rm -rfv "./build/" &&\
"./cmake-export.sh" "gcc" "shared" &&\
sleep 3s &&\
rm -rfv "./build/" &&\
"./cmake-export.sh" "gcc" "static"