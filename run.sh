#!/bin/bash

if command -v /bin/lua &>/dev/null; then
	echo "ERROR: Lua is not installed."
	exit 1
fi

lua src/mint.lua