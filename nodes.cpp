#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"



#include <iostream>
#include "nodes.h"



void Node::eval() {}

void ProgramNode::eval() {
	std::vector<Node*>::iterator i;
	for (i = lines.begin(); i != lines.end(); i++)
		if ((*i) != NULL)
			(*i)->eval();
}

void DeclNode::eval() {
	type->eval();
	id->eval();
	if (val != NULL)
		val->eval();
}

void AssignNode::eval() {
	id->eval();
	val->eval();
}

void IDNode::eval() {
	std::cout << "ID: " << id << std::endl;
}

void TypeNode::eval() {
	std::cout << "Type: " << type << std::endl;
}

void IfNode::eval() {
	condition->eval();
	ifCode->eval();
	if (elseCode != NULL)
		elseCode->eval();
}

void WhileNode::eval() {
	condition->eval();
	code->eval();
}

void BlockNode::eval() {
	std::vector<Node*>::iterator i;
	for (i = lines.begin(); i != lines.end(); i++)
		if ((*i) != NULL)
			(*i)->eval();
}

void BoolLogNode::eval() {
	if (op != '!')
		lVal->eval();
	rVal->eval();
}

void BoolExpNode::eval() {
	lVal->eval();
	rVal->eval();
}

void NumExpNode::eval() {
	lVal->eval();
	rVal->eval();
}

void IntNode::eval() {
	std::cout << "Int: " << val << std::endl;
}

void FloatNode::eval() {
	std::cout << "Float: " << val << std::endl;
}


