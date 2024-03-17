#!/bin/bash

# luarocks install --local luastatic

# Remove bin/ directory
rm -r ./bin
mkdir ./bin

# Compile using luastatic
luastatic ./src/main.lua /usr/lib/x86_64-linux-gnu/liblua5.4.a -I/usr/include/lua5.4

rm ./main.luastatic.c

mv ./main ./bin/mint
chmod +x ./bin/mint

echo "Mint made by StephenM."
