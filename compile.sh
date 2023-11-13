#!/bin/bash/
pushd .; \
cd src/lib; \
gcc -o bypass.o -c -fPIC bypass.c -lncurses; \
gcc -shared -o bypass.tmp bypass.o; \
mv bypass.tmp bypass.dll; \
popd; \
