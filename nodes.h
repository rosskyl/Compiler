#ifndef __NODES_H__
#define __NODES_H__


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


#include <vector>
#include <memory>


enum BoolOp {LT_OP, GT_OP, EQ_OP, NOT_EQ_OP, LT_EQ_OP, GT_EQ_OP};

struct Node; // base node
struct ProgramNode; // the main program node
struct DeclNode; // declaration of variable node
struct AssignNode; // assigning variable node
struct IDNode; // variable node
struct TypeNode; // type node
struct IfNode; // if node
struct WhileNode; // while node
struct BlockNode; // block of instructions node
struct BoolLogNode; // logical expression node - and, or, not(!)
struct BoolExpNode; // boolean comparator node
struct NumExpNode; // number expression node
struct IntNode; // int constant node
struct FloatNode; // float constant node
struct DeclFuncNode; // function prototype
struct AssignFuncNode; // assigning function
struct FuncParamNode; // function parameters
struct FuncArgNode; // function arguments, for when using function



struct Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	llvm::Value* LogError(const char* str);
	Node* parent;

	static llvm::LLVMContext theContext;
	static llvm::IRBuilder<> Builder;
	static std::unique_ptr<llvm::Module> theModule;
	static std::map<std::string, llvm::Value*> namedValues;

};

struct ProgramNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	std::vector<Node*> lines;
};

struct DeclNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	TypeNode* type;
	IDNode* id;
	Node* val;//optional
};

struct AssignNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	IDNode* id;
	Node* val;
};

struct IDNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	char* id;
};

struct TypeNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	char* type;
};

struct IfNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	BoolExpNode* condition;
	Node* ifCode;
	Node* elseCode;//optional
};

struct WhileNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	BoolExpNode* condition;
	Node* code;
};

struct BlockNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	std::vector<Node*> lines;
};

struct BoolLogNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	Node* lVal;
	Node* rVal;
	char op;
};

struct BoolExpNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	Node* lVal;
	Node* rVal;
	BoolOp op;
};

struct NumExpNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	Node* lVal;
	Node* rVal;
	char op;//'+', '-', '/', '*' '^', '%'
};

struct IntNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	int val;
};

struct FloatNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	float val;
};

struct DeclFuncNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	TypeNode* returnType;
	IDNode* name;
	FuncParamNode* params;
};

struct AssignFuncNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	TypeNode* returnType;
	IDNode* name;
	FuncParamNode* params;
	BlockNode* code;
};

struct FuncParamNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	std::vector<DeclNode*> params;
};

struct FuncArgNode : Node {
	virtual void eval();
	virtual llvm::Value* codegen();
	std::vector<IDNode*> args;
};

#endif
