#ifndef BYPASS_H
#define BYPASS_H


int def_prog_mode(void);
int def_shell_mode(void);

int reset_prog_mode(void);
int reset_shell_mode(void);

int resetty(void);
int savetty(void);

void getsyx(int y, int x);
void setsyx(int y, int x);

int ripoffline(int line, int (*init)(WINDOW *, int));
int curs_set(int visibility);
int napms(int ms);

extern "C" __declspec(dllexport)
#define EXPORT_DLL __declspec(dllexport)

EXPORT_DLL sleep_s();
EXPORT_DLL rgbwr();
EXPORT_DLL rgbbg();
EXPORT_DLL rgbreset();
EXPORT_DLL input_buf();
EXPORT_DLL Cwrite();

#endif
