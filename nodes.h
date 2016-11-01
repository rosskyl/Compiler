#ifndef __NODES_H__
#define __NODES_H__

#include <vector>

//have all inherit from Node
enum BoolOp {LT_OP, GT_OP, EQ_OP, NOT_EQ_OP, LT_EQ_OP, GT_EQ_OP};

struct Node;
struct ProgramNode;
struct DeclNode;
struct AssignNode;
struct IDNode;
struct TypeNode;
struct IfNode;
struct WhileNode;
struct BlockNode;
struct BoolLogNode;
struct BoolExpNode;
struct NumExpNode;
struct IntNode;
struct FloatNode;


struct Node {
	virtual void eval();
	Node* parent;
};

struct ProgramNode : Node {
	virtual void eval();
	std::vector<Node*> lines;
};

struct DeclNode : Node {
	virtual void eval();
	TypeNode* type;
	IDNode* id;
	Node* val;//optional
};

struct AssignNode : Node {
	virtual void eval();
	IDNode* id;
	Node* val;
};

struct IDNode : Node {
	virtual void eval();
	char* id;
};

struct TypeNode : Node {
	virtual void eval();
	char* type;
};

struct IfNode : Node {
	virtual void eval();
	BoolExpNode* condition;
	Node* ifCode;
	Node* elseCode;//optional
};

struct WhileNode : Node {
	virtual void eval();
	BoolExpNode* condition;
	Node* code;
};

struct BlockNode : Node {
	virtual void eval();
	std::vector<Node*> lines;
};

struct BoolLogNode : Node {
	virtual void eval();
	Node* lVal;
	Node* rVal;
	char op;
};

struct BoolExpNode : Node {
	virtual void eval();
	Node* lVal;
	Node* rVal;
	BoolOp op;
};

struct NumExpNode : Node {
	virtual void eval();
	Node* lVal;
	Node* rVal;
	char op;//'+', '-', '/', '*' '^', '%'
};

struct IntNode : Node {
	virtual void eval();
	int val;
};

struct FloatNode : Node {
	virtual void eval();
	float val;
};

#endif
