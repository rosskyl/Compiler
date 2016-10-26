#ifndef __NODES_H__
#define __NODES_H__

#include <vector>

//have all inherit from Node
enum BoolOp {LT_OP, GT_OP, EQ_OP, NOT_EQ_OP, LT_EQ_OP, GT_EQ_OP, NOT_OP};

struct Node {
	virtual void eval();
	Node* parent;
};

struct ProgramNode : Node {
	virtual void eval();
	std::vector<Node*> lines;
};

struct IfNode : Node {
	virtual void eval();
	Node* condition;
	Node* ifCode;
	Node* elseCode;
};

struct WhileNode : Node {
	virtual void eval();
	Node* condition;
	Node* code;
};

struct BlockNode : Node {
	virtual void eval();
	std::vector<Node*> lines;
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
