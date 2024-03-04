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
#define TK_SEMICOLON 7
#define TK_COMMA 8

#define TK_NUMBER_LITERAL 9
#define TK_STRING_LITERAL 10
#define TK_CHAR_LITERAL 11

#define TK_PLUS 12
#define TK_MINUS 13
#define TK_EXCLAMATION 14
#define TK_TILDA 15
#define TK_AMPERSAND 16
#define TK_ASTERISK 17
#define TK_EQUAL 18
#define TK_FORWARD_SLASH 19
#define TK_PERCENT 20
#define TK_CARET 21
#define TK_GREATER 22
#define TK_LESS 23
#define TK_QUESTION 24
#define TK_PIPE 25

#define TK_INT 26
#define TK_FLOAT 27
#define TK_CHAR 28
#define TK_VOID 29

#define TK_WHILE 30
#define TK_FOR 31
#define TK_DO 32
#define TK_IF 33
#define TK_ELSE 34
#define TK_SWITCH 35
#define TK_CASE 36
#define TK_DEFAULT 37
#define TK_BREAK 38
#define TK_CONTINUE 39
#define TK_RETURN 40
#define TK_GOTO 41

#define TK_IDENTIFIER 42

unordered_map<int,string> lookup = {
	{-1, "COMMENT"},
	{-2, "INCLUDE"},
	{1, "OPEN_P"},
	{2, "CLOSED_P"},
	{3, "OPEN_CB"},
	{4, "CLOSED_CB"},
	{5, "OPEN_SB"},
	{6, "CLOSED_SB"},
	{7, "SEMICOLON"},
	{8, "COMMA"},
	{9, "NUMBER_LITERAL"},
	{10, "STRING_LITERAL"},
	{11, "CHAR_LITERAL"},
	{12, "PLUS"},
	{13, "MINUS"},
	{14, "EXCLAMATION"},
	{15, "TILDA"},
	{16, "AMPERSAND"},
	{17, "ASTERISK"},
	{18, "EQUAL"},
	{19, "FORWARD_SLASH"},
	{20, "PERCENT"},
	{21, "CARET"},
	{22, "GREATER"},
	{23, "LESS"},
	{24, "QUESTION"},
	{25, "PIPE"},
	{26, "INT"},
	{27, "FLOAT"},
	{28, "CHAR"},
	{29, "VOID"},
	{30, "WHILE"},
	{31, "FOR"},
	{32, "DO"},
	{33, "IF"},
	{34, "ELSE"},
	{35, "SWITCH"},
	{36, "CASE"},
	{37, "DEFAULT"},
	{38, "BREAK"},
	{39, "CONTINUE"},
	{40, "RETURN"},
	{41, "GOTO"},
	{42, "IDENTIFIER"}
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
	// +-!~&*=/%^><?|
	// BOOOOO ^
OP [\+\-\!\~\&\*\=\/\%\^\>\<\?\|]
BIT "&="|"|="|"^="|">>="|"<<="

INT "int"|"short"|"unsigned int"|"unsigned short"|"long"|"unsigned long"|"long long"|"unsigned long long"
FLOAT "float"|"double"|"long double"

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
\"[^\"]*\"					{	return TK_STRING_LITERAL;	}
\'[^\']*\'					{	return TK_CHAR;		}
({D}*\.{D}*)|{D}+			{	return TK_NUMBER_LITERAL;	}
\+							{	return TK_PLUS;		}
\-							{	return TK_MINUS;		}
\!							{	return TK_EXCLAMATION;	}
\~							{	return TK_TILDA;	}
\&							{	return TK_AMPERSAND;	}
\*							{	return TK_ASTERISK;	}
\=							{	return TK_EQUAL;	}
\/							{	return TK_FORWARD_SLASH;	}
\%							{	return TK_PERCENT;	}
\^							{	return TK_CARET;	}
\>							{	return TK_GREATER;	}
\<							{	return TK_LESS;		}
\?							{	return TK_QUESTION;	}
\|							{	return TK_PIPE;		}
{INT}						{	return TK_INT;		}
{FLOAT}						{	return TK_FLOAT;	}
"void"						{	return TK_VOID;		}
"char"						{	return TK_CHAR;		}
"while"						{	return TK_WHILE;	}
"for" 						{ 	return TK_FOR;		}
"do" 						{ 	return TK_DO;		}
"if" 						{ 	return TK_IF;		}
"else" 						{ 	return TK_ELSE;		}
"switch" 					{ 	return TK_SWITCH;	}
"case" 						{ 	return TK_CASE;		}
"default" 					{ 	return TK_DEFAULT;	}
"break" 					{ 	return TK_BREAK;	}
"continue" 					{ 	return TK_CONTINUE;	}
"return" 					{ 	return TK_RETURN;	}
"goto"						{ 	return TK_GOTO;		}
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