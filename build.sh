#!/bin/bash

# luarocks install --local luastatic

# Remove bin/ directory
rm -r ./bin
mkdir ./bin

# Compile using luastatic
luastatic ./src/main.lua /usr/lib/x86_64-linux-gnu/liblua5.4.a -I/usr/include/lua5.4
luastatic ./src/pkg.lua /usr/lib/x86_64-linux-gnu/liblua5.4.a -I/usr/include/lua5.4

rm ./main.luastatic.c
rm ./pkg.luastatic.c

mv ./main ./bin/mint
mv ./pkg ./bin/mintpkg

chmod +x ./bin/mint
chmod +x ./bin/mintpkg

echo "Mint made by StephenMortada."
