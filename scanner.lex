

%option outfile="scanner.c"
%option noyywrap

%{
#define YY_DECL extern "C" int yylex()

#include "parser.h"
#include "globals.h"


%}




digit [0-9]

integer {digit}*
float {digit}*\.{digit}+

%%
"("         {	return L_PAREN;	}
")"         {	return R_PAREN;	}
"{"			{	return L_CURLY;	}
"}"			{	return R_CURLY;	}
{float}			{	float_value = atof(yytext);
				return FLOAT;}
{integer}		{	int_value = atoi(yytext);
				return INTEGER;	}
\n			{	return NEWLINE;	}
";"			{	return SEMICOLON;	}
"+="		{	return PLUS_EQUAL;	}
"-="		{	return MINUS_EQUAL;	}
"*="		{	return TIMES_EQUAL;	}
"/="		{	return DIVIDE_EQUAL;	}
"%="		{	return MODULUS_EQUAL;	}
"+"			{	return PLUS;	}
"-"			{	return MINUS;	}
"*"			{	return TIMES;	}
"/"			{	return DIVIDE;	}
"%"			{	return MODULUS;	}
"^"			{	return EXPONENT;}
"="			{	return EQUAL;	}
"=="		{	return EQUAL_EQUAL;	}
"!="		{	return NOT_EQUAL;	}
"<="		{	return LT_EQUAL;	}
"<"			{	return LT;	}
">="		{	return GT_EQUAL;	}
">"			{	return GT;	}
"!"			{	return NOT;	}
if			{	return IF;		}
else		{	return ELSE;	}
while		{	return WHILE;	}
return		{	return RETURN;	}
[tT]rue		{	return TRUE;	}
[fF]alse	{	return FALSE;	}
break		{	return BREAK;	}
continue	{	return CONTINUE;}
pass		{	return PASS;	}
int			{	return INT_KEYWORD;	}
bool		{	return BOOL_KEYWORD;}
type		{	return TYPE_KEYWORD;}
print		{	return PRINT;	}
and		{	return AND;	}
or		{	return OR;	}


[a-zA-Z_][a-zA-Z0-9_]* {	id_value = strdup(yytext);
							return ID;	}
[\t\r]

%%

//http://dinosaur.compilertools.net/flex/flex_19.html




