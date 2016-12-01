
/* Infix notation calculator--calc */
%output "parser.c"

%{
#include <stdio.h>
#include <math.h>
#include <ctype.h>
#include "globals.h"
#include "scope.h"
#include "nodes.h"
#include "createNodes.h"

#include <string>

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

%token COMMA_T



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
program:	/* empty string */
		| program line	{ progNode.lines.push_back($2);	}
;

lines:		/* empty string */	{ $$ = createBlockNode();	}
		| lines line	{ dynamic_cast<BlockNode*>($1)->lines.push_back($2);	}
;

line:		separator
		| stmts separator	{ $$ = $1;	}
;

// line separator
separator:	NEWLINE
		| SEMICOLON
;

stmts:		block		{ $$ = $1;	}
		| stmt		{ $$ = $1;	}
		| NEWLINE stmt	{ $$ = $2;	}
;

stmt:		if_stmt		{ $$ = $1;	}
		| while		{ $$ = $1;	}
		| RETURN exp
		| BREAK
		| CONTINUE
		| PASS
		| assign	{ $$ = $1;	}
		| decl		{ $$ = $1;	}
		| funcDecl	{ $$ = $1;	}
		| funcAssign	{ $$ = $1;	}
;

block:		L_CURLY lines R_CURLY	{ $$ = $2;	}
;

type:		INT_KEYWORD	{ $$ = createTypeNode("int");	}
		| BOOL_KEYWORD	{ $$ = createTypeNode("bool");	}
		//| ID //will need to make sure the ID is a class or type
;

id:		ID	{ $$ = createIDNode(id_value);	}
;

funcDecl:	type id L_PAREN paramList R_PAREN	{ $$ = createDeclFuncNode($1, $2, $4);	}
;

funcAssign:	type id L_PAREN paramList R_PAREN block	{ $$ = createAssignFuncNode($1, $2, $4, $6);	}
;

paramList:	/* empty string */	{ $$ = createParamNode(NULL);	}
		| paramList COMMA_T param	{ dynamic_cast<FuncParamNode*>($1)->params.push_back(dynamic_cast<DeclNode*>($3));	}
		| param			{ $$ = createParamNode($1);	}
;

param:		type id		{ $$ = createDeclNode($2, $1, NULL);	}
;

funcCall:	id L_PAREN argList R_PAREN	{ $$ = createFuncCallNode($1, $3);	}
;

argList:	/* empty */	{ $$ = createArgNode(NULL);	}
		| argList COMMA_T arg	{ dynamic_cast<FuncArgNode*>($1)->args.push_back(dynamic_cast<IDNode*>($3));	}
		| arg		{ $$ = createArgNode($1);	}
;

arg:		id	{ $$ = $1;	}
;

decl:		type id			{ $$ = createDeclNode($2, $1, NULL);	}
		| type id EQUAL exp	{ $$ = createDeclNode($2, $1, $4);	}
;

assign:		id EQUAL exp		{ $$ = createAssignNode($1, $3, '?');	}
		| id PLUS_EQUAL exp	{ $$ = createAssignNode($1, $3, '+');	}
		| id MINUS_EQUAL exp	{ $$ = createAssignNode($1, $3, '-');	}
		| id TIMES_EQUAL exp	{ $$ = createAssignNode($1, $3, '*');	}
		| id DIVIDE_EQUAL exp	{ $$ = createAssignNode($1, $3, '/');	}
		| id MODULUS_EQUAL exp 	{ $$ = createAssignNode($1, $3, '%');	}
;

while:		WHILE boolExp stmts	{ $$ = createWhileNode($2, $3);	}
;

if_stmt:	IF boolExp separator stmts ELSE stmts	{ $$ = createIfNode($2, $4, $6);	}
			| IF boolExp separator stmts	{ $$ = createIfNode($2, $4, NULL);	}
			| IF boolExp stmts ELSE stmts	{ $$ = createIfNode($2, $3, $5);	}
			| IF boolExp stmts		{ $$ = createIfNode($2, $3, NULL);	}
;

exp:	INTEGER 		{ $$ = createIntNode(int_value);	}
	| FLOAT			{ $$ = createFloatNode(float_value);	}
	| id 			{ $$ = createIDNode(id_value);		}
	| exp PLUS exp		{ $$ = createNumExpNode($1, $3, '+');	}
	| exp MINUS exp		{ $$ = createNumExpNode($1, $3, '-');	}
	| exp TIMES exp		{ $$ = createNumExpNode($1, $3, '*');	}
	| exp DIVIDE exp	{ $$ = createNumExpNode($1, $3, '/');	}
	| exp MODULUS exp	{ $$ = createNumExpNode($1, $3, '%');	}
	| exp EXPONENT exp	{ $$ = createNumExpNode($1, $3, '^');	}
	| MINUS exp  %prec NEG	{ $$ = createNegNumExpNode($2);		}
	| L_PAREN exp R_PAREN	{ $$ = $2;	}
	| funcCall		{ $$ = $1;	}
;

boolExp:	exp LT exp		{ $$ = createBoolExpNode($1, $3, LT_OP);	}
		| exp LT_EQUAL exp	{ $$ = createBoolExpNode($1, $3, LT_EQ_OP);	}
		| exp GT  exp		{ $$ = createBoolExpNode($1, $3, GT_OP);	}
		| exp GT_EQUAL exp	{ $$ = createBoolExpNode($1, $3, GT_EQ_OP);	}
		| exp EQUAL_EQUAL exp	{ $$ = createBoolExpNode($1, $3, EQ_OP);	}
		| exp NOT_EQUAL exp	{ $$ = createBoolExpNode($1, $3, NOT_EQ_OP);	}
		| boolExp AND boolExp	{ $$ = createBoolLogNode($1, $3, '&');	}
		| boolExp OR boolExp	{ $$ = createBoolLogNode($1, $3, '|');	}
		| NOT boolExp			{ $$ = createBoolLogNode(NULL, $2, '!');	}
		| L_PAREN boolExp R_PAREN	{ $$ = $2;	}
		| TRUE			{ $$ = createIntNode(1);	}
		| FALSE			{ $$ = createIntNode(0);	}
;

%%


void yyerror(const char* s)
{
  printf ("%s\n", s);
  exit(-1);
}

int main (int, char**)
{
	initializeVars();	
	yyparse ();
	printf("\n");
	progNode.eval();

	return 0;
}
