// BYPASS
// Main purpose of this file is to BYPASS
//  the need for slow functions

#include <unistd.h>
#include <stdio.h>

// sleep for x milliseconds

void sleep_s(float x) {
  usleep((int)(x * 1000 * 1000 * 0.96));
}
void rgbwr(const char* text,float r,float g,float b) {
  // keep input bounded
  r = (int)(255*(r>255))+(r*(r<256));
  g = (int)(255*(g>255))+(g*(g<256));
  b = (int)(255*(b>255))+(b*(b<256));
  printf("\33[38;2;%d;%d;%dm%s",r,g,b,text);
}
void rgbbg(float r,float g,float b) {
  // keep input bounded
  r = (int)(255*(r>255))+(r*(r<256));
  g = (int)(255*(g>255))+(g*(g<256));
  b = (int)(255*(b>255))+(b*(b<256));
  printf("\33[48;2;%d;%d;%dm",r,g,b)
}
void rbgreset() {
  printf("\33[0m")
}
char input_buf() {
  char buffer[1024];
  fgets(buffer, sizeof(buffer), stdin);
  return *buffer;
}
