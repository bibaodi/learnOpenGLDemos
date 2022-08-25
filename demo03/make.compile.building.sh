#!/bin/bash

mkdir ./build

cd build

cmake ../ -G Ninja

cmake --build ./ -- -j 2

echo -e "Finish..."
