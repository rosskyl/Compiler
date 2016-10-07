
/* Infix notation calculator--calc */

%{
#define YYSTYPE double
#include <stdio.h>
#include <math.h>
#include <ctype.h>
%}

/* BISON Declarations */
%token NUM
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

line:     	'\n'
			| stmt '\n' 			{ printf("\t%.10g\n", $1); }
			| 'q' '\n'  			{ printf("quitting\n"); exit(0); }
;

stmt:		  if_match {$$ = $1}
			| exp {$$ = $1}
;

if_match:	'i''f' boolExp 't''h''e''n' stmt 'e''l''s''e' stmt	{$$ = $3}
			'i''f' boolExp 't''h''e''n' stmt					{$$ = $3}
;


exp:      	NUM                		{ $$ = $1;         }
			exp '+' exp        		{ $$ = $1 + $3;    }
			| exp '-' exp        	{ $$ = $1 - $3;    }
			| exp '*' exp        	{ $$ = $1 * $3;    }
			| exp '/' exp        	{ $$ = $1 / $3;    }
			| '-' exp  %prec NEG 	{ $$ = -$2;        }
			| exp '^' exp        	{ $$ = pow ($1, $3); }
			| '(' exp ')'        	{ $$ = $2;         }
;

boolExp:    exp '<' exp	     		{$$ = $1;		}
			| exp '<''=' exp		{$$ = $1;		}
			| exp '>'  exp			{$$ = $1;		}
			| exp '>''=' exp		{$$ = $1;		}
			| exp '=''=' exp		{$$ = $1;		}
			| exp '!''=' exp		{$$ = $1;		}
			| exp 'a''n''d' exp		{$$ = $1;		}
			| exp 'o''r' exp		{$$ = $1;		}
			| '!' exp 				{$$ = $1;		}
			| '('boolExp')'			{$$ = $2;		}
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
