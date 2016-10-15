
/* Infix notation calculator--calc */
%output "parser.c"

%{
#include <stdio.h>
#include <math.h>
#include <ctype.h>
#include "globals.h"
#include "scope.h"


extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;


void yyerror(const char* s);

using namespace std;
%}

/* BISON Declarations */
%define api.value.type {float}

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
%left NEG     /* negation--unary minus */
%right '^'    /* exponentiation        */
%left "and" "or" /* for boolean expressions */

%left NOT
%nonassoc LT LT_EQUAL GT GT_EQUAL EQUAL_EQUAL NOT_EQUAL

/* Grammar follows */
%%
program:    /* empty string */
        | program line
;

lines:		  //empty string
			| lines line
;

line:		  separator
			| stmts separator
;

// line separator
separator:	NEWLINE
			| SEMICOLON
;

stmts:		block
			| stmt
;

stmt:		  if_stmt
			| while
			| RETURN exp
			| BREAK
			| CONTINUE
			| PASS
			| assign
			| decl
			| print
;

block:		L_CURLY lines R_CURLY
;

print:		PRINT L_PAREN exp R_PAREN 	{	printf("%g", $3);	}
		| PRINT L_PAREN boolExp R_PAREN	{	printf("%g", $3);	}
;

type:		INT_KEYWORD
			| BOOL_KEYWORD
			//| ID //will need to make sure the ID is a class or type
;

decl:		type ID
			| type ID EQUAL exp
;

assign:		ID EQUAL exp
			| ID PLUS_EQUAL exp
			| ID MINUS_EQUAL exp
			| ID TIMES_EQUAL exp
			| ID DIVIDE_EQUAL exp
			| ID MODULUS_EQUAL exp
;

while:		WHILE boolExp stmts
;

if_stmt:	IF boolExp separator stmts ELSE stmts
			| IF boolExp separator stmts
			| IF boolExp stmts ELSE stmts
			| IF boolExp stmts
;

exp:			INTEGER 			{ $$ = int_value; }
			| FLOAT				{ $$ = float_value; }
			| ID 				{ $$ = globalScope.getVar(id_value); }
			| exp PLUS exp			{ $$ = $1 + $3;	}
			| exp MINUS exp			{ $$ = $1 - $3;	}
			| exp TIMES exp			{ $$ = $1 * $3;	}
			| exp DIVIDE exp		{ $$ = $1 / $3;	}
			//| exp MODULUS exp		{ $$ = $1 % $3;	}
			| exp EXPONENT exp		{ $$ = pow($1,$3);}
			| MINUS exp  %prec NEG	{ $$ = -$2;		}
			| L_PAREN exp R_PAREN	{ $$ = $2;		}
;

boolExp:    exp LT exp	{ $$ = $1 < $3;	}
			| exp LT_EQUAL exp	{ $$ = $1 <= $3;	}
			| exp GT  exp		{ $$ = $1 > $3;		}
			| exp GT_EQUAL exp	{ $$ = $1 >= $3;	}
			| exp EQUAL_EQUAL exp	{ $$ = $1 == $3;	}
			| exp NOT_EQUAL exp	{ $$ = $1 != $3;	}
			| boolExp AND boolExp	{ $$ = $1 && $3;	}
			| boolExp OR boolExp	{ $$ = $1 || $3;	}
			| NOT boolExp		{ $$ = !($2);		}
			| L_PAREN boolExp R_PAREN	{ $$ = $2;	}
			| TRUE			{ $$ = 1;		}
			| FALSE			{ $$ = 0;		}
;

%%

//yyerror (s)  /* Called by yyparse on error */
//     char *s;
void yyerror(const char* s)
{
  printf ("%s\n", s);
}

main (int, char**)
{
  yyparse ();
  printf("\n");
  return 0;
}
