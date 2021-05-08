#!/bin/bash

rm -rfv "${USERPROFILE}\\.conan\\data\\library-exqudens-cpp-eval-conan-strings" &&\
rm -rfv ".\\build" &&\
".\\cmake-install.sh" &&\
sleep 3s &&\
rm -rfv ".\\build" &&\
".\cmake-install.sh" "static"
