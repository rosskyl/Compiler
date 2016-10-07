
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
%token IF
%token ELSE

%token AND
%token OR
%token NOT
%token TRUE
%token FALSE
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
%token PLUS
%token MINUS
%token DIVIDE
%token TIMES

%token EXPONENT
%token BREAK
%token CONTINUE
%token WHILE
%token RETURN
%token CLASS
%token PASS
%token ID
%token TYPE_KEYWORD
%token INT_KEYWORD
%token BOOL_KEYWORD


%left '-' '+'
%left '*' '/'
%left NEG     /* negation--unary minus */
%right '^'    /* exponentiation        */
%left "and" "or" /* for boolean expressions */

/* Grammar follows */
%%
program:    /* empty string */
        | program line
;

line:		  NEWLINE
			| stmt NEWLINE 			{ printf("\t%.10g\n", $1); }
			| 'q' NEWLINE  			{ printf("quitting\n"); exit(0); }
;

stmt:		exp 	{ $$ = $1;	}
			| boolExp
//			| if_stmt	{ $$ = $1;	}
;

//if_stmt:	'i''f' boolExp stmt 'e''l''s''e' stmt 	{ $$ = $3;	}
//;

exp:		  NUMBER				{ $$ = $1;         }
			| exp PLUS exp			{ $$ = $1 + $3;    }
			| exp MINUS exp        	{ $$ = $1 - $3;    }
			| exp TIMES exp        	{ $$ = $1 * $3;    }
			| exp DIVIDE exp        	{ $$ = $1 / $3;    }
			| MINUS exp  %prec NEG 	{ $$ = -$2;        }
			| L_PAREN exp R_PAREN        	{ $$ = $2;         }
;

boolExp:    exp LT exp	     		{$$ = $1;		}
			| exp LT_EQUAL exp		{$$ = $1;		}
			| exp GT  exp			{$$ = $1;		}
			| exp GT_EQUAL exp		{$$ = $1;		}
			| exp EQUAL_EQUAL exp	{$$ = $1;		}
			| exp NOT_EQUAL exp		{$$ = $1;		}
			| exp AND exp			{$$ = $1;		}
			| exp OR exp			{$$ = $1;		}
			| NOT exp 				{$$ = $1;		}
			| L_PAREN boolExp R_PAREN	{$$ = $2;		}
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
}

/* Lexical analyzer returns a double floating point 
   number on the stack and the token NUM, or the ASCII
   character read if not a number.  Skips all blanks
   and tabs, returns 0 for EOF. */


// yylex ()
// {
  // int c;

  // /* skip white space  */
  // while ((c = getchar ()) == ' ' || c == '\t')  
    // ;
  // /* process numbers   */
  // if (c == '.' || isdigit (c))                
    // {
      // ungetc (c, stdin);
      // scanf ("%lf", &yylval);
      // return NUM;
    // }
  // /* return end-of-file  */
  // if (c == EOF)                            
    // return 0;
  // /* return single chars */
  // return c;                                
// }
