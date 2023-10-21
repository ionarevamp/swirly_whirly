// BYPASS
// Main purpose of this file is to BYPASS
//  the need for slow functions

#include <unistd.h>
#include <stdio.h>

// sleep for x milliseconds
void sleep_s(float x) {
  usleep((int)(x * 1000 * 1000));
}
void rgbwr(const char* text,int r,int g,int b) {
  printf("\33[38;2;%d;%d;%dm%s\33[0m",(int)r,(int)g,(int)b,text);
}
