// BYPASS
// Main purpose of this file is to BYPASS
//  the need for slow functions in Lua
//  (either by avoiding syscalls or ensuring efficiency)

#include <inttypes.h>
#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include <math.h>
#include <curses.h>
//#include "libbf.c"


// sleep for x milliseconds
void sleep_s(float x) {
  usleep((int)(x * 1000 * 960)); //microseconds
  // ^^ `960` rather than `1000` to estimate, AND
    // account for, overhead without adding more
}

char input_buf() {
  char buffer[1024];
  fgets(buffer, sizeof(buffer), stdin);
  return *buffer;
}

long getns(){
    long ns;
    struct timespec spec;

    clock_gettime(CLOCK_REALTIME, &spec);
    ns = (long)(spec.tv_nsec / 1.0e6);

    return ns;
}
int testmath() {
  return 69*420;  
}