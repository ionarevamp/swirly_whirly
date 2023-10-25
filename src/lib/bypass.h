#ifndef BYPASS_H
#define BYPASS_H

extern "C" __declspec(dllexport)
#define EXPORT_DLL __declspec(dllexport)

EXPORT_DLL sleep_s();
EXPORT_DLL rgbwr();
EXPORT_DLL rgbbg();
EXPORT_DLL rgbreset();
EXPORT_DLL input_buf();

#endif
