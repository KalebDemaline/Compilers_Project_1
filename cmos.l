%{
	// Declarations

#include <iostream>
#include <algorithm>
#include <map>

using namespace std;

#define TK_COMMENT -1
#define TK_INCLUDE -2
#define TK_OPEN_P 1
#define TK_CLOSED_P 2
#define TK_OPEN_CB 3
#define TK_CLOSED_CB 4
#define TK_OPEN_SB 5
#define TK_CLOSED_SB 6
#define TK_OPERATOR 7
#define TK_IDENTIFIER 8
#define TK_SEMICOLON 9
#define TK_COMMA 10
#define TK_DATATYPE 11
#define TK_STRING 12
#define TK_CHAR 13
#define TK_NUMBER 14
#define TK_CONTROL 15

unordered_map<int,string> lookup = {
	{-1,"COMMENT"},
	{-2,"INCLUDE"},
	{1,"OPEN_P"},
	{2,"CLOSED_P"},
	{3,"OPEN_CB"},
	{4,"CLOSED_CB"},
	{5,"OPEN_SB"},
	{6,"CLOSED_SB"},
	{7,"OPERATOR"},
	{8,"IDENTIFIER"},
	{9,"SEMICOLON"},
	{10,"COMMA"},
	{11,"DATATYPE"},
	{12,"STRING"},
	{13,"CHAR"},
	{14,"NUMBER"},
	{15,"CONTROL"},
};

int linecount = 1;

void check_for_newline(char c) {if(c == '\n') linecount++;}

%}

L [a-zA-Z]
F [a-zA-Z0-9_]
D [0-9]
OD [0-9Xx#*$]
	// URNARY	++ -- ! ~ & *
	// BINARY	+ - * / % += -= *= /= %=	=	&= |= ^= >>= <<=	== != > < >= <=		&& || 
	// TERTIARY	? :
	// +-!~&*=/%^><?
	// BOOOOO ^
OP [\+\-\!\~\&\*\=\/\%\^\>\<\?\|]
DT "int"|"bool"|"char"|"float"|"double"|"void"
CF "break"|"case"|"continue"|"default"|"do"|"else"|"for"|"if"|"return"|"switch"|"goto"|"while"
	
	// TODO SPLIT UP OPERATORS
	// TODO DATATYPE SPLIT UP

%%
	// Translation Rules
\/\/.*\n					{	linecount++;
								return TK_COMMENT;	}

\/\*[^*|*+^\\]*\*+\/		{	linecount += count(yytext, yytext + strlen(yytext), '\n');
								return TK_COMMENT;	}

#include<[a-z.]*>			{ 	return TK_INCLUDE;	}
#include\"[a-z.]*\"			{ 	return TK_INCLUDE;	}

\(							{	return TK_OPEN_P;	}
\)							{	return TK_CLOSED_P;	}
\{							{	return TK_OPEN_CB;	}
\}							{	return TK_CLOSED_CB;}
\[							{	return TK_OPEN_SB;	}
\]							{	return TK_CLOSED_SB;}
\;							{	return TK_SEMICOLON;}
\,							{	return TK_COMMA;	}
\"[^\"]*\"					{	return TK_STRING;	}
\'[^\']*\'					{	return TK_CHAR;		}
({D}*\.{D}*)|{D}+			{	return TK_NUMBER;	}
{OP}						{	return TK_OPERATOR;	}
{DT}						{	return TK_DATATYPE;	}
{CF}						{	return TK_CONTROL;	}
{F}+						{	return TK_IDENTIFIER;}

[ \t\n\f]					{	check_for_newline(yytext[0]); }

.							{ 	/*Do Nothing*/	}

%%
	// Auxilliary

int yywrap() {return 1;}

int main() {
	int token = 0;
	token = yylex();
	while(token){
		cout << linecount << '\t' << lookup[token] << '\n';
		// cout << token << "\t\t" << linecount << '\n';
		token = yylex();
	}
}	