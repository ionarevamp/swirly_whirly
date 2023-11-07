#!/bin/bash/
pushd .; \
cd src/lib; \
gcc -c -fPIC bypass.c; \
gcc -shared -o bypass.dll bypass.o; \
popd; \
