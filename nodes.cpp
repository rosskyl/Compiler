#include <iostream>
#include "nodes.h"



void Node::eval() {};

void ProgramNode::eval() {
	std::vector<Node*>::iterator i;
	for (i = lines.begin(); i != lines.end(); i++)
		(*i)->eval();
};

void DeclNode::eval() {
	type->eval();
	id->eval();
	if (val != NULL)
		val->eval();
};

void IDNode::eval() {
	std::cout << "ID: " << id << std::endl;
};

void TypeNode::eval() {
	std::cout << "Type: " << type << std::endl;
};

void IfNode::eval() {
	condition->eval();
	ifCode->eval();
	if (elseCode != NULL)
		elseCode->eval();
};

void WhileNode::eval() {
	condition->eval();
	code->eval();
};

void BlockNode::eval() {
	std::vector<Node*>::iterator i;
	for (i = lines.begin(); i != lines.end(); i++)
		(*i)->eval();
};

void BoolExpNode::eval() {
	lVal->eval();
	rVal->eval();
};

void NumExpNode::eval() {
	lVal->eval();
	rVal->eval();
};

void IntNode::eval() {
	std::cout << "Int: " << val << std::endl;
};

void FloatNode::eval() {
	std::cout << "Float: " << val << std::endl;
};


