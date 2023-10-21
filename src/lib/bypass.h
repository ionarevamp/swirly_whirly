#ifndef BYPASS_H
#define BYPASS_H

extern "C" __declspec(dllexport)
#define EXPORT_DLL __declspec(dllexport)

EXPORT_DLL sleep_s();
EXPORT_DLL rgbwr();

#endif
