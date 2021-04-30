#!/bin/bash

SCRIPT_ROOT_PROJECT_PATH="$(cd "$(dirname "${0}")" &> /dev/null && pwd)"
SCRIPT_ROOT_PROJECT_NAME="$(basename "${SCRIPT_ROOT_PROJECT_PATH}")"
SCRIPT_LIBRARY_PROJECT_NAME="library-${SCRIPT_ROOT_PROJECT_NAME}"

rm -rfv "${USERPROFILE}\\.conan\\data\\${SCRIPT_LIBRARY_PROJECT_NAME}" &&\
rm -rfv ".\\build" &&\
".\\cmake-install.sh" &&\
sleep 3s &&\
rm -rfv ".\\build" &&\
".\cmake-install.sh" "static"
