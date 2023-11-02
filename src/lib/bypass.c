// BYPASS
// Main purpose of this file is to BYPASS
//  the need for slow functions

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

void rgbbg(float r,float g,float b) {
  // keep input bounded
  r = (255*(r>255))+(r*(r<256));
  g = (255*(g>255))+(g*(g<256));
  b = (255*(b>255))+(b*(b<256));
  printf("\33[48;2;%d;%d;%dm",(int)r,(int)g,(int)b);
}

void rgbwr(const char* text,float r,float g,float b) {
  // keep input bounded
  r = (255*(r>255))+(r*(r<256));
  g = (255*(g>255))+(g*(g<256));
  b = (255*(b>255))+(b*(b<256));
  printf("\33[38;2;%d;%d;%dm%s",(int)r,(int)g,(int)b,text);
}

void rgbreset(float Rr,float Rg,float Rb,float Br,float Bg,float Bb) {
  Rr = (255*(Rr>255))+(Rr*(Rr<256));
  Rg = (255*(Rg>255))+(Rg*(Rg<256));
  Rb = (255*(Rb>255))+(Rb*(Rb<256));
  Br = (255*(Br>255))+(Br*(Br<256));
  Bg = (255*(Bg>255))+(Bg*(Bg<256));
  Bb = (255*(Bb>255))+(Bb*(Bb<256));
  printf("\33[48;2;%d;%d;%dm",(int)Br,(int)Bg,(int)Bb);
  printf("\33[38;2;%d;%d;%dm",(int)Rr,(int)Rg,(int)Rb);
}

char input_buf() {
  char buffer[1024];
  fgets(buffer, sizeof(buffer), stdin);
  return *buffer;
}

void Cwrite(const char* text) {
  printf("%s",text);
}

long getns(){
    long ns;
    struct timespec spec;

    clock_gettime(CLOCK_REALTIME, &spec);
    ns = (long)(spec.tv_nsec / 1.0e6);

    return ns;
}