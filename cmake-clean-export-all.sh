#!/bin/bash

rm -rfv "./build/" &&\
"./cmake-export.sh" &&\
sleep 3s &&\
rm -rfv "./build/" &&\
"./cmake-export.sh" "static"
