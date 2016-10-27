
/* Infix notation calculator--calc */
%output "parser.c"

%{
#include <stdio.h>
#include <math.h>
#include <ctype.h>
#include "globals.h"
#include "scope.h"
#include "nodes.h"

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;




using namespace std;
%}

%code provides {
	void yyerror(const char* s);
}

%code requires {
	#include "nodes.h"
}

/* BISON Declarations */
%define api.value.type {Node*}

%token L_PAREN
%token R_PAREN
%token L_CURLY
%token R_CURLY
%token INTEGER
%token FLOAT
%token NEWLINE
%token SEMICOLON
%token IF
%token ELSE
%token AND
%token OR
%token NOT
%token EQUAL
%token EQUAL_EQUAL
%token LT //less than
%token LT_EQUAL //less than or equal
%token GT //greater than
%token GT_EQUAL //grater than or equal
%token NOT_EQUAL
%token MINUS_EQUAL
%token PLUS_EQUAL
%token DIVIDE_EQUAL
%token TIMES_EQUAL
%token MODULUS_EQUAL
%token PLUS
%token MINUS
%token DIVIDE
%token TIMES
%token MODULUS
%token EXPONENT
%token WHILE
%token TRUE
%token FALSE
%token BREAK
%token CONTINUE
%token RETURN
%token ID
%token PASS
%token INT_KEYWORD
%token BOOL_KEYWORD

%token PRINT

%token CLASS

%token TYPE_KEYWORD



%left MINUS PLUS
%left TIMES DIVIDE
%left MODULUS
%left NEG     /* negation--unary minus */
%right '^'    /* exponentiation        */
%left "and" "or" /* for boolean expressions */

%left NOT
%nonassoc LT LT_EQUAL GT GT_EQUAL EQUAL_EQUAL NOT_EQUAL

/* Grammar follows */
%%
program:    /* empty string */
        | line program 	{	progNode.lines.push_back($$);	}
;

lines:		  //empty string
			| lines line
;

line:			separator
			| stmts separator	{ 	$$ = $1;	}
;

// line separator
separator:	NEWLINE
			| SEMICOLON
;

stmts:			block		{	$$ = $1;	}
			| stmt		{	$$ = $1;	}
			| NEWLINE stmt	{	$$ = $2;	}
;

stmt:			if_stmt		{	$$ = $1;	}
			| while		{	$$ = $1;	}
			| RETURN exp
			| BREAK
			| CONTINUE
			| PASS
			| assign	{	$$ = $1;	}
			| decl		{	$$ = $1;	}
			| print
;

block:		L_CURLY lines R_CURLY
;

print:		PRINT L_PAREN exp R_PAREN 	//{	printf("%g", $3);	}
		| PRINT L_PAREN boolExp R_PAREN	//{	printf("%g", $3);	}
;

type:		INT_KEYWORD	{	TypeNode* tmpNode = new TypeNode;
					tmpNode->type = "int";
					$$ = tmpNode;
				}
		| BOOL_KEYWORD	{	TypeNode* tmpNode = new TypeNode;
					tmpNode->type = "bool";
					$$ = tmpNode;
				}
		//| ID //will need to make sure the ID is a class or type
;

id:		ID	{	IDNode* tmpNode = new IDNode;
				tmpNode->id = id_value;
				$$ = tmpNode;
			}
;

decl:		type id			{	DeclNode* tmpNode = new DeclNode;
						tmpNode->type =static_cast<TypeNode*>($1);
						tmpNode->id = static_cast<IDNode*>($2);
						$$ = tmpNode;
					}
		| type id EQUAL exp	{	DeclNode* tmpNode = new DeclNode;
						tmpNode->type =static_cast<TypeNode*>($1);
						tmpNode->id = static_cast<IDNode*>($2);
						tmpNode->val = $4;
						$$ = tmpNode;
					}	//{ globalScope.initializeVar(id_value,$4);	}
;

