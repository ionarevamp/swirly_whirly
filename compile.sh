#!/bin/bash/
pushd .; \
cd src/lib; \
gcc -c -fPIC bypass.c; \
gcc -shared -o bypass.tmp bypass.o; \
mv bypass.tmp bypass.dll; \
popd; \
