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

DeclFuncNode* createDeclFuncNode(Node* returnType, Node* name, Node* params) {
	DeclFuncNode* node = new DeclFuncNode;
	node->returnType = static_cast<TypeNode*>(returnType);
	node->name = static_cast<IDNode*>(name);
	node->params = static_cast<FuncParamNode*>(params);
	return node;
}

AssignFuncNode* createAssignFuncNode(Node* returnType, Node* name, Node* params, Node* code) {
	AssignFuncNode* node = new AssignFuncNode;
	node->returnType = static_cast<TypeNode*>(returnType);
	node->name = static_cast<IDNode*>(name);
	node->params = static_cast<FuncParamNode*>(params);
	node->code = static_cast<BlockNode*>(code);
	return node;
}

FuncParamNode* createParamNode(Node* singleParam) {
	FuncParamNode* node = new FuncParamNode;
	if (singleParam != NULL)
		node->params.push_back(static_cast<DeclNode*>(singleParam));
	return node;
}

FuncCallNode* createFuncCallNode(Node* name, Node* args) {
	FuncCallNode* node = new FuncCallNode;
	node->name = static_cast<IDNode*>(name);
	node->args = static_cast<FuncArgNode*>(args);
	return node;
}

FuncArgNode* createArgNode(Node* singleArg) {
	FuncArgNode* node = new FuncArgNode;
	if (singleArg != NULL)
		node->args.push_back(static_cast<IDNode*>(singleArg));
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

BlockNode* createBlockNode() {
	BlockNode* node = new BlockNode;
	return node;
}

NumExpNode* createNegNumExpNode(Node* val) {
	NumExpNode* node = new NumExpNode;
	IntNode* negNode = new IntNode;
	negNode->val = -1;
	node->lVal = negNode;
	node->rVal = val;
	node->op = '*';
	return node;
}

BoolLogNode* createBoolLogNode(Node* lVal, Node* rVal, char op) {
	BoolLogNode* node = new BoolLogNode;
	node->lVal = lVal;
	node->rVal = rVal;
	node->op = op;
	return node;
}

ReturnNode* createReturnNode(Node* returned) {
	ReturnNode* node = new ReturnNode;
	node->returned = returned;
	return node;
}