#!/bin/bash
pushd .;
cd src/lib;
tcc -c bypass.c;
tcc -shared -o bypass.dll bypass.o;
popd;
