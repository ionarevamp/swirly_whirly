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
<<<<<<< HEAD
  r = (255*(r>255))+(r*(r<255))
  g = (255*(g>255))+(g*(r<255))
  b = (255*(b>255))+(r*(b<255))
=======
>>>>>>> refs/remotes/origin/master
  printf("\33[38;2;%d;%d;%dm%s\33[0m",(int)r,(int)g,(int)b,text);
}
