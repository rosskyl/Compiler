#ifndef __CREATENODES_H__
#define __CREATENODES_H__

#include "nodes.h"

TypeNode*	createTypeNode(char* type);
IDNode*		createIDNode(char* id);
DeclNode*	createDeclNode(Node* id, Node* type, Node* exp);
AssignNode*	createAssignNode(Node* id, Node* exp, char op);
WhileNode*	createWhileNode(Node* cond, Node* code);
IfNode*		createIfNode(Node* cond, Node* code, Node* elseCode);
NumExpNode*	createNumExpNode(Node* lVal, Node* rVal, char op);
IntNode*	createIntNode(int val);
FloatNode*	createFloatNode(float val);
BoolExpNode*	createBoolExpNode(Node* lVal, Node* rVal, BoolOp op);
BlockNode*	createBlockNode();
NumExpNode*	createNegNumExpNode(Node* val);

#endif
