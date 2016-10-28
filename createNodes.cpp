#include "nodes.h"

TypeNode* createTypeNode(char* type) {
	
}

IDNode* createIDNode(char* id) {
	
}

DeclNode* createDeclNode(Node* id, Node* type, Node* exp) {
	DeclNode* node = new DeclNode;
	node->type = static_cast<TypeNode*>(type);
	node->id = static_cast<IDNode*>(id);
	node->val = exp;
	return node;
}

AssignNode* createAssignNode(Node* id, Node* exp, char op) {
	
}

WhileNode* createWhileNode(Node* cond, Node* code) {
	
}

IfNode* createIfNode(Node* cond, Node* code, Node* elseCode) {
	
}

NumExpNode* createNumExpNode(Node* lVal, Node* rVal, char op) {
	
}

IntNode* createIntNode(int val) {
	
}

FloatNode* createFLoatNode(float val) {
	
}

BoolExpNode* createBoolExpNode(Node* lVal, Node* rVal, BoolOp op) {
	
}


