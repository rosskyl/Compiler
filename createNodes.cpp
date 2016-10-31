#include <iostream>
#include "nodes.h"
TypeNode* createTypeNode(char* type) {
	TypeNode* node = new TypeNode;
	node->type = type;
	return node;
}

IDNode* createIDNode(char* id) {
	IDNode* node = new IDNode;
	node->id = id;
	return node;
}

DeclNode* createDeclNode(Node* id, Node* type, Node* exp) {
	DeclNode* node = new DeclNode;
	node->type = static_cast<TypeNode*>(type);
	node->id = static_cast<IDNode*>(id);
	node->val = exp;
	return node;
}

AssignNode* createAssignNode(Node* id, Node* exp, char op) {
	AssignNode* node = new AssignNode;
	node->id = static_cast<IDNode*>(id);
	if (op == '?')
		node->val = exp;
	else {
		NumExpNode* expNode = new NumExpNode;
		expNode->lVal = id;
		expNode->rVal = exp;
		expNode->op = op;
		node->val = expNode;
	}
	return node;
}

WhileNode* createWhileNode(Node* cond, Node* code) {
	WhileNode* node = new WhileNode;
	node->condition = static_cast<BoolExpNode*>(cond);
	node->code = code;
	return node;
}

IfNode* createIfNode(Node* cond, Node* code, Node* elseCode) {
	IfNode* node = new IfNode;
	node->condition = static_cast<BoolExpNode*>(cond);
	node->ifCode = code;
	node->elseCode = elseCode;
	return node;
}

NumExpNode* createNumExpNode(Node* lVal, Node* rVal, char op) {
	NumExpNode* node = new NumExpNode;
	node->lVal = lVal;
	node->rVal = rVal;
	node->op = op;
	return node;
}

IntNode* createIntNode(int val) {
	IntNode* node = new IntNode;
	node->val = val;
	return node;
}

FloatNode* createFloatNode(float val) {
	FloatNode* node = new FloatNode;
	node->val = val;
	return node;
}

BoolExpNode* createBoolExpNode(Node* lVal, Node* rVal, BoolOp op) {
	BoolExpNode* node = new BoolExpNode;
	node->lVal = lVal;
	node->rVal = rVal;
	node->op = op;
	return node;
}


