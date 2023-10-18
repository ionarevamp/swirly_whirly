#include <unistd.h>
#include <math.h>

// sleep for x milliseconds
int sleep_s(float x) {
  usleep((int)(x * 1000 * 1000));
  return 0;
}
