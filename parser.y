
/* Infix notation calculator--calc */

%{
#define YYSTYPE double
#include <stdio.h>
#include <math.h>
#include <ctype.h>
%}

/* BISON Declarations */
%token L_PAREN
%token R_PAREN
%token L_CURLY
%token R_CURLY
%token NUMBER
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
;

block:		L_CURLY lines R_CURLY
;

type:		INT_KEYWORD
			| BOOL_KEYWORD
			| ID //will need to make sure the ID is a class or type
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

if_stmt:	IF boolExp stmts ELSE stmts
			| IF boolExp stmts
;

exp:		  NUMBER
			| ID // will need to make sure ID is actually a saved variable
			| exp PLUS exp			{ $$ = $1 + $3;    }
			| exp MINUS exp        	{ $$ = $1 - $3;    }
			| exp TIMES exp        	{ $$ = $1 * $3;    }
			| exp DIVIDE exp        	{ $$ = $1 / $3;    }
			| exp MODULUS exp
			| exp EXPONENT exp
			| MINUS exp  %prec NEG 	{ $$ = -$2; }
			| L_PAREN exp R_PAREN        	{ $$ = $2;         }
;

boolExp:    exp LT exp
			| exp LT_EQUAL exp
			| exp GT  exp
			| exp GT_EQUAL exp
			| exp EQUAL_EQUAL exp
			| exp NOT_EQUAL exp
			| exp AND exp
			| exp OR exp
			| NOT boolExp
			| L_PAREN boolExp R_PAREN
			| TRUE
			| FALSE
;

%%

yyerror (s)  /* Called by yyparse on error */
     char *s;
{
  printf ("%s\n", s);
}

main ()
{
  yyparse ();
  printf("Valid program\n");
}
