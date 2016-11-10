#ifndef __GLOBALS_H__
#define __GLOBALS_H__

#include "scope.h"
#include "nodes.h"

extern int int_value;
extern float float_value;
extern char* id_value;
extern Scope globalScope;
extern ProgramNode progNode;

void initializeVars();

#endif
