


%option noyywrap

%{
    #include "parser.h"
%}




digit [0-9]

number {digit}*

%%
"("         {	return L_PAREN;	}
")"         {	return R_PAREN;	}
"{"			{	return L_CURLY;	}
"}"			{	return R_CURLY;	}
{number}    {	return NUMBER;	}
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


[a-zA-Z_][a-zA-Z0-9_]* {	return ID;	}
[\t\r]

%%

//http://dinosaur.compilertools.net/flex/flex_19.html

//TODO does not work with (())



int yylex(void);