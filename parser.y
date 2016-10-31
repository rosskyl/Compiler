
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

block:		L_CURLY lines R_CURLY	{	$$ = $2;	}
;

print:		PRINT L_PAREN exp R_PAREN 	//{	printf("%g", $3);	}
		| PRINT L_PAREN boolExp R_PAREN	//{	printf("%g", $3);	}
;

type:		INT_KEYWORD	{	$$ = createTypeNode("int");	}
		| BOOL_KEYWORD	{	$$ = createTypeNode("bool");	}
		//| ID //will need to make sure the ID is a class or type
;

id:		ID	{	$$ = createIDNode(id_value);	}
;

decl:		type id			{	$$ = createDeclNode($2, $1, NULL);	}
		| type id EQUAL exp	{	$$ = createDeclNode($2, $1, $4);	}
;

assign:		id EQUAL exp		{	$$ = createAssignNode($1, $3, '?');	}
		| id PLUS_EQUAL exp	{	$$ = createAssignNode($1, $3, '+');	}
		| id MINUS_EQUAL exp	{	$$ = createAssignNode($1, $3, '-');	}
		| id TIMES_EQUAL exp	{	$$ = createAssignNode($1, $3, '*');	}
		| id DIVIDE_EQUAL exp	{	$$ = createAssignNode($1, $3, '/');	}
		| id MODULUS_EQUAL exp 	{	$$ = createAssignNode($1, $3, '%');	}
;

while:		WHILE boolExp stmts	{	$$ = createWhileNode($2, $3);	}
;

if_stmt:	IF boolExp separator stmts ELSE stmts	{	$$ = createIfNode($2, $4, $6);	}
			| IF boolExp separator stmts	{	$$ = createIfNode($2, $4, NULL);	}
			| IF boolExp stmts ELSE stmts	{	$$ = createIfNode($2, $3, $5);	}
			| IF boolExp stmts		{	$$ = createIfNode($2, $3, NULL);	}
;

exp:	INTEGER 		{	$$ = createIntNode(int_value);	}
	| FLOAT			{	$$ = createFloatNode(float_value);	}
	| id 			//{ $$ = globalScope.getVar(id_value); }
	| exp PLUS exp		{	$$ = createNumExpNode($1, $3, '+');	}
	| exp MINUS exp		{	$$ = createNumExpNode($1, $3, '-');	}
	| exp TIMES exp		{	$$ = createNumExpNode($1, $3, '*');	}
	| exp DIVIDE exp	{	$$ = createNumExpNode($1, $3, '/');	}
	| exp MODULUS exp	{	$$ = createNumExpNode($1, $3, '%');	}
	| exp EXPONENT exp	{	$$ = createNumExpNode($1, $3, '^');	}
	| MINUS exp  %prec NEG
	| L_PAREN exp R_PAREN	{	$$ = $2;	}
;

boolExp:	exp LT exp		{	$$ = createBoolExpNode($1, $3, LT_OP);	}
		| exp LT_EQUAL exp	{	$$ = createBoolExpNode($1, $3, LT_EQ_OP);	}
		| exp GT  exp		{	$$ = createBoolExpNode($1, $3, GT_OP);	}
		| exp GT_EQUAL exp	{	$$ = createBoolExpNode($1, $3, GT_EQ_OP);	}
		| exp EQUAL_EQUAL exp	{	$$ = createBoolExpNode($1, $3, EQ_OP);	}
		| exp NOT_EQUAL exp	{	$$ = createBoolExpNode($1, $3, NOT_EQ_OP);	}
		| boolExp AND boolExp	
		| boolExp OR boolExp	
		| NOT boolExp		{	$$ = createBoolExpNode($2, NULL, NOT_OP);	}
		| L_PAREN boolExp R_PAREN	{	$$ = $2;	}
		| TRUE		{	$$ = createIntNode(1);	}
		| FALSE		{	$$ = createIntNode(0);	}
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
