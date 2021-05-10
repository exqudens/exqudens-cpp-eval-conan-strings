#!/bin/bash

rm -rfv "${USERPROFILE}/.conan/data/lib-exqudens-cpp-eval-conan-strings/" &&\
rm -rfv "./build/" &&\
"./cmake-export.sh" &&\
sleep 3s &&\
rm -rfv "./build/" &&\
"./cmake-export.sh" "static"
