#!/bin/bash

mkdir ./build

cd build

cmake ../ -G Ninja

cmake --build .

echo -e "Finish..."
