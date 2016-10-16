#include "scope.h"
#include "parser.h"
#include <map>
#include <iostream>
#include <string>
#include <stdexcept>

Scope::Scope() {
	
}

void Scope::initializeVar(char* id, int newValue) {
	std::string newID(id);
	if (isVar(id))
		yyerror("Variable already declared");
	else
		variables[newID] = newValue;
}

int Scope::getVar(char* id) {
	std::string newID(id);
	if (isVar(id))
		return variables.at(newID);
	else
		yyerror("Variable not declared");
}

void Scope::setVar(char* id, int newValue) {
	std::string newID(id);
	if (isVar(id))
		variables[newID] = newValue;
	else
		yyerror("Variable not declared");
}

bool Scope::isVar(char* id) {
	std::string newID(id);
	if (variables.count(newID) > 0)
		return true;
	else
		return false;
}