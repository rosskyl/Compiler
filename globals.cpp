#include "globals.h"
#include "scope.h"
#include "nodes.h"


int int_value;

float float_value;

char* id_value;

Scope globalScope;

ProgramNode progNode;



void initializeVars() {
	progNode.parent = NULL;
}