assign:			id EQUAL exp		
			| id PLUS_EQUAL exp	
			| id MINUS_EQUAL exp	
			| id TIMES_EQUAL exp	
			| id DIVIDE_EQUAL exp	
			| id MODULUS_EQUAL exp 	
;

while:		WHILE boolExp stmts	{	WhileNode* tmpNode = new WhileNode;
						tmpNode->condition = static_cast<BoolExpNode*>($2);
						tmpNode->code = $3;
						$$ = tmpNode;
					}
;

if_stmt:	IF boolExp separator stmts ELSE stmts
			| IF boolExp separator stmts
			| IF boolExp stmts ELSE stmts
			| IF boolExp stmts
;

exp:			INTEGER 		{	IntNode* tmpNode = new IntNode;
							tmpNode->val = int_value;
							$$ = tmpNode;
						}
			| FLOAT			{	FloatNode* tmpNode = new FloatNode;
							tmpNode->val = float_value;
							$$ = tmpNode;
						}
			| id 				//{ $$ = globalScope.getVar(id_value); }
			| exp PLUS exp			//{ $$ = $1 + $3;	}
			| exp MINUS exp			//{ $$ = $1 - $3;	}
			| exp TIMES exp			//{ $$ = $1 * $3;	}
			| exp DIVIDE exp		//{ $$ = $1 / $3;	}
			| exp MODULUS exp		//{ $$ = static_cast<int>($1) % static_cast<int>($3);	}
			| exp EXPONENT exp		//{ $$ = pow($1,$3);}
			| MINUS exp  %prec NEG		//{ $$ = -$2;		}
			| L_PAREN exp R_PAREN		//{ $$ = $2;		}
;

boolExp:	exp LT exp		{	BoolExpNode* tmpNode = new BoolExpNode;
						tmpNode->lVal = $1;
						tmpNode->rVal = $3;
						tmpNode->op = LT_OP;
						$$ = tmpNode;
					}
		| exp LT_EQUAL exp	{	BoolExpNode* tmpNode = new BoolExpNode;
						tmpNode->lVal = $1;
						tmpNode->rVal = $3;
						tmpNode->op = LT_EQ_OP;
						$$ = tmpNode;
					}
		| exp GT  exp		{	BoolExpNode* tmpNode = new BoolExpNode;
						tmpNode->lVal = $1;
						tmpNode->rVal = $3;
						tmpNode->op = GT_OP;
						$$ = tmpNode;
					}
		| exp GT_EQUAL exp	{	BoolExpNode* tmpNode = new BoolExpNode;
						tmpNode->lVal = $1;
						tmpNode->rVal = $3;
						tmpNode->op = GT_EQ_OP;
						$$ = tmpNode;
					}
		| exp EQUAL_EQUAL exp	{	BoolExpNode* tmpNode = new BoolExpNode;
						tmpNode->lVal = $1;
						tmpNode->rVal = $3;
						tmpNode->op = EQ_OP;
						$$ = tmpNode;
					}
		| exp NOT_EQUAL exp	{	BoolExpNode* tmpNode = new BoolExpNode;
						tmpNode->lVal = $1;
						tmpNode->rVal = $3;
						tmpNode->op = NOT_EQ_OP;
						$$ = tmpNode;
					}
		| boolExp AND boolExp	
		| boolExp OR boolExp	
		| NOT boolExp		{	BoolExpNode* tmpNode = new BoolExpNode;
						tmpNode->lVal = $2;
						tmpNode->op = NOT_OP;
						$$ = tmpNode;
					}
		| L_PAREN boolExp R_PAREN	{	$$ = $2;	}
		| TRUE		{	IntNode* tmpNode = new IntNode;
					tmpNode->val = 1;
					$$ = tmpNode;
				}
		| FALSE		{	IntNode* tmpNode = new IntNode;
					tmpNode->val = 0;
					$$ = tmpNode;
				}	
;

%%


void yyerror(const char* s)
{
  printf ("%s\n", s);
  exit(-1);
}

main (int, char**)
{
	initializeVars();	
	yyparse ();
	printf("\n");
	progNode.eval();

	return 0;
}
